//
//  MockedWeatherService.swift
//  EUweather-SwiftUITests
//
//  Created by ALi on 2020. 01. 01..
//  Copyright © 2020. ALi. All rights reserved.
//

import Foundation
import Combine
@testable import EUweather_SwiftUI

final class MockedWeatherService: WeatherService {
    var callerCityIds: [OpenWeatherCityCode] = .init()
    var mockedResult: AnyPublisher<CurrentWeatherDAO, WeatherServiceError>
    
    init(mockedResult: AnyPublisher<CurrentWeatherDAO, WeatherServiceError>) {
        self.mockedResult = mockedResult
    }
    
    func getCurrentWeather(by cityIds: [OpenWeatherCityCode]) -> AnyPublisher<CurrentWeatherDAO, WeatherServiceError> {
        callerCityIds = cityIds
        return mockedResult
    }

    func getWeatherIconUrl(for iconFileName: String) -> URL? {
        nil
    }
}
