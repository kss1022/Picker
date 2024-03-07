//
//  AlbumChange.swift
//
//
//  Created by 한현규 on 3/6/24.
//

import Foundation
import Photos
import UIKit


public struct AlbumChange: Equatable{
    public let change: PHChange
    
    public init(_ change: PHChange) {
        self.change = change
    }
    
    public init(){
        self.change = PHChange()
    }
    
    public func changeDetails(_ fetchResult:  PHFetchResult<PHAsset>) -> AlbumChangeDetails?{
        guard let changeDetials = self.change.changeDetails(for: fetchResult) else {
            return nil
        }
        return AlbumChangeDetails(changeDetials)
    }
}


public struct AlbumChangeDetails{
    
    private let changeDetails: PHFetchResultChangeDetails<PHAsset>
    
    init(_ changeDetails:  PHFetchResultChangeDetails<PHAsset>){
        self.changeDetails = changeDetails
    }
    
    public var insertedIndex: [IndexPath]?{
        if !hasChange(){
            return nil
        }
        
        return changeDetails.insertedIndexes?.compactMap{
            IndexPath(row: $0, section: 0)
        }
    }
    
    public var changedIndex: [IndexPath]?{
        if !hasChange(){
            return nil
        }
        
        return changeDetails.changedIndexes?.map{
            IndexPath(row: $0, section: 0)
        }
    }

    public var removedIndexes: [IndexPath]?{
        if !hasChange(){
            return nil
        }
        
        return changeDetails.removedIndexes?.map{
            IndexPath(row: $0, section: 0)
        }
    }
    
    public func fetchResult() -> PHFetchResult<PHAsset>{
        changeDetails.fetchResultAfterChanges
    }
    
    private func hasChange() -> Bool{
        changeDetails.hasIncrementalChanges
    }
}


