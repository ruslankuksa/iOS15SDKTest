//
//  Service.swift
//  iOS15SDKTest
//
//  Created by Руслан Кукса on 13.06.2021.
//

import Foundation

typealias Parameters = [String:Any]

enum ApiError: Error {
    case badRequest
    case badResponse
    case failedToDecode(Error)
}

struct Service {
    
    private let baseUrl = "https://api.unsplash.com/search/photos"
    private let session = URLSession.shared
    
    func fetchImages(_ query: Parameters) async throws -> [UnsplashImage] {
        guard let request = createRequest(query) else {
            throw ApiError.badRequest
        }
        
        let (data, response) = try await session.data(for: request)
        guard (200...299).contains((response as? HTTPURLResponse)!.statusCode) else { throw
            ApiError.badResponse
        }
        
        let decoder = JSONDecoder()
        do {
            let json = try decoder.decode(UnsplashResponse.self, from: data)
            return json.results
        } catch {
            throw ApiError.failedToDecode(error)
        }
    }
    
    private func createRequest(_ query: Parameters) -> URLRequest? {
        var components = URLComponents(string: baseUrl)
        
        if !query.isEmpty {
            components?.queryItems = query.map {
                URLQueryItem(name: $0, value: "\($1)")
            }
        }
        
        guard let url = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": "Client-ID TLjuRUqfigaXFuuRL6GflA2YHIRCemow-dBGxxYUtjs"
        ]
       
        return request
    }
}

