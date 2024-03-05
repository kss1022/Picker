//
//  UIIMageView+PHAsset.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import UIKit
import Photos


extension UIImageView {
    public func load(_ asset: PHAsset) {
        let manager = PHAssetCacheManager.shared()
        
        if tag == 0 {
            image = nil
        } else{
            manager.cancelImageRequest(PHImageRequestID(tag))
        }
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.version = .current
        options.isSynchronous = false
            
        let id = manager.requestImage(
            for: asset) { [weak self] image, _ in
                self?.image = image
        }
        
        tag = Int(id)
    }
}

