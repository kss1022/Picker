//
//  GalleryInteractorTests.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

@testable import Gallery
import Permission
import PermissionTestSupport
import Selection
import AlbumRepository
import AlbumRepositoryTestSupport
import AlbumEntity
import XCTest


final class GalleryInteractorTests: XCTestCase {
    
    private var sut: GalleryInteractor!
    
    private var presentable: GalleryPresentableMock!
    private var dependecny: GalleryDependencyMock!
    
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
    
    func testCheckPhotoPermissionCall() async{
        await sut.checkPhotoPermssion()
        
        XCTAssertEqual(1, permission.checkPhotoPermissionCallCount)
    }
    
    func testShowPhotoPermissionDenied() async{
        await sut.checkPhotoPermssion()
        permission.photoStatusMock = .denied
        await sut.showPhotoPermissionState()
                
        XCTAssertEqual(1, presentable.showPermissionDeniedCallCount)
        XCTAssertEqual(false, presentable.permissionDeniedIsHidden)
        XCTAssertEqual(true, presentable.permissionLimitedIsHidden)
    }
    
    func testShowPhotoPermissionLimited() async{                
        await sut.checkPhotoPermssion()
        permission.photoStatusMock = .limited
        await sut.showPhotoPermissionState()
        
        XCTAssertEqual(true, presentable.permissionDeniedIsHidden)
        XCTAssertEqual(false, presentable.permissionLimitedIsHidden)
    }
            
    func testShowPhotos() async{
        await sut.checkPhotoPermssion()
        permission.photoStatusMock = .authorized
        
        let album = Album()
        albumRepository.albumsSubject.send([album])
        
        await sut.showPhotoPermissionState()
                
        XCTAssertEqual([album], albumRepository.albums.value)
        XCTAssertEqual(1, albumRepository.fetchCallCount)
        XCTAssertEqual(1, presentable.showPhotoGridCallCount)
        XCTAssertEqual(PhotoGridViewModel(album, Selection()), presentable.showPhotoGridPhotoGridViewModel)
        XCTAssertEqual(1, presentable.showAlbumNameCallCount)        
        XCTAssertEqual(album.name(), presentable.showAlbumNameAlbumName)
    }
    
    func testShowLimitedPhotos() async{
        await sut.checkPhotoPermssion()
        permission.photoStatusMock = .limited
        
        let album = Album()
        albumRepository.albumsSubject.send([album])
        
        await sut.showPhotoPermissionState()
                
        XCTAssertEqual([album], albumRepository.albums.value)
        XCTAssertEqual(1, albumRepository.fetchCallCount)
        XCTAssertEqual(1, presentable.showPhotoGridCallCount)
        XCTAssertEqual(PhotoGridViewModel(album, Selection()), presentable.showPhotoGridPhotoGridViewModel)
        XCTAssertEqual(1, presentable.showAlbumNameCallCount)
        XCTAssertEqual(album.name(), presentable.showAlbumNameAlbumName)
    }
    
    func testAlbumsDidFinish(){
        sut.albumsDidFinish(Album())
        XCTAssertEqual(1, presentable.showPhotoGridCallCount)
        XCTAssertEqual(1, presentable.showAlbumNameCallCount)
    }
    
    func testShowSelectionCount(){
        sut.photoDidtap(Photo())
        sut.photoDidtap(Photo())
        
        XCTAssertEqual(2, presentable.showSelectionCountCallCount)
        XCTAssertEqual(2, presentable.showSelectionCount)
    }
    
    func testAlbumChanged(){
        permission.photoStatusMock = .authorized
        
        sut.didBecomeActive()
        
        let change = AlbumChange()
        albumRepository.albumChangesSubject.send(change)
        XCTAssertEqual(1, presentable.albumChangedCallCount)
        XCTAssertEqual(change, presentable.albumChangedChange)
    }
    
    func testLimitedAlbumChanged(){
        permission.photoStatusMock = .limited
        
        sut.didBecomeActive()
        
        let change = AlbumChange()
        albumRepository.albumChangesSubject.send(change)
        XCTAssertEqual(1, presentable.limitedAlbumChangedCallCount)
        XCTAssertEqual(change, presentable.limitedAlbumChangedChange)
    }
    
    func testUpdateAlbumNameAlbumChanged(){
        permission.photoStatusMock = .authorized
        let album = Album()
        albumRepository.albumsSubject.send([album])
        
        sut.didBecomeActive()
        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "didBecomeActive")], timeout: 0.1)

        
        let change = AlbumChange()
        albumRepository.albumChangesSubject.send(change)
                
        XCTAssertEqual(1, presentable.showPhotoGridCallCount)
        XCTAssertEqual(2, presentable.showAlbumNameCallCount)
    }
    
    func testUpdateAlbumNameAlbumDeleted(){
        permission.photoStatusMock = .authorized
        let mainAlbum = Album()
        let secondAlbum = Album()
        
        albumRepository.albumsSubject.send([mainAlbum, secondAlbum])
        
        sut.didBecomeActive()
        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "didBecomeActive")], timeout: 0.1)
        
        //MainAlbum
        XCTAssertEqual(1, presentable.showPhotoGridCallCount)
        XCTAssertEqual(1, presentable.showAlbumNameCallCount)
        

        //Set SecondAlbum
        sut.albumsDidFinish(secondAlbum)
        XCTAssertEqual(2, presentable.showPhotoGridCallCount)
        XCTAssertEqual(2, presentable.showAlbumNameCallCount)
        
        //Delete SecondAlbum
        let change = AlbumChange()
        albumRepository.albumsSubject.send([mainAlbum])
        albumRepository.albumChangesSubject.send(change)
                
        XCTAssertEqual(3, presentable.showPhotoGridCallCount)
        XCTAssertEqual(3, presentable.showAlbumNameCallCount)
    }
        
    
    func testCheckCameraPermissionCall() async{
        await sut.checkCameraPermission()
        
        XCTAssertEqual(1, permission.checkCameraPermissionCallCount)
    }
    
    func testShowCameraPermissionDenied() async{
        await sut.checkPhotoPermssion()
        permission.cameraStatusMock = .denied
        await sut.showCameraPermissionState()
                    
        XCTAssertEqual(1, presentable.showCamerPermissionDeniedCallCount)
    }
        
}
