//
//  RestaurantUpdateData.swift
//  Hambourgeoisie
//
//  Created by Ignacio Bonafonte on 05/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

import Foundation

class RestaurantUpdateData: Codable {
    var name: String
    var desc: String?
    var longitude: Double?
    var latitude: Double?

    init?(name: String, desc: String?, longitude: Double?, latitude: Double?) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        self.desc = desc
        self.longitude = longitude
        self.latitude = latitude
    }

    init(restaurantShow: RestaurantShow)
    {
        self.name = restaurantShow.name
        self.desc = restaurantShow.desc
//        self.longitude = restaurantShow.longitude
   //     self.latitude = restaurantShow.latitude
    }

    enum CodingKeys: String, CodingKey {
        case name
        case desc = "description"
        case longitude
        case latitude
    }
}
