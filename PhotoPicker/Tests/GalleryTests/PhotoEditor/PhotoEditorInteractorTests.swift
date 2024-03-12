//
//  PhotoEditorInteractorTests.swift
//  Picker
//
//  Created by 한현규 on 3/7/24.
//

@testable import PhotoEditor
import XCTest
import AlbumEntity
 

final class PhotoEditorInteractorTests: XCTestCase {

    private var sut: PhotoEditorInteractor!
    
    private var presentable: PhotoEditorPresentableMock!
    private var dependency: PhotoEditorDependencyMock!

    override func setUp() {
        super.setUp()
    
        self.presentable = PhotoEditorPresentableMock()
        self.dependency = PhotoEditorDependencyMock()
        
        self.sut = PhotoEditorInteractor(
            presenter: presentable,
            dependency: dependency
        )
    }

    // MARK: - Tests
    
    func testSetFullScreen(){
        sut.pageViewDidTap()
        
        XCTAssertEqual(1, presentable.setFullCreenCallCount)
        XCTAssertEqual(.full, presentable.screenMode)
    }
    
    func testSetNormalScreen(){
        sut.pageViewDidTap()
        sut.pageViewDidTap()
        
        XCTAssertEqual(1, presentable.setNormalScreenCallCount)
        XCTAssertEqual(.normal, presentable.screenMode)
    }

    func testShowPhotos() {
        sut.didBecomeActive()
        
        XCTAssertEqual(1, presentable.showPhotosCallCount)
        XCTAssertEqual(dependency.images.count-1, presentable.showPhotosPage)
    }
    
    func testSetIndex(){
        sut.pageDidChange(2)
        
        XCTAssertEqual(1, presentable.setPageCallCount)
        XCTAssertEqual(2, presentable.setPagePage)
    }
    
    func testRotate() async{
        let photo = PhotoMock("Lenna")
        
        sut.didBecomeActive()
        sut.rotatePhoto(photo)
        
        let imageLoad = ImageLoader.shared
        let rotateImage = await imageLoad.loadImage(Rotate(photo))
        let presentableImage = await imageLoad.loadImage(presentable.rotatePhotoImage!)
        
        XCTAssertEqual(1, presentable.rotatePhotoCallCount)
        XCTAssertEqual(rotateImage?.pngData(), presentableImage?.pngData())
    }
    
    func testCrop() async{
        let photo = PhotoMock("Lenna")

        sut.didBecomeActive()
        
        let rect = CGRect(x: 30, y: 30, width: 60, height: 60)
        sut.cropPhoto(photo, rect)
        
        
        let imageLoader = ImageLoader.shared
        
        let cropImage = await imageLoader.loadImage(Crop(photo, rect))
        let presentableImage = await imageLoader.loadImage(presentable.cropPhotoImage!)
        
        XCTAssertEqual(1, presentable.cropPhotoCallCount)
        XCTAssertEqual(cropImage?.pngData(), presentableImage?.pngData())
    }
}
