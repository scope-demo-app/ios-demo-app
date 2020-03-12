//
//  Restaurant.swift
//  FoodTracker
//
//  Created by Ignacio Bonafonte on 03/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

import os.log
import UIKit

class RestaurantShow: NSObject, Codable {
    // MARK: Properties

    var name: String
    var id: String
    var images: [String]?
    var rating: Double?
    var desc: String?
    var latitude: String?
    var longitude: String?

    override var description: String {
        "--RestaurantShow--\n" +
            "name: \(name)\n" +
            "id: \(id)\n" +
            "rating: \(rating ?? 0)\n" +
            "desc: \(desc ?? "<Empty Desc>")\n" +
            "latitude: \(latitude ?? "No Latitude")\n" +
            "longitude: \(longitude ?? "No Longitude")\n"
    }

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case images
        case rating
        case desc = "description"
        case latitude
        case longitude
    }

    // MARK: Initialization

    init?(id: String, name: String, images: [String]?, rating: Double, desc: String?, latitude: String? = nil, longitude: String? = nil) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }

        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }

        // Initialize stored properties.
        self.name = name
        self.id = id
        self.images = images
        self.rating = rating
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
    }
}
