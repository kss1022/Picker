//
//  Capture.swift
//
//
//  Created by 한현규 on 3/12/24.
//

import UIKit
import Photos


public struct Capture: Image{
    
    private let image: UIImage
    
    public init(_ image: UIImage){
        self.image = image
    }
    
    public func loadImage(_ options: PHImageRequestOptions, _ completionHandler: @escaping (UIImage?) -> Void) {
        completionHandler(image)
    }
    
    public func saveImage() async throws{
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
            print("PHPCameraRepository save captur image")
        }
    }
    
}
