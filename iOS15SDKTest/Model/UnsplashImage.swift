//
//  UnsplashImage.swift
//  iOS15SDKTest
//
//  Created by Руслан Кукса on 10.06.2021.
//

import Foundation

struct UnsplashResponse: Decodable {
    let totalPages: Int
    let results: [UnsplashImage]
    
    private enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}

struct UnsplashImage: Decodable, Identifiable {
    let id: String
    let urls: [String:String]
    let links: [String:String]
}
