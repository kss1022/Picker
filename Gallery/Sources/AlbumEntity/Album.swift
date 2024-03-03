//
//  Album.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import Photos


public struct Album: Equatable{
    
    private static let fetchOptions: PHFetchOptions = {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return options
    }()
    
    private let collection: PHAssetCollection
                            
    public init(_ collection: PHAssetCollection){
        self.collection = collection
    }
    
    public init(){
        self.collection = PHAssetCollectionMock()
    }
    
    public func name() -> String?{
        collection.localizedTitle
    }
        
    public func fetchAssets() -> PHFetchResult<PHAsset>{
        PHAsset.fetchAssets(in: collection, options: Album.fetchOptions)
    }
    
    
    public static func ==(lhs: Album, rhs: Album) -> Bool{
        lhs.collection == rhs.collection
    }
}



private class PHAssetCollectionMock : PHAssetCollection {
    
    let _localIdentifier: String = UUID().uuidString
    let _hash: Int = UUID().hashValue
    
    override var localIdentifier: String {
        return _localIdentifier
    }
    
    override var hash: Int {
        return _hash
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? PHAssetCollectionMock else {
            return false
        }
        return self.localIdentifier == object.localIdentifier
    }
}
