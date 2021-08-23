//
//  GalleryService.swift
//  GalleryService
//
//  Created by Руслан Кукса on 22.08.2021.
//

import Foundation
import Photos

struct GalleryService {
    private let albumName = "Good Wallpapers"
    
    func createAlbum() {
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            }
            
            debugPrint("Album Created")
        } catch {
            debugPrint("Failed to create album")
        }
    }
    
    func saveImage(_ imageUrl: URL) {
        guard let assetCollection = fetchCollectionForAlbum() else {
            return
        }
        
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageUrl)
                let assetPlaceholder = assetChangeRequest?.placeholderForCreatedAsset
                
                if let albumChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection) {
                    guard let asset = assetPlaceholder else { return }
                    let enumeration: NSArray = [asset]
                    albumChangeRequest.addAssets(enumeration)
                }
            }
        } catch {
            debugPrint("Failed to save image in album")
        }
    }
    
    func fetchCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                 subtype: .any,
                                                                 options: fetchOptions)
        if let collectionObject = collection.firstObject {
            return collectionObject
        }
        
        return nil
    }
}
