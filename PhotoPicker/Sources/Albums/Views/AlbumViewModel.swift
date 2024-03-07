//
//  ALbumViewModel.swift
//
//
//  Created by 한현규 on 3/5/24.
//

import UIKit
import Photos
import AlbumEntity

struct AlbumViewModel: Equatable{
        
    let album: Album
    private var fetchResult: PHFetchResult<PHAsset>
    
    public var name: String?{
        album.name()
    }
    
    public var count: Int{
        assert(fetchResult.countOfAssets(with: .image) == fetchResult.count)
        return fetchResult.count
    }
        
    init(_ album: Album){
        self.album = album
        self.fetchResult = album.fetchAssets()
    }
    
    func photo(_ at: Int) -> Photo{
        let asset = fetchResult.object(at: at)
        assert(asset.mediaType == .image)
        return Photo(asset)
    }
    
    static func == (lhs: AlbumViewModel, rhs: AlbumViewModel) -> Bool {
        lhs.album == rhs.album
    }
    
}
