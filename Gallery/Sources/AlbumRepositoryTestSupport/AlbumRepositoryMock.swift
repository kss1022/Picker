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
    
    public var albums: ReadOnlyCurrentValuePublisher<[Album]>{ albumsSubjects }
    public let albumsSubjects = CurrentValuePublisher<[Album]>([])
    
        
    public init(){
        
    }
    
    public var fetchCallCount = 0
    public func fetch() {
        fetchCallCount += 1
    }
}
