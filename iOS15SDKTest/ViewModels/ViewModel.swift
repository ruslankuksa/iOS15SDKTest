//
//  ViewModel.swift
//  iOS15SDKTest
//
//  Created by Руслан Кукса on 10.06.2021.
//

import Foundation

@MainActor
final class ViewModel: ObservableObject {
    
    private let service = Service()
    
    @Published private(set) var images: [UnsplashImage] = []
    @Published var alert: AlertState?
    @Published var searchText: String = ""
    
    func fetchImages() async {
        let query: Parameters = [
            "page": Int.random(in: 1...50),
            "query": "dog",
            "orientation": "portrait"
        ]
        
        do {
            images = try await service.fetchImages(query)
        } catch {
            alert = AlertState(title: "Error", message: error.localizedDescription)
        }
    }
}

struct AlertState: Identifiable {
    let id = UUID()
    let title: String
    var message: String?
}