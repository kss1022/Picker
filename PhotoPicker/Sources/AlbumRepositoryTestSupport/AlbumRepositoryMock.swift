//
//  AlbumRepositoryMock.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import AlbumRepository
import CombineUtils
import AlbumEntity

public final class AlbumRepositoryMock: AlbumRepository{
    
    
    public var albums: ReadOnlyCurrentValuePublisher<[Album]>{ albumsSubject }
    public let albumsSubject = CurrentValuePublisher<[Album]>([])
        
    public var albumChanges: ReadOnlyPassthroughPublisher<AlbumChange>{ albumChangesSubject }
    public var albumChangesSubject = PassthroughPublisher<AlbumChange>()
        
    public init(){
        
    }
    
    public var fetchCallCount = 0
    public func fetch() {
        fetchCallCount += 1
    }
}
