//
//  CityProviding.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation
import Combine

protocol CityProviding {
    var cities: CitiesByCodes { get }
}

final class CityProviderFactory {
    static var mockedInstance: CityProviding?
    class func getInstance() -> CityProviding {
        mockedInstance ?? CityProvider.sharedProvider
    }
}

private struct OpenWeatherCityCodesJSON: Codable {
    var name: String
    var countryCode: String
}

private final class CityProvider: CityProviding {
    var cities: CitiesByCodes

    static let sharedProvider = CityProvider()

    init() {
        cities = .init()
        _ = Just(Resource.euCapitalsJsonFileName)
            .compactMap { Bundle.main.path(forResource: $0, ofType: "json") }
            .tryMap({ (path) -> Data in
                try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            })
            .mapError({ _ in fatalError("Invalid embeded euCapitals.json")})
            .decode(type: Dictionary<OpenWeatherCityCode,OpenWeatherCityCodesJSON>.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { _ in }) { (citiesByCode) in
                for (key, value) in citiesByCode {
                    self.cities[key] = City(code: key, name: value.name, countryCode: value.countryCode)
                }
            }
    }
}
