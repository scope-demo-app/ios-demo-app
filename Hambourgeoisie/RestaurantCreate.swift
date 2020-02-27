//
//  Restaurant.swift
//  FoodTracker
//
//  Created by Ignacio Bonafonte on 03/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

import os.log
import UIKit

struct Image: Codable {
    var mimeType: String
    var data: Data
}

class RestaurantCreate: NSObject, Codable {
    var name: String
    var images: [Image]?
    var desc: String?
    
    override var description: String {
        "--RestaurantCreate--\n" +
            "name: \(name)\n" +
            "images: \(images?.count ?? 0)\n" +
            "longitude: \(String(describing: desc))\n"
    }

    init?(name: String, images: [Image]?, desc: String?) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        self.images = images
        self.desc = desc
    }

    init?(name: String, image: Data?, desc: String?) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        if(image != nil) {
            self.images = [Image(mimeType: "image/jpeg", data: image!)]
        }
        self.desc = desc
    }

    enum CodingKeys: String, CodingKey {
        case name
        case images
        case desc = "description"
    }
}
