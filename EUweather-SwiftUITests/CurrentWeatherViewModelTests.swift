//
//  CurrentWeatherViewModelTests.swift
//  EUweather-SwiftUITests
//
//  Created by ALi on 2020. 01. 01..
//  Copyright © 2020. ALi. All rights reserved.
//

import XCTest
import Combine
@testable import EUweather_SwiftUI

class CurrentWeatherViewModelTests: XCTestCase {
    
    private var disposeBag = Set<AnyCancellable>()
    private var mockedCurrentWeatherProvider: MockedCurrentWeatherProvider?
    private var mockedUserDefaults: UserDefaults?
    override func setUp() {
        mockedUserDefaults = UserDefaults(suiteName: "mock")
        mockedUserDefaults?.removePersistentDomain(forName: "mock")
        UserDefaultsFactory.mockedInstance = mockedUserDefaults
        mockedCurrentWeatherProvider = MockedCurrentWeatherProvider()
        CurrentWeatherProviderFactory.mockedInstance = mockedCurrentWeatherProvider
    }

    override func tearDown() {
        CurrentWeatherProviderFactory.mockedInstance = .none
    }

    private func getMockCurrentWeather() -> CurrentWeather {
        CurrentWeather(city: City(code: "1", name: "Budapest", countryCode: "HU"), degree: 12.3, iconName: "icon")
    }
    
    func testViewModelWorks() {
        let expectation = self.expectation(description: "testViewModelWorks")
        mockedCurrentWeatherProvider?.mockedResults = [
            ["1"]: Just([getMockCurrentWeather()])
                .mapError{ _ in WeatherProviderError.serviceError(WeatherServiceError.serviceError(""))}
                .eraseToAnyPublisher()
        ]
        mockedUserDefaults?.set(["1"], forKey: Resource.UserDefault.observingCitiesKey)
        
        let viewModel = CurrentWeatherViewModel()
        _ = viewModel.$dataSource
            .sink(receiveValue: { (rowViewModels) in
                guard rowViewModels.count > 0 else { return }
                
                expectation.fulfill()
                XCTAssertEqual(1, rowViewModels.count)
                XCTAssertEqual("1", rowViewModels.first?.cityCode)
            })
        .store(in: &disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
}

private final class MockedCurrentWeatherProvider: CurrentWeatherProviding {
    
    typealias MockedResultsType = [[OpenWeatherCityCode]: AnyPublisher<[CurrentWeather], WeatherProviderError>]
    var mockedResults: MockedResultsType = [:]
    
    func getCurrentWeather(by cityCodes: [OpenWeatherCityCode]) -> AnyPublisher<[CurrentWeather], WeatherProviderError> {
        guard let mockedResult = mockedResults[cityCodes] else {
            fatalError("There is no mock for cityCodes: \(cityCodes)")
        }
        
        return mockedResult
    }
}
