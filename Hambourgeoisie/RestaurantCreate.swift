//
//  Restaurant.swift
//  FoodTracker
//
//  Created by Ignacio Bonafonte on 03/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

import os.log
import UIKit

class RestaurantCreate: NSObject, Codable {
    var name: String
    var photoData: Data?
    var desc: String?

    init?(name: String, photo: Data?, desc: String?) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        self.photoData = photo
        self.desc = desc
    }

    enum CodingKeys: String, CodingKey {
        case name
        case photoData = "photos"
        case desc = "description"
    }
}
