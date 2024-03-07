//
//  AlbumsMock.swift
//
//
//  Created by 한현규 on 3/5/24.
//

@testable import Albums
import Foundation
import ModernRIBs
import Combine
import RIBsTestSupports
import AlbumRepository
import AlbumRepositoryTestSupport
import AlbumEntity
import CombineSchedulers


final class AlbumsDependencyMock: AlbumsInteractorDependency{
    var albumRepository: AlbumRepository
    var mainQueue: AnySchedulerOf<DispatchQueue>

    
    init() {
        self.albumRepository = AlbumRepositoryMock()
        self.mainQueue = AnySchedulerOf<DispatchQueue>.immediate
    }
    
}

final class AlbumsPresentableMock: AlbumsPresentable{

    var listener: AlbumsPresentableListener?
    
    
    var showAlbumsCallCount = 0
    var showAlbumsAlbumViewModels: [AlbumViewModel]?
    func showAlbums(_ viewModels: [AlbumViewModel]) {
        showAlbumsCallCount += 1
        showAlbumsAlbumViewModels = viewModels
    }
}

final class ALbumsRoutingMock: ViewableRoutingMock, AlbumsRouting{
   
    
}

final class AlbumsBuildableMock: AlbumsBuildable{
    
    var buildHandler: ( (_ listener: AlbumsListener) -> AlbumsRouting)?
        
    var buildCallCount = 0
    func build(withListener listener: AlbumsListener) -> AlbumsRouting {
        buildCallCount += 1
        
        if let buildHandler = buildHandler{
            return buildHandler(listener)
        }
        
        fatalError()
    }

}
