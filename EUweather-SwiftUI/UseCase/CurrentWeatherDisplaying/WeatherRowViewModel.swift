//
//  WeatherDisplayRowViewModel.swift
//  EUerayher-SwiftUI
//
//  Created by ALi on 2019. 12. 26..
//  Copyright © 2019. ALi. All rights reserved.
//

import SwiftUI

class WeatherRowViewModel: ObservableObject, Identifiable, WeatherServiceInjecting {
    
    var cityName: String {
        currentWeather.city.name
    }
    var degree: String {
        currentWeather.degree.toDisplayString()
    }
    var iconUrl: URL? {
        service.getWeatherIconUrl(for: currentWeather.iconName.imageFileName)
    }
    var cityCode: String {
        currentWeather.city.code
    }
    
    private let currentWeather: CurrentWeather
    private lazy var service: WeatherService = {
        inject()
    }()
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
}

private extension String {
    var imageFileName: String {
        "\(self)@2x.png"
    }
}

private extension Double {
    func toDisplayString() -> String {
        "\(Int(self.rounded()))\u{00b0}"
    }
}
