//
//  CombineUtils.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import CombineUtils
import AlbumEntity
import Photos

public protocol AlbumRepository{
    func fetch() async
    var albums: ReadOnlyCurrentValuePublisher<[Album]>{ get }
}


final class AlbumRepositoryImp: AlbumRepository{
    
    
    var albums: ReadOnlyCurrentValuePublisher<[Album]>{ albumsSubject }
    private let albumsSubject = CurrentValuePublisher<[Album]>([])
    
    
    typealias AlbumType = (type: PHAssetCollectionType, subType: PHAssetCollectionSubtype)
    
    
    func fetch() async{
        let collections = [
            AlbumType(.smartAlbum, .smartAlbumUserLibrary),
            AlbumType(.smartAlbum, .smartAlbumFavorites),
            AlbumType(.smartAlbum, .smartAlbumSelfPortraits),
            AlbumType(.album, .albumRegular)
        ].map { albumType in
            PHAssetCollection.fetchAssetCollections(
               with: albumType.type,
               subtype: albumType.subType,
               options: nil
           )
        }.flatMap {
            var collections = [PHAssetCollection]()
            $0.enumerateObjects { collection, _, _ in
                collections.append(collection)
            }
            return collections
        }
            
        
        let albums = collections.map(Album.init)            
        albumsSubject.send(albums)
    }
}
