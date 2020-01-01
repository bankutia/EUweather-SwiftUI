//
//  CitySelectingViewModelTests.swift
//  EUweather-SwiftUITests
//
//  Created by ALi on 2020. 01. 01..
//  Copyright © 2020. ALi. All rights reserved.
//

import XCTest
@testable import EUweather_SwiftUI

class CitySelectingViewModelTests: XCTestCase {

    private var mockedCityProvifder: MockedCityProvider?
    override func setUp() {
        mockedCityProvifder = MockedCityProvider(mockedCitiesByCodes: [
            "1": City(code: "1", name: "Budapest", countryCode: "HU"),
            "2": City(code: "2", name: "London", countryCode: "GB")
        ])
        CityProviderFactory.mockedInstance = mockedCityProvifder
    }

    override func tearDown() {
        CityProviderFactory.mockedInstance = .none
    }

    func testViewModelWorks() {
        let expectation = self.expectation(description: "CitySelectingViewModelTests")
        let viewModel = CitySelectingViewModel(disabledCityCodes: ["1"], citySelectedAction: { _ in })
        
        _ = viewModel.$dataSource
            .sink { (rowViewModels) in
                XCTAssertNotNil(rowViewModels.first(where: { $0.cityCode == "1" && !$0.isSelectable }))
                XCTAssertNotNil(rowViewModels.first(where: { $0.cityCode == "2" && $0.isSelectable }))
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
