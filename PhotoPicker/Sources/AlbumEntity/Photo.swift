//
//  Photo.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import Photos


public struct Photo: Equatable{
    
    public let asset: PHAsset
    
    public init(_ asset: PHAsset) {
        self.asset = asset
    }
    
    public init(){
        self.asset = PHAssetMock()
    }
}



private class PHAssetMock : PHAsset {
    
    let _localIdentifier: String = UUID().uuidString
    let _hash: Int = UUID().hashValue
    
    override var localIdentifier: String {
        return _localIdentifier
    }
    
    override var hash: Int {
        return _hash
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? PHAssetMock else {
            return false
        }
        return self.localIdentifier == object.localIdentifier
    }
}
