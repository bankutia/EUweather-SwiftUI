//
//  City.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

struct City: Codable, Equatable {
    var code: OpenWeatherCityCode
    var name: String
    var countryCode: String
    
    static let empty = City(code: "", name: "", countryCode: "")
}

typealias CitiesByCodes = Dictionary<OpenWeatherCityCode, City>
