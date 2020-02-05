//
//  ServiceLayer.swift
//  Hambourgeoisie
//
//  Created by Ignacio Bonafonte on 03/02/2020.
//  Copyright © 2020 Undefined Labs. All rights reserved.
//

import Foundation

class ServiceLayer {
    class func request<T: Codable>(api: Api, completion: @escaping (Result<T, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = api.scheme
        components.host = api.host
        components.path = api.path
        components.queryItems = api.parameters
        components.port = api.port

        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method

        if let data = api.data {
            urlRequest.httpBody = data
        }

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                print(error!.localizedDescription)
                return
            }
            guard response != nil else {
                return
            }
            guard let data = data else {
                return
            }

            let responseObject = try! JSONDecoder().decode(T.self, from: data)
            completion(.success(responseObject))

        }
        dataTask.resume()
    }

    class func request(api: Api, completion: @escaping (Result<String, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = api.scheme
        components.host = api.host
        components.path = api.path
        components.queryItems = api.parameters
        components.port = api.port

        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method

        if let data = api.data {
            urlRequest.httpBody = data
        }

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                print(error!.localizedDescription)
                return
            }
            completion(.success(""))
        }
        dataTask.resume()
    }
}
