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
    var image: Image
    
    init(_ image: Image) {
        self.image = image
    }
    
    public func loadImage(_ completionHandler: @escaping (UIImage?) -> Void){
        ImageLoader.shared.loadImage(image) {
            completionHandler($0)
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
        //TODO: check fetch Assets
        //PHAsset.fetchAssets(withLocalIdentifiers: [image.asset.localIdentifier], options: .none).firstObject != nil        
        true
    }
    
}
