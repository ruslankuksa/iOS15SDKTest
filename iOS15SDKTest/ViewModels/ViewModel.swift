//
//  ViewModel.swift
//  iOS15SDKTest
//
//  Created by Руслан Кукса on 10.06.2021.
//

import Foundation

@MainActor
final class ViewModel: ObservableObject {
    
    private let service: NetworkService
    
    @Published private(set) var images: [UnsplashImage] = []
    @Published var alert: AlertState?
    @Published var searchText: String = ""
    
    var currentPage: Int = 1
    
    init(service: NetworkService = NetworkManager()) {
        self.service = service
    }
    
    private func fetchImages() async -> [UnsplashImage] {
        
        let fetchParameters: Parameters = [
            "page": currentPage,
            "query": searchText.isEmpty ? "random" : searchText,
            "orientation": "portrait"
        ]
        
        let request = NetworkRequest(
            method: .get,
            endpoint: .searchPhotos,
            parameters: fetchParameters
        )
        
        do {
            let response = try await service.fetchImages(request)
            return response.results
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
        if image != images.last {
            return
        }
        
        currentPage += 1
        let newImages = await fetchImages()
        self.images.append(contentsOf: newImages)
    }
    
    func downloadImage(_ image: UnsplashImage) async {
        guard let link = image.links["download"],
              let imageURL = URL(string: link) else {
            debugPrint("No download URL")
            return
        }
        
        do {
            async let imageData = Data(contentsOf: imageURL)
            saveToTempDirectory(try await imageData)
            debugPrint("Image downloaded")
        } catch {
            debugPrint("Donwload image error: \(error)")
        }
    }
    
    func saveToTempDirectory(_ data: Data) {
        let tempPath = NSTemporaryDirectory()
        let tempUrl = URL(fileURLWithPath: tempPath, isDirectory: true)
        let targetUrl = tempUrl.appendingPathComponent("\(Date().timeIntervalSince1970)", conformingTo: .jpeg)
        
        do {
            try data.write(to: targetUrl, options: .atomic)
        } catch {
            debugPrint("Failed to save image in temp directory")
        }
    }
}

struct AlertState: Identifiable {
    let id = UUID()
    let title: String
    var message: String?
}
