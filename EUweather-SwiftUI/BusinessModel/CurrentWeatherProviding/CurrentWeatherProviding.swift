//
//  WeatherProviding.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation
import Combine

protocol CurrentWeatherProviding {
    func getCurrentWeather(by cityCodes: [OpenWeatherCityCode]) -> AnyPublisher<[CurrentWeather], WeatherProviderError>
}

final class CurrentWeatherProviderFactory {
    static var mockedInstance: CurrentWeatherProviding?
    class func getInstance() -> CurrentWeatherProviding {
        mockedInstance ?? CurrentWeatherProvider()
    }
}

private final class CurrentWeatherProvider: CurrentWeatherProviding, WeatherServiceInjecting, CityProvidingInjected {
    
    private lazy var service: WeatherService = {
        inject()
    }()
    
    func getCurrentWeather(by cityCodes: [OpenWeatherCityCode]) -> AnyPublisher<[CurrentWeather], WeatherProviderError> {
        service.getCurrentWeather(by: cityCodes)
            .mapError { WeatherProviderError.serviceError($0) }
            .map { $0.list.map { $0.toCityWeather(with: self.cityProvider) }}
            .eraseToAnyPublisher()
    }
}

private extension WeatherReportDAO {
    func toCityWeather(with cityProvider: CityProviding) -> CurrentWeather {
        CurrentWeather(city: cityProvider.cities[String(id)] ?? City.empty,
                       degree: self.main.temp,
                       iconName: self.weather.first?.icon ?? Resource.WeatherIcon.defaultName
        )
    }
}
