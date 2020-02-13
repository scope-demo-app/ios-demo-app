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

    func testIntegrationGetRestaurantsNotEmpty() {
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
