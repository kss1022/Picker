//
//  ImageLoader.swift
//
//
//  Created by 한현규 on 3/11/24.
//

import UIKit
import Photos


public final class ImageLoader{
    
    public static let shared = ImageLoader()
    
    private init(){        
    }
    
    private static let options: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .none
        options.isSynchronous = true
        return options
    }()

    
    public func loadImage(_ image: Image,_ completionHandler: @escaping (UIImage?) -> Void){
        image.loadImage(ImageLoader.options) { image in
            completionHandler(image)
        }
    }

    public func loadImage(_ image: Image) async -> UIImage? {
        await withCheckedContinuation { continuation in            
            loadImage(image){ continuation.resume(returning: $0) }
        }
    }
        
}
