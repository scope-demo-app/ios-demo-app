//
//  RestaurantShowTests.swift
//  HambourgeoisieTests
//
//  Created by Ignacio Bonafonte on 05/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

@testable import Hambourgeoisie
import XCTest

class RestaurantShowTests: XCTestCase {
    func testRestaurantShowInitializationDescEmptySucceeds() {
        let emptyDescRestaurant = RestaurantShow(id: "888", name: "Name", images: nil, rating: 0, desc: nil)
        XCTAssertNotNil(emptyDescRestaurant)
    }

    func testRestaurantShowInitializationRatingSucceeds() {
        let positiveRatingRestaurant = RestaurantShow(id: "888", name: "Name", images: nil, rating: 5, desc: "description")
        XCTAssertNotNil(positiveRatingRestaurant)
    }

    func testRestaurantShowInitializationFails() {
        let emptyStringRestaurant = RestaurantShow(id: "888", name: "", images: nil, rating: 5, desc: "description")
        XCTAssertNil(emptyStringRestaurant)
    }

    func testRestaurantCreateInitializationElements() {
        let id = "888"
        let name = "the name"
        let images = ["imagePath"]
        let desc = "the description"
        let rating = 2.0

        let rest = RestaurantShow(id: id, name: name, images: images, rating: rating, desc: desc)
        XCTAssertEqual(id, rest!.id)
        XCTAssertEqual(name, rest!.name)
        XCTAssertEqual(images, rest!.images)
        XCTAssertEqual(rating, rest!.rating)
        XCTAssertEqual(desc, rest!.desc)
    }
}
