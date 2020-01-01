//
//  CitySelectingViewModel.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 20..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

final class CitySelectingViewModel: ObservableObject, Identifiable, CityProvidingInjected {
    
    typealias CitySelectedAction = (OpenWeatherCityCode) -> Void

    @Published
    var dataSource: [CityRowViewModel]
    
    let disabledCityCodes: [OpenWeatherCityCode]
    let citySelectedAction: CitySelectedAction
    
    init(disabledCityCodes: [OpenWeatherCityCode], citySelectedAction: @escaping CitySelectedAction) {
        self.disabledCityCodes = disabledCityCodes
        self.citySelectedAction = citySelectedAction
        dataSource = .init()
        dataSource = cityProvider.cities.values
            .map { CityRowViewModel(city: $0,
                                    isSelectable: disabledCityCodes.notContains($0.code),
                                    citySelectedAction: { self.citySelectedAction( $0.cityCode )})}
            .sorted(by: { $0.cityName < $1.cityName })
    }
}
