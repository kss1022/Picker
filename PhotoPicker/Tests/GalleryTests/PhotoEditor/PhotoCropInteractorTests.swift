//
//  PhotoCropInteractorTests.swift
//  
//
//  Created by 한현규 on 3/12/24.
//

@testable import PhotoEditor
import XCTest
import AlbumEntity

final class PhotoCropInteractorTests: XCTestCase {

    private var sut: PhotoCropInteractor!
    
    private var presentable: PhotoCropPresentableMock!
    private var dependency: PhotoCropDependencyMock!


    override func setUp() {
        super.setUp()

        self.presentable = PhotoCropPresentableMock()
        self.dependency = PhotoCropDependencyMock()
        
        sut = PhotoCropInteractor(
            presenter: presentable,
            dependency: dependency
        )
    }

    // MARK: - Tests

    func testSetCropRatios() {
        sut.didBecomeActive()
        
        let viewModels =  CropRatio.allCases.map { CropRatioViewModel(cropRatio: $0, tapHandler: {})
        }
        
        XCTAssertEqual(1, presentable.setCropRatiosCallCount)
        XCTAssertEqual(viewModels, presentable.setCropRatiosViewModels)
    }
    
    func testSetImage() async{
        sut.didBecomeActive()
                
        let imageLoader = ImageLoader.shared
        let dependencyImage = await imageLoader.loadImage(dependency.image)
        let presentableImage = await imageLoader.loadImage(presentable.setImageImage!)
                
        XCTAssertEqual(1, presentable.setImageCallCount)
        XCTAssertEqual(dependencyImage?.pngData(), presentableImage?.pngData())
    }
    
    
    func testSelectDefaultCropRatio(){
        sut.didBecomeActive()
        
        XCTAssertEqual(1, presentable.selectCropRatioCallCount)
        XCTAssertEqual(.freeform, presentable.selectCropRatioCrioRatio)
        XCTAssertEqual(1, presentable.setCropRatioCallCount)
        XCTAssertEqual(.freeform, presentable.setCropRatioCropRatio)
    }
    
    func testDeSelectCropRatio(){
        sut.didBecomeActive()
        sut.cropRatioButtonDidTap(.square)        
        
        XCTAssertEqual(1, presentable.deSelectCropRatioCallCount)
        XCTAssertEqual(.freeform, presentable.deSelectCropRatioCropRatio)
        XCTAssertEqual(.square, presentable.selectCropRatioCrioRatio)
        XCTAssertEqual(.square, presentable.setCropRatioCropRatio)
    }
}
