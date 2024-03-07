//
//  PHAssetCacheManager.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import Photos
import UIKit.UIImage


public final class PHAssetCacheManager: PHCachingImageManager{
    
    
    public static func shared() -> PHAssetCacheManager{
        if self.instance == nil{
            PHAssetCacheManager.instance = PHAssetCacheManager()
        }
        
        return instance!
    }
        
    private static var instance : PHAssetCacheManager?
    
    private let contentMode: PHImageContentMode
    private let targetSize: CGSize
    private let requestOption: PHImageRequestOptions
    
    
    public func startCachingImages(for assets: [PHAsset]) {
        self.startCachingImages(
            for: assets,
            targetSize: targetSize,
            contentMode: contentMode,
            options: requestOption
        )
    }
    
    public func stopCachingImages(for assets: [PHAsset]) {
        self.stopCachingImages(
            for: assets,
            targetSize: targetSize,
            contentMode: contentMode,
            options: requestOption
        )
    }
    
    public override func stopCachingImagesForAllAssets() {
        super.stopCachingImagesForAllAssets()
        PHAssetCacheManager.instance = nil
    }
    
    public func requestImage(for asset: PHAsset, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID{
        return self.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: contentMode,
            options: requestOption) {
                resultHandler($0, $1)
            }
    }
        
    private override init() {
        self.contentMode = .aspectFill
        self.targetSize = .init(width: 300.0, height: 300.0)
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.version = .current
        options.isSynchronous = false
        
        self.requestOption = options
    }
}




