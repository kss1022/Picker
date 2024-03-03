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
    
    private var interactor: GalleryInteractor!
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
        
        self.interactor = GalleryInteractor(presenter: presentable, dependency: dependecny)
    }
    
    // MARK: - Tests
    
    func testCheckPermissionCall() async{
        await interactor.checkPermssion()
        
        XCTAssertEqual(1, permission.checkPhotoPermissionCallCount)
    }
    
    func testShowPermissionDenied() async{
        await interactor.checkPermssion()
        permission.photoStatusMock = .denied
        await interactor.showPermissionState()
                
        XCTAssertEqual(1, presentable.showPermissionDeniedCallCount)
        XCTAssertEqual(false, presentable.permissionDeniedIsHidden)
        XCTAssertEqual(true, presentable.permissionLimitedIsHidden)
    }
    
    func testShowPermissionLimited() async{                
        await interactor.checkPermssion()
        permission.photoStatusMock = .limited
        await interactor.showPermissionState()
        
        XCTAssertEqual(true, presentable.permissionDeniedIsHidden)
        XCTAssertEqual(false, presentable.permissionLimitedIsHidden)
    }
    
    
    
    func testShowAlbum() async{
        await interactor.checkPermssion()
        permission.photoStatusMock = .authorized
        
        let album = Album()
        albumRepository.albumsSubjects.send([album])
        
        await interactor.showPermissionState()
                
        XCTAssertEqual([album], albumRepository.albums.value)
        XCTAssertEqual(1, albumRepository.fetchCallCount)
        XCTAssertEqual(1, presentable.showAlbumCallCount)
        XCTAssertEqual(AlbumViewModel(album), presentable.album)
    }
}
