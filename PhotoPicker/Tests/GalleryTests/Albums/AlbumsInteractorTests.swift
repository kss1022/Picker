//
//  AlbumsInteractorTests.swift
//  Picker
//
//  Created by 한현규 on 3/5/24.
//

@testable import Albums
import XCTest
import AlbumRepositoryTestSupport
import AlbumEntity

final class AlbumsInteractorTests: XCTestCase {

    private var sut: AlbumsInteractor!
    
    private var presentable: AlbumsPresentableMock!
    private var dependency: AlbumsDependencyMock!
    
    private var albumRepository: AlbumRepositoryMock!{
        dependency.albumRepository as! AlbumRepositoryMock
    }

    override func setUp() {
        super.setUp()

        self.presentable = AlbumsPresentableMock()
        self.dependency = AlbumsDependencyMock()
        
        self.sut = AlbumsInteractor(presenter: presentable,dependency: dependency)
    }


    func testShowAlbums() {
        let albums = [Album()]
        albumRepository.albumsSubject.send(albums)
        
        sut.didBecomeActive()
        
        XCTAssertEqual(1, presentable.showAlbumsCallCount)
        XCTAssertEqual(albums.map(AlbumViewModel.init), presentable.showAlbumsAlbumViewModels)
    }
}
