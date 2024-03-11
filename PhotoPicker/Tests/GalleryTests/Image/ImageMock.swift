//
//  ImageMock.swift
//
//
//  Created by 한현규 on 3/11/24.
//


import UIKit
import Photos
import AlbumEntity




struct PhotoMock: Equatable, Image{

    
    let image: UIImage?
    
    init(_ named: String) {
        self.image = UIImage(named: named, in: .module, compatibleWith: nil)
    }
    
    func loadImage(_ options: PHImageRequestOptions, _ completionHandler: @escaping (UIImage?) -> Void) {
        completionHandler(image)
    }
}
