//
//  AlbumViewModel.swift
//  
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import AlbumEntity
import Photos

struct AlbumViewModel: Equatable{
        
    private let album: Album
    private var fetchResult: PHFetchResult<PHAsset>
    
    public var name: String?{
        album.name()
    }
    
    public var count: Int{
        fetchResult.countOfAssets(with: .image)
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
