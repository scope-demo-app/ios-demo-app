//
//  IntegrationTests.swift
//  HambourgeoisieTests
//
//  Created by Ignacio Bonafonte on 05/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

@testable import Hambourgeoisie
import XCTest

class IntegrationTests: XCTestCase {
    var idRestaurantsToClean = [String]()

    override func setUp() {
        idRestaurantsToClean.removeAll()
    }

    override func tearDown() {
        idRestaurantsToClean.forEach {
            ServiceLayer.request(api: .deleteRestaurant($0)) { _ in }
        }
    }

    func testIntegrationCreateRestaurantInServerReturnsSameData() {
        let imageData = UIImage(named: "restaurant1")?.jpegData(compressionQuality: 0.5)
        let image = Image(mimeType: "image/jpeg", data: imageData!)
        let restaurant = RestaurantCreate(name: "SwiftTest", images: [image], desc: "my description")

        let expec = expectation(description: "testCreateRestaurantInServerReturnsSameNAme")

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
                print("Error: \(error.localizedDescription)")
            }
        }

        XCTAssertEqual(restaurant?.name, returnedRestaurant?.name)
        XCTAssertEqual(restaurant?.desc, returnedRestaurant?.desc)
        // XCTAssertEqual(restaurant?.images?.first?.data, try? Data(contentsOf: GlobalData.completeURLforResource(resource: returnedRestaurant?.images?.first)!))
    }

    func testIntegrationGetRestaurantsNotEmpty() {
        let expec = expectation(description: "testGetRestaurantsNotEmpty")

        var restArray: [RestaurantShow]?
        ServiceLayer.request(api: .getRestaurants(nil)) { (result: Result<[RestaurantShow], Error>) in
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
                print("Error: \(error.localizedDescription)")
            }
        }
        XCTAssertNotEqual(restArray?.count, 0)
    }

    func testIntegrationGetRestaurantsHaveValidPhoto() {
        let expec = expectation(description: "testGetRestaurantsHaveValidPhoto")

        var restArray: [RestaurantShow]?
        ServiceLayer.request(api: .getRestaurants(nil)) { (result: Result<[RestaurantShow], Error>) in
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
                print("Error: \(error.localizedDescription)")
            }
        }

        restArray?.forEach {
            guard let partialURL = $0.images?.first else { return }
            let imageData = try? Data(contentsOf: GlobalData.completeURLforResource(resource: partialURL)!)
            let uiImage = UIImage(data: imageData ?? Data())
            XCTAssertNotNil(uiImage, "Invalid image data: restaurant:\($0.name). \n URL: \(String(describing: GlobalData.completeURLforResource(resource: $0.images?.first)))")
        }
    }

    func testIntegrationModifyRestaurantName() {
        let originalName = "name1"
        let updatedName = "name2"
        let originalDescription = "desciption 1"
        let updatedDescription = "description 2"

        let imageData = UIImage(named: "restaurant1")?.jpegData(compressionQuality: 0.5)
        let image = Image(mimeType: "image/jpeg", data: imageData!)
        let restaurant = RestaurantCreate(name: originalName, images: [image], desc: originalDescription)

        let expec = expectation(description: "testIntegrationModifyRestaurantName")

        let semaphore = DispatchSemaphore(value: 0)

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

        ServiceLayer.request(api: .getRestaurant(returnedRestaurant!.id)) { (result: Result<RestaurantShow, Error>) in
            switch result {
            case let .success(restaurant):
                XCTAssertEqual(restaurant.name, updatedName)
                XCTAssertEqual(restaurant.desc, updatedDescription)
            case .failure:
                XCTFail()
                return
            }
            expec.fulfill()
        }

        waitForExpectations(timeout: 30) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
