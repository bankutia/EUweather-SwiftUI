//
//  CurrentWeatherServiceTests.swift
//  EUwerather-SwiftUITests
//
//  Created by ALi on 2019. 12. 27..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
import Combine
@testable import EUweather_SwiftUI

class CurrentWeatherServiceTests: XCTestCase {
    
    var service: WeatherService?
    var disposeBag: Set<AnyCancellable> = .init()
    override func setUp() {
        service = WeatherServiceFactory.getInstance()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetValidCityFulfills() {
        let expectation = self.expectation(description: "WeatherServiceTests")
        _ = service?.getCurrentWeather(by: ["3054643"])
            .sink(receiveCompletion: { value in
                switch value {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { _ in })
            .store(in: &disposeBag)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetWeatherForOneCityWorks() {
        let expectation = self.expectation(description: "")
        
        _ = service?.getCurrentWeather(by: ["3054643"])
            .sink(receiveCompletion: { value in
                switch value {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { dao in
                XCTAssertEqual(1, dao.list.count)
                XCTAssertNotNil(dao.list.first(where: { $0.id == 3054643 }))
            })
            .store(in: &disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetWeatherForTwoCitiesWorks() {
        let expectation = self.expectation(description: "")
        
        _ = service?.getCurrentWeather(by: ["3054643", "2643743"])
            .sink(receiveCompletion: { (value) in
                switch value {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { (dao) in
                XCTAssertEqual(2, dao.list.count)
                XCTAssertNotNil(dao.list.first(where: { $0.id == 3054643 }))
                XCTAssertNotNil(dao.list.first(where: { $0.id == 2643743 }))
            })
            .store(in: &disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetCurrentWeatherWithoutCityCodesWorks() {
        let expectation = self.expectation(description: "")
        
        _ = service?.getCurrentWeather(by: [])
            .sink(receiveCompletion: { (value) in
                switch value {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: { (dao) in
                XCTAssertEqual(0, dao.list.count)
            })
            .store(in: &disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetWeatherIconUrlWorks() {
        let url = service?.getWeatherIconUrl(for: "10d@2x.png")
        XCTAssertEqual(url?.absoluteString, "https://openweathermap.org/img/wn/10d@2x.png")
    }
}
