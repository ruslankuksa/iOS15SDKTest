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
    
    func fetchImages() async {
        let query: Parameters = [
            "page": Int.random(in: 1...10),
            "query": "girl",
            "orientation": "portrait"
        ]
        
        do {
            images = try await service.fetchImages(query)
        } catch {
            debugPrint(error.localizedDescription)
            alert = AlertState(title: "Error", message: error.localizedDescription)
        }
    }
}

struct AlertState: Identifiable {
    let id = UUID()
    let title: String
    var message: String?
}
