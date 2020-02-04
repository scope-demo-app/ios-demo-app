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
    var photos: [Data]?
    var rating: Int
    var desc: String?

    enum CodingKeys: String, CodingKey {
        case name
        case id
        case photos
        case rating
        case desc = "description"
    }

    // MARK: Initialization

    init?(id: String, name: String, photos: [Data]?, rating: Int, desc: String?) {
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
        self.photos = photos
        self.rating = rating
        self.desc = desc
    }

}