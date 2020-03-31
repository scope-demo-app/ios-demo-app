//
//  RestaurantUncertainTests.swift
//  HambourgeoisieTests
//
//  Created by Ignacio Bonafonte on 06/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

@testable import Hambourgeoisie
import XCTest
import ScopeAgent

class RestaurantUncertainTests: XCTestCase {

    /// This tests performs a request that fails with a rate of 50%. Run it in several test bundles so it shows falkynes in the failure
    func testIntegrationGetRestaurantsNotEmpty_flaky_demo() {
        let expec = expectation(description: "testGetRestaurantsNotEmpty")

        var restArray: [RestaurantShow]?
        ServiceLayer.request(api: .getRestaurants(nil, "50")) { (result: Result<[RestaurantShow], Error>) in
            switch result {
            case let .success(array):
                restArray = array
            case .failure:
                print(result)
            }
            expec.fulfill()
        }

        waitForExpectations(timeout: 30) { error in
            if let error = error {
                SALogger.log("Error: \(error.localizedDescription)",.error)
            }
        }
        XCTAssertNotNil(restArray)
        XCTAssertNotEqual(restArray?.count, 0)
    }
}
