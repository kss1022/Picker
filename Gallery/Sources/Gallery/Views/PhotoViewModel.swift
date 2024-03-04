//
//  PhotoViewModel.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import AlbumEntity
import Photos


struct PhotoViewModel{
    
    private let photo: Photo
    
    init(_ photo: Photo) {
        self.photo = photo
    }
    
    func asset() -> PHAsset{
        photo.asset
    }
    
    
}
