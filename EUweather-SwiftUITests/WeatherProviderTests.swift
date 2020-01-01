//
//  WeatherProviderTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 20..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
import Combine
@testable import EUweather_SwiftUI

class WeatherProviderTests: XCTestCase {

    var provider: CurrentWeatherProviding?
    private var mockedService: MockedWeatherService?
    override func setUp() {
    }

    override func tearDown() {
        WeatherServiceFactory.mockedInstance = .none
    }

    func testGetCurrentWeatherWorks() {
        mockedService = MockedWeatherService(mockedResult:
            Just(getMockCurrentWeatherDAO())
                .tryMap { $0 }
                .mapError { _ in WeatherServiceError.serviceError("") }
                .eraseToAnyPublisher()
        )
        WeatherServiceFactory.mockedInstance = mockedService
        provider = CurrentWeatherProviderFactory.getInstance()
        
        let expectation = self.expectation(description: "WeatherProvidingTest")
        _ = provider?.getCurrentWeather(by: ["123456"])
            .sink(receiveCompletion: { value in
                switch value {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { cityWeathers in
                XCTAssertNotNil(cityWeathers.first(where: { $0.city.countryCode == "GB" && $0.city.name == "London" && $0.degree == 10.5 && $0.iconName == "01d.png" }))
            })
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetCurrentWeatherWithServiceErrorWorks() {
        mockedService = MockedWeatherService(mockedResult:
            Fail<CurrentWeatherDAO, WeatherServiceError>(error: WeatherServiceError.serviceError(""))
                .eraseToAnyPublisher()
        )
        WeatherServiceFactory.mockedInstance = mockedService
        provider = CurrentWeatherProviderFactory.getInstance()

        let expectation = self.expectation(description: "WeatherProvidingTest")
        _ = provider?.getCurrentWeather(by: ["123456"])
            .sink(receiveCompletion: { (value) in
                switch value {
                case .finished:
                    XCTFail()
                case .failure(_):
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func getMockCurrentWeatherDAO() -> CurrentWeatherDAO {
        CurrentWeatherDAO(list: [
            WeatherReportDAO(id: 2643743,
                             name: "London",
                             weather: [WeatherDAO(main: "main", description: "desc", icon: "01d.png")],
                             main: TemperatureDAO(temp: 10.5)
            )
        ])
    }
}
