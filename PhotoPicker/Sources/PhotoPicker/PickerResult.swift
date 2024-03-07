//
//  PickerResult.swift
//
//
//  Created by 한현규 on 3/7/24.
//

import Foundation
import AlbumEntity
import Photos
import UIKit

public struct PickerResult{
    var photo: Photo
    
    private static let options: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .none
        options.isSynchronous = true
        return options
    }()
    
    init(_ photo: Photo) {
        self.photo = photo
    }
    
    public func loadImage(_ completionHandler: @escaping (UIImage?) -> Void){
        PHImageManager.default().requestImage(
            for: photo.asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .default,
            options: PickerResult.options
        ){ image, _ in
            completionHandler(image)
        }
    }
    
    public static func loadImages(_ results: [PickerResult], _ completionHandler: @escaping ([UIImage?]) -> Void){
        let dispatchGroup = DispatchGroup()
        var convertedImages = [Int: UIImage]()
        
        for (index, image) in results.enumerated() {
            dispatchGroup.enter()
            
            image.loadImage{ resolvedImage in
                if let resolvedImage = resolvedImage {
                    convertedImages[index] = resolvedImage
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            let sortedImages = convertedImages
                .sorted(by: { $0.key < $1.key })
                .map({ $0.value })
            completionHandler(sortedImages)
        })
    }
    
    
    
    public func loadImage() async -> UIImage? {
        await withCheckedContinuation { continuation in
            loadImage{ continuation.resume(returning: $0) }
        }
    }
    
    public static func loadImages(_ results: [PickerResult]) async -> [UIImage?]{
        return await withTaskGroup(of: (Int, UIImage?).self) { taskGroup ->  [UIImage?] in
            for (index, result) in results.enumerated() {
                taskGroup.addTask {
                    return (index, await result.loadImage())
                }
            }
            
            return await taskGroup
                .reduce(into: [(Int,UIImage?)](), { $0.append($1) })
                .sorted(by: { $0.0 < $1.0 })
                .compactMap { $0.1 }
        }
    }
    

    
    public func canLoadImage() -> Bool{
        PHAsset.fetchAssets(withLocalIdentifiers: [photo.asset.localIdentifier], options: .none).firstObject != nil
    }
    
}
