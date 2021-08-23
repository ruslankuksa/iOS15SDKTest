//
//  API.swift
//  API
//
//  Created by Руслан Кукса on 22.08.2021.
//

import Foundation

enum Endpoint {
    case searchPhotos
    
    var route: String {
        switch self {
        case .searchPhotos:
            return "/search/photos"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
}

struct NetworkRequest {
    let method: HTTPMethod
    let endpoint: Endpoint
    var parameters: Parameters = [:]
    var headers: Headers = ["Content-Type": "application/json"]
    var body: Data? = nil
}
