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
        let emptyDescRestaurant = RestaurantCreate(name: "Zero", image: nil, desc: nil)
        XCTAssertNotNil(emptyDescRestaurant)

        let positiveRatingRestaurant = RestaurantCreate(name: "Positive", image: nil, desc: "My description")
        XCTAssertNotNil(positiveRatingRestaurant)
    }

    func testRestaurantCreateInitializationFails() {
        let emptyStringRestaurant = RestaurantCreate(name: "", image: nil, desc: "")
        XCTAssertNil(emptyStringRestaurant)
    }

    func testRestaurantCreateInitializationElements() {
        let name = "the name"
        let image = Data()
        let desc = "the description"

        let restaurant = RestaurantCreate(name: name, image: image, desc: desc)
        XCTAssertEqual(name, restaurant?.name)
        XCTAssertEqual(image, restaurant?.images?.first?.data)
        XCTAssertEqual(desc, restaurant?.desc)
    }
}
