//
//  Executor.swift
//  Executor
//
//  Created by Руслан Кукса on 22.08.2021.
//

import Foundation

protocol Executor {
    var decoder: JSONDecoder { get }
    var session: URLSession { get }
    var baseUrl: String { get }
    func execute<T: Codable>(_ request: NetworkRequest) async throws -> T
    func createRequest(_ networkRequest: NetworkRequest) -> URLRequest?
}

extension Executor {
    var baseUrl: String {
        return "https://api.unsplash.com"
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    var session: URLSession {
        return URLSession.shared
    }
    
    func execute<T: Codable>(_ request: NetworkRequest) async throws -> T {
        
        guard let request = createRequest(request) else {
            throw ApiError.badRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw ApiError.unknownError
        }
        
        let statusCode = response.statusCode
        
        if (200...299).contains(statusCode) {
            do {
                let data = try decoder.decode(T.self, from: data)
                return data
            } catch {
                throw ApiError.failedToDecode(error)
            }
        } else {
            throw ApiError.badResponse(statusCode)
        }
    }
    
    func createRequest(_ networkRequest: NetworkRequest) -> URLRequest? {
        var components = URLComponents(string: baseUrl + networkRequest.endpoint.route)
        
        if !networkRequest.parameters.isEmpty {
            let queryItems = networkRequest.parameters.map {
                URLQueryItem(name: $0, value: "\($1)")
            }
            components?.queryItems = queryItems
        }
        
        guard let url = components?.url else {
            debugPrint("Bad url")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = networkRequest.method.rawValue
        request.allHTTPHeaderFields = networkRequest.headers
        request.addValue(
            "Client-ID TLjuRUqfigaXFuuRL6GflA2YHIRCemow-dBGxxYUtjs",
            forHTTPHeaderField: "Authorization"
        )
        
        if let body = networkRequest.body {
            request.httpBody = body
        }
        
        return request
    }
}
