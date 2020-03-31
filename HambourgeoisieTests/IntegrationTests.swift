//
//  IntegrationTests.swift
//  HambourgeoisieTests
//
//  Created by Ignacio Bonafonte on 05/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

@testable import Hambourgeoisie
import ScopeAgent
import XCTest

class IntegrationTests: XCTestCase {
    var idRestaurantsToClean = [String]()

    override func setUp() {
        idRestaurantsToClean.removeAll()
        SALogger.log("Ended setting up the test", .debug)
    }

    override func tearDown() {
        SALogger.log("Start tearing down the test", .debug)
        idRestaurantsToClean.forEach {
            ServiceLayer.request(api: .deleteRestaurant($0)) { _ in }
        }
    }

    func testIntegrationCreateRestaurantInServerReturnsSameData_demo() {
        let imageData = UIImage(named: "restaurant1")?.jpegData(compressionQuality: 0.5)
        let image = Image(mimeType: "image/jpeg", data: imageData!)
        let restaurant = RestaurantCreate(name: "SwiftTest", images: [image], desc: "my description")

        let expec = expectation(description: "testCreateRestaurantInServerReturnsSameNAme")

        SALogger.log("Create a new Restaurant", .info)
        var returnedRestaurant: RestaurantShow?
        ServiceLayer.request(api: .createRestaurant(restaurant!)) { (result: Result<RestaurantShow, Error>) in
            switch result {
            case let .success(restaurant):
                returnedRestaurant = restaurant
                self.idRestaurantsToClean.append(restaurant.id)
                XCTAssert(true)
            case .failure:
                XCTFail()
                return
            }
            expec.fulfill()
        }

        waitForExpectations(timeout: 30) { error in
            if let error = error {
                SALogger.log("Error: \(error.localizedDescription)", .error)
            }
        }
        SALogger.log("Check values are the same than created", .info)
        XCTAssertEqual(restaurant?.name, returnedRestaurant?.name)
        XCTAssertEqual(restaurant?.desc, returnedRestaurant?.desc)
        XCTAssertEqual(restaurant?.images?.first?.data, try? Data(contentsOf: GlobalData.completeURLforResource(resource: returnedRestaurant?.images?.first)!))
    }

    func testIntegrationGetRestaurantsNotEmpty_demo() {
        let expec = expectation(description: "testGetRestaurantsNotEmpty")

        var restArray: [RestaurantShow]?
        SALogger.log("Geting restaurants", .info)
        ServiceLayer.request(api: .getRestaurants(nil)) { (result: Result<[RestaurantShow], Error>) in
            switch result {
            case let .success(array):
                SALogger.log("Rstaurants: \(array)", .info)

                restArray = array
            case .failure:
                SALogger.log("Error: \(result)", .error)
            }
            expec.fulfill()
        }

        waitForExpectations(timeout: 30) { error in
            if let error = error {
                SALogger.log("Error: \(error.localizedDescription)", .error)
            }
        }
        XCTAssertNotEqual(restArray?.count, 0)
    }

    func testIntegrationCreateRestaurantWithLongName_demo() {
        let imageData = UIImage(named: "restaurant1")?.jpegData(compressionQuality: 0.5)
        let image = Image(mimeType: "image/jpeg", data: imageData!)
        let restaurant = RestaurantCreate(name: "This is a very long name for a restaurant name in a test that checks if it works", images: [image], desc: "my description")

        let expec = expectation(description: "testIntegrationCreateRestaurantWithLongName")

        SALogger.log("Create a new Restaurant", .info)
        ServiceLayer.request(api: .createRestaurant(restaurant!)) { (result: Result<RestaurantShow, Error>) in
            switch result {
            case let .success(restaurant):
                self.idRestaurantsToClean.append(restaurant.id)
                XCTAssert(true)
            case .failure:
                XCTFail()
                return
            }
            expec.fulfill()
        }

        waitForExpectations(timeout: 30) { error in
            if let error = error {
                SALogger.log("Error: \(error.localizedDescription)", .error)
            }
        }
    }

    func testIntegrationModifyRestaurantName_demo() {
        let originalName = "name1"
        let updatedName = "name2"
        let originalDescription = "desciption 1"
        let updatedDescription = "description 2"

        let imageData = UIImage(named: "restaurant1")?.jpegData(compressionQuality: 0.5)
        let image = Image(mimeType: "image/jpeg", data: imageData!)
        let restaurant = RestaurantCreate(name: originalName, images: [image], desc: originalDescription)

        let expec = expectation(description: "testIntegrationModifyRestaurantName")

        let semaphore = DispatchSemaphore(value: 0)

        SALogger.log("Create a new Restaurant: \(restaurant!)", .info)

        var returnedRestaurant: RestaurantShow?
        ServiceLayer.request(api: .createRestaurant(restaurant!)) { (result: Result<RestaurantShow, Error>) in
            switch result {
            case let .success(restaurant):
                returnedRestaurant = restaurant
                self.idRestaurantsToClean.append(restaurant.id)
                XCTAssert(true)
            case .failure:
                XCTFail()
                return
            }
            semaphore.signal()
        }
        semaphore.wait()

        let newData = RestaurantUpdateData(restaurantShow: returnedRestaurant!)
        newData.name = updatedName
        newData.desc = updatedDescription
        SALogger.log("Modify the restaurant: \(newData)", .info)

        ServiceLayer.request(api: .updateRestaurant(returnedRestaurant!.id, newData)) { (result: Result<String, Error>) in
            switch result {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTFail()
                return
            }
            semaphore.signal()
        }
        semaphore.wait()

        SALogger.log("Get updated data: \(newData)", .info)

        ServiceLayer.request(api: .getRestaurant(returnedRestaurant!.id)) { (result: Result<RestaurantShow, Error>) in
            switch result {
            case let .success(restaurant):
                XCTAssertEqual(restaurant.name, updatedName)
                XCTAssertEqual(restaurant.desc, updatedDescription)
            case .failure:
                XCTFail()
            }
            expec.fulfill()
        }

        waitForExpectations(timeout: 30) { error in
            if let error = error {
                SALogger.log("Error: \(error.localizedDescription)", .error)
            }
        }
    }
}
