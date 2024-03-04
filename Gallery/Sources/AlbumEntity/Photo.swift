//
//  Photo.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import Photos


public struct Photo{
    
    public let asset: PHAsset
    
    public init(_ asset: PHAsset) {
        self.asset = asset
    }
    
}
