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
    
    var currentPage: Int = 1
    
    private func fetchImages() async -> [UnsplashImage] {
        
        let fetchParameters: Parameters = [
            "page": currentPage,
            "query": searchText.isEmpty ? "random" : searchText,
            "orientation": "portrait"
        ]
        
        do {
            let images = try await service.fetchImages(fetchParameters)
            return images
        } catch {
            debugPrint(error)
        }
        
        return []
    }
    
    func loadImages() async {
        currentPage = 1
        let images = await fetchImages()
        self.images = images
    }
    
    func loadMoreImages(_ image: UnsplashImage) async {
        if !(image == images.last) {
            return
        }
        
        currentPage += 1
        let newImages = await fetchImages()
        self.images.append(contentsOf: newImages)
    }
    
    func downloadImage(_ image: UnsplashImage) {
        
    }
}

struct AlertState: Identifiable {
    let id = UUID()
    let title: String
    var message: String?
}
