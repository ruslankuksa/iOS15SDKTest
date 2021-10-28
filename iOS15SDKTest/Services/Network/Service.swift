//
//  Service.swift
//  iOS15SDKTest
//
//  Created by Руслан Кукса on 13.06.2021.
//

import Foundation

enum ApiError: Error {
    case badRequest
    case badResponse(Int)
    case failedToDecode(Error)
    case unknownError
}

protocol NetworkService: Executor {
    func fetchImages(_ request: NetworkRequest) async throws -> UnsplashResponse
}

struct NetworkManager: NetworkService {
    
    func fetchImages(_ request: NetworkRequest) async throws -> UnsplashResponse {
        return try await execute(request)
    }
}

