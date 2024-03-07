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
    var albumChanges: ReadOnlyPassthroughPublisher<AlbumChange>{ get }
}


public final class AlbumRepositoryImp: NSObject, AlbumRepository, PHPhotoLibraryChangeObserver{
        
    public var albums: ReadOnlyCurrentValuePublisher<[Album]>{ albumsSubject }
    private let albumsSubject = CurrentValuePublisher<[Album]>([])
    
    public var albumChanges: ReadOnlyPassthroughPublisher<AlbumChange>{ albumChangesSubject }
    private let albumChangesSubject = PassthroughPublisher<AlbumChange>()
        
    
    typealias AlbumType = (type: PHAssetCollectionType, subType: PHAssetCollectionSubtype)
    
    
    public func fetch() async{
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
    
    public override init(){
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit{
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
        
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task{
            await fetch()
            albumChangesSubject.send(AlbumChange(changeInstance))
        }
    }
    
}
