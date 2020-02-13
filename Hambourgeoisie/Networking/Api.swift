//
//  Api.swift
//  Hambourgeoisie
//
//  Created by Ignacio Bonafonte on 03/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

import Foundation

struct GlobalData {
    static let scheme = "https"
    static let host = "go-demo-app.undefinedlabs.dev"
    static let port: Int? = nil


    static func completeURLforResource(resource: String?) -> URL? {
        guard let resource = resource else { return nil}
        var components = URLComponents()
        components.host = GlobalData.host
        components.scheme = GlobalData.scheme
        if GlobalData.port != nil {
            components.port = GlobalData.port
        }
        components.path = resource
        return components.url
    }
}

enum Api {
    case createRestaurant(RestaurantCreate)
    case deleteRestaurant(String)
    case updateRestaurant(String, RestaurantUpdateData)
    case getRestaurant(String)
    case getRestaurants(String?, String? = nil)

    var scheme: String {
        switch self {
        case .createRestaurant, .deleteRestaurant, .updateRestaurant, .getRestaurant, .getRestaurants:
            return GlobalData.scheme
        }
    }

    var host: String {
        switch self {
        default:
            return GlobalData.host
        }
    }

    var port: Int? {
        switch self {
        default:
            return GlobalData.port
        }
    }

    var path: String {
        switch self {
        case .createRestaurant:
            return "/restaurants"
        case let .deleteRestaurant(id):
            return "/restaurants/\(id)"
        case let .updateRestaurant(id, _):
            return "/restaurants/\(id)"
        case let .getRestaurant(id):
            return "/restaurants/\(id)"
        case .getRestaurants:
            return "/restaurants"
        }
    }

    var parameters: [URLQueryItem]? {
        switch self {
        case .createRestaurant, .deleteRestaurant, .updateRestaurant, .getRestaurant:
            return []
        case let .getRestaurants(name, failureRate):
            
            var param = [URLQueryItem]()
            if name != nil {
                param.append(URLQueryItem(name: "name", value: name))
            }
            
            if failureRate != nil {
                param.append(URLQueryItem(name: "rs.failure", value: failureRate))
            }
            
            if param.count > 0 {
                return param
            } else {
                return nil
            }
        }
    }

    var method: String {
        switch self {
        case .createRestaurant:
            return "POST"
        case .deleteRestaurant:
            return "DELETE"
        case .updateRestaurant:
            return "PATCH"
        case .getRestaurant, .getRestaurants:
            return "GET"
        }
    }

    var data: Data? {
        switch self {
        case .createRestaurant(let restaurant):
            return try? JSONEncoder().encode(restaurant)
        case .updateRestaurant(_, let restaurant):
            return try? JSONEncoder().encode(restaurant)
        case .deleteRestaurant, .getRestaurant, .getRestaurants:
            return nil
        }
    }
}
