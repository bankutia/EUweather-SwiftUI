//
//  MockedCityProvider.swift
//  EUweather-SwiftUITests
//
//  Created by ALi on 2020. 01. 01..
//  Copyright © 2020. ALi. All rights reserved.
//

import Foundation
@testable import EUweather_SwiftUI

final class MockedCityProvider: CityProviding {
    var mockedCitiesByCodes: CitiesByCodes
    var cities: CitiesByCodes {
        mockedCitiesByCodes
    }
    
    init(mockedCitiesByCodes: CitiesByCodes) {
        self.mockedCitiesByCodes = mockedCitiesByCodes
    }
}
