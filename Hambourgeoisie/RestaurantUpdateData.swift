//
//  RestaurantUpdateData.swift
//  Hambourgeoisie
//
//  Created by Ignacio Bonafonte on 05/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

import Foundation

class RestaurantUpdateData: Codable, CustomStringConvertible {
    var name: String
    var desc: String?
    var longitude: Double?
    var latitude: Double?

    var description: String {
        "--RestaurantUpdateData--\n" +
            "name: \(name)\n" +
            "desc: \(String(describing: desc))\n" +
            "longitude: \(String(describing: longitude))\n" +
            "latitude: \(String(describing: latitude))\n"
    }

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

    init(restaurantShow: RestaurantShow) {
        name = restaurantShow.name
        desc = restaurantShow.desc
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
