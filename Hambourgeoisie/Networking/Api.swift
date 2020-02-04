//
//  Api.swift
//  Hambourgeoisie
//
//  Created by Ignacio Bonafonte on 03/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

import Foundation

enum Api {
    case createRestaurant(RestaurantCreate)
    case deleteRestaurant(String)
    case editRestaurant(RestaurantShow)
    case getRestaurant(String)
    case getRestaurants(String?)

    var scheme: String {
        switch self {
        case .createRestaurant, .deleteRestaurant, .editRestaurant, .getRestaurant, .getRestaurants:
            return "http"
        }
    }

    var host: String {
        switch self {
        default:
            return "192.168.1.215:8081"
        }
    }

    var path: String {
        switch self {
        case .createRestaurant:
            return "/restaurants"
        case let .deleteRestaurant(id):
            return "/restaurants/\(id)"
        case let .editRestaurant(id):
            return "/restaurants/\(id)"
        case let .getRestaurant(id):
            return "/restaurants/\(id)"
        case .getRestaurants:
            return "/restaurants"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .createRestaurant, .deleteRestaurant, .editRestaurant, .getRestaurant:
            return []
        case let .getRestaurants(string):
            if string != nil {
                return [URLQueryItem(name: "name", value: string)]
            } else {
                return []
            }
        }
    }

    var method: String {
        switch self {
        case .createRestaurant:
            return "POST"
        case .deleteRestaurant:
            return "DELETE"
        case .editRestaurant:
            return "PATCH"
        case .getRestaurant, .getRestaurants:
            return "GET"
        }
    }

    var data: Data? {
        switch self {
        case .createRestaurant(let restaurant):
            return try? JSONEncoder().encode(restaurant)
        case .editRestaurant(let restaurant):
            return try? JSONEncoder().encode(restaurant)
        case .deleteRestaurant, .getRestaurant, .getRestaurants:
            return nil
        }
    }
}
