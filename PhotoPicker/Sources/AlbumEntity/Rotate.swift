//
//  Rotate.swift
//
//
//  Created by 한현규 on 3/11/24.
//

import Foundation
import Photos
import UIKit

public struct Rotate: Image{
    public let image: Image
    
    public init(_ photo: Image) {
        self.image = photo
    }
    
    public func loadImage(_ options: PHImageRequestOptions, _ completionHandler: @escaping (UIImage?) -> Void) {
        image.loadImage(options) { image in
            completionHandler(image?.rotate(radians: .pi / 2))
        }
    }
}


extension UIImage {
    public func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(
            origin: CGPoint.zero,
            size: size
        ).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
                        
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(
            x: newSize.width / 2,
            y: newSize.height / 2
        )
        context.rotate(by: CGFloat(radians))
        
        self.draw(
            in: CGRect(
                x: -size.width / 2,
                y: -size.height / 2,
                width: size.width,
                height: size.height
            )
        )
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

