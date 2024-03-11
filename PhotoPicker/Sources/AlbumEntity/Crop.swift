//
//  Crop.swift
//
//
//  Created by 한현규 on 3/11/24.
//

import Foundation
import Photos
import UIKit


public struct Crop: Image{

    public let image: Image
    public let rect: CGRect
    
    public init(_ image: Image, _ rect: CGRect) {
        self.image = image
        self.rect = rect
    }
    
    public func loadImage(_ options: PHImageRequestOptions, _ completionHandler: @escaping (UIImage?) -> Void) {
        image.loadImage(options) { image in
            completionHandler(image?.crop(rect: rect))
        }
    }
    
    
}


extension UIImage {
            
    public func crop(rect: CGRect) -> UIImage? {
        let scale = self.scale
        let cropRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        
        guard let croppedImage = self.cgImage?.cropping(to: cropRect) else {
            return nil
        }
                
        let image = UIImage(
            cgImage: croppedImage,
            scale: self.scale,
            orientation: self.imageOrientation
        )
        return image
    }
    
}
