//
//  HambourgeoisieTests.swift
//  HambourgeoisieTests
//
//  Created by Ignacio Bonafonte on 03/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

@testable import Hambourgeoisie
import XCTest

class RestaurantCreateTests: XCTestCase {

    func testRestaurantCreateInitializationSucceeds() {
        let emptyDescRestaurant = RestaurantCreate(name: "Zero", photo: nil, desc: nil)
        XCTAssertNotNil(emptyDescRestaurant)

        let positiveRatingRestaurant = RestaurantCreate(name: "Positive", photo: nil, desc: "My description")
        XCTAssertNotNil(positiveRatingRestaurant)
    }

    func testRestaurantCreateInitializationFails() {
        let emptyStringRestaurant = RestaurantCreate(name: "", photo: nil, desc: "")
        XCTAssertNil(emptyStringRestaurant)
    }

    func testRestaurantCreateInitializationElements() {
        let name = "the name"
        let photo = Data()
        let description = "the description"

        let emptyDescRestaurant = RestaurantCreate(name: name, photo: photo, desc: description)
        XCTAssertEqual(name, name)
        XCTAssertEqual(photo, photo)
        XCTAssertEqual(description, description)
    }
}
