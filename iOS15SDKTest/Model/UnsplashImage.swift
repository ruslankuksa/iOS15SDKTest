//
//  UnsplashImage.swift
//  iOS15SDKTest
//
//  Created by Руслан Кукса on 10.06.2021.
//

import Foundation

struct UnsplashResponse: Decodable, Equatable {
    let totalPages: Int
    let results: [UnsplashImage]
}

struct UnsplashImage: Decodable, Identifiable, Equatable {
    let id: String
    let urls: [String:String]
    let links: [String:String]
}
