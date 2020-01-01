//
//  CityRowViewTests.swift
//  EUweather-SwiftUITests
//
//  Created by ALi on 2019. 12. 31..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
import ViewInspector
@testable import EUweather_SwiftUI

extension CityRowView: Inspectable {}

class CityRowViewTests: XCTestCase {

    func testUnselectableViewModelDisplayingWorks() {
        let cityRowView = CityRowView(viewModel: CityRowViewModel(city: City(code: "1", name: "Budapest", countryCode: "HU"), isSelectable: false, citySelectedAction: nil))
        XCTAssertEqual("🇭🇺", try? cityRowView.inspect().hStack().hStack(0).text(0).string())
        XCTAssertEqual(0.5, try? cityRowView.inspect().hStack().hStack(0).opacity())
        
        let cityName = try? cityRowView.inspect().hStack().hStack(0).text(1).string()
        XCTAssertEqual("Budapest", cityName)
    }

    func testSelectableViewModelDisplayingWorks() {
        let cityRowView = CityRowView(viewModel: CityRowViewModel(city: City(code: "1", name: "Budapest", countryCode: "HU"), isSelectable: true, citySelectedAction: nil))
        XCTAssertNoThrow(try cityRowView.inspect().hStack().button(0))
    }

}
