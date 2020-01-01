//
//  Resource.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

struct Resource {
    static let euCapitalsJsonFileName = "euCapitals"
    
    struct Service {
        struct Arg {
            static let cityIds = "id"
            static let unit = "units"
            static let apiKey = "APPID"
            static let mode = "mode"
        }
        
        struct Values {
            struct Units {
                static let metric = "metric"
            }
            struct Modes {
                static let json = "json"
            }
        }
        
        struct Url {
            static let scheme = "https"
            static let host = "api.openweathermap.org"
            static let path = "/data/2.5"
            static let imagePath = "/img/wn"
        }
    }
    
    struct ImageCloudStorage {
        struct Url {
            static let scheme = "https"
            static let host = "openweathermap.org"
            static let imagePath = "/img/wn"
        }
    }
    
    struct UserDefault {
        static let observingCitiesKey = "observing_cities"
    }
    
    struct WeatherIcon {
        static let defaultName = "03d.png"
    }
}
