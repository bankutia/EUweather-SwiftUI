//
//  CityProvidingTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather_SwiftUI

class CityProvidingTests: XCTestCase {

    var provider: CityProviding?
    override func setUp() {
        provider = CityProviderFactory.getInstance()
    }

    func testCityProviderContainsCities() {
        XCTAssertEqual(26, provider?.cities.count)
        XCTAssertEqual("Budapest", provider?.cities["3054643"]?.name)
    }
}
