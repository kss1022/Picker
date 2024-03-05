//
//  GalleryInteractorTests.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

@testable import Gallery
import Permission
import PermissionTestSupport
import AlbumRepository
import AlbumRepositoryTestSupport
import AlbumEntity
import XCTest


final class GalleryInteractorTests: XCTestCase {
    
    private var sut: GalleryInteractor!
    
    private var presentable: GalleryPresentableMock!
    private var dependecny: GalleryInteractorDependency!
    
    private var permission: PermissionMock!{
        dependecny.permission as! PermissionMock
    }
    
    private var albumRepository: AlbumRepositoryMock!{
        dependecny.albumRepository as! AlbumRepositoryMock
    }
    
    
    override func setUp() {
        super.setUp()
        
        self.presentable = GalleryPresentableMock()
        self.dependecny = GalleryDependencyMock()
        
        self.sut = GalleryInteractor(presenter: presentable, dependency: dependecny)
    }
    
    // MARK: - Tests
    
    func testCheckPermissionCall() async{
        await sut.checkPermssion()
        
        XCTAssertEqual(1, permission.checkPhotoPermissionCallCount)
    }
    
    func testShowPermissionDenied() async{
        await sut.checkPermssion()
        permission.photoStatusMock = .denied
        await sut.showPermissionState()
                
        XCTAssertEqual(1, presentable.showPermissionDeniedCallCount)
        XCTAssertEqual(false, presentable.permissionDeniedIsHidden)
        XCTAssertEqual(true, presentable.permissionLimitedIsHidden)
    }
    
    func testShowPermissionLimited() async{                
        await sut.checkPermssion()
        permission.photoStatusMock = .limited
        await sut.showPermissionState()
        
        XCTAssertEqual(true, presentable.permissionDeniedIsHidden)
        XCTAssertEqual(false, presentable.permissionLimitedIsHidden)
    }
    
    
    
    func testShowAlbum() async{
        await sut.checkPermssion()
        permission.photoStatusMock = .authorized
        
        let album = Album()
        albumRepository.albumsSubjects.send([album])
        
        await sut.showPermissionState()
                
        XCTAssertEqual([album], albumRepository.albums.value)
        XCTAssertEqual(1, albumRepository.fetchCallCount)
        XCTAssertEqual(1, presentable.showAlbumCallCount)
        XCTAssertEqual(AlbumViewModel(album), presentable.album)
    }
}
