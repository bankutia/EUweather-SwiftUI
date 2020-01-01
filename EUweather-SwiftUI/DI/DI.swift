//
//  DI.swift
//  EUweather
//
//  Created by Attila Bánkuti on 2019. 12. 19..
//  Copyright © 2019. mobilefriends. All rights reserved.
//

import Foundation

protocol WeatherServiceInjecting {}
extension WeatherServiceInjecting {
    func inject() -> WeatherService {
        WeatherServiceFactory.getInstance()
    }
}

protocol CityProvidingInjected {}
extension CityProvidingInjected {
    var cityProvider: CityProviding {
        CityProviderFactory.getInstance()
    }
}

protocol CurrentWeatherProvidingInjecting {}
extension CurrentWeatherProvidingInjecting {
    func inject() -> CurrentWeatherProviding {
        CurrentWeatherProviderFactory.getInstance()
    }
}

protocol UserDefaultsInjecting {}
extension UserDefaultsInjecting {
    func inject() -> UserDefaults {
        UserDefaultsFactory.getInstance()
    }
}

protocol AppStateChangeNotifyingInjected {}
extension AppStateChangeNotifyingInjected {
    var appStateChangeNotifier: AppStateChangeNotifying {
        AppStateChangeNotifierFactory.getInstance()
    }
}
