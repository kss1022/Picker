//
//  PhotoGridViewModel.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import AlbumEntity
import Photos
import Selection

struct PhotoGridViewModel: Equatable{
    
    private let selection: Selection
    
    public var fetchResult: PHFetchResult<PHAsset>
    
    public var count: Int{
        assert(fetchResult.countOfAssets(with: .image) == fetchResult.count)
        return fetchResult.count
    }
        
    init(_ album: Album, _ selection: Selection){        
        self.selection = selection
        self.fetchResult = album.fetchAssets()
    }
    
    func photo(_ at: Int) -> Photo{
        let asset = fetchResult.object(at: at)
        assert(asset.mediaType == .image)
        return Photo(asset)
    }
    
    func isSelect(_ at: Int) -> Bool{
        selection.isSelect(photo(at))
    }
    
    func selectNum(_ at: Int) -> Int{
        selection.selectNum(photo(at))
    }
    
    
    static func == (lhs: PhotoGridViewModel, rhs: PhotoGridViewModel) -> Bool {
        rhs.fetchResult == rhs.fetchResult
    }
    
}
