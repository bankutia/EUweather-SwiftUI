//
//  WeatherRowTests.swift
//  EUweather-SwiftUITests
//
//  Created by ALi on 2020. 01. 01..
//  Copyright © 2020. ALi. All rights reserved.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import EUweather_SwiftUI

extension WeatherRow: Inspectable {}

class WeatherRowTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewDisplaysViewModel() {
        let weatherRowView = WeatherRow(viewModel: WeatherRowViewModel(currentWeather: CurrentWeather(city: City(code: "1", name: "Budapest", countryCode: "HU"), degree: 12.3, iconName: "icon")))
        
        XCTAssertEqual("Budapest", try? weatherRowView.inspect().hStack().vStack(0).text(1).string())
        XCTAssertEqual("12°", try? weatherRowView.inspect().hStack().text(2).string())
    }
}
