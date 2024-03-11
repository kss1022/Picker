//
//  ImageTests.swift
//  
//
//  Created by 한현규 on 3/11/24.
//

import XCTest
import AlbumEntity

final class ImageTests: XCTestCase {
    
    private var sut: ImageLoader!

    override func setUp() {
        super.setUp()
        sut = ImageLoader.shared
    }
    
    func testImageLoading() async{
        let photo = PhotoMock("Lenna")
        let image = await sut.loadImage(photo)
        XCTAssertNotNil(image)
    }
    
    func testRotateImage() async{
        let photo = PhotoMock("Lenna")
        let rotate = Rotate(photo)
                
        let photoImage = await sut.loadImage(photo)!.rotate(radians: .pi / 2)!
        let rotateImage = await sut.loadImage(rotate)!
        
        XCTAssertEqual(photoImage.pngData(), rotateImage.pngData())
        XCTAssertEqual(photoImage.size.width.rounded(), rotateImage.size.height.rounded())
        XCTAssertEqual(photoImage.size.height.rounded(), rotateImage.size.width.rounded())
    }
    
    func testCropImage() async{
        let photo = PhotoMock("Lenna")
        
        let rect = CGRect(x: 30, y: 30, width: 40, height: 60)
        let crop = Crop(photo, rect)
        
        
        let photoImage = await sut.loadImage(photo)!
            .cgImage!.cropping(to: rect)
            .flatMap{ UIImage(cgImage: $0) }!
        
        let cropImage = await sut.loadImage(crop)!
                        
        XCTAssertEqual(photoImage.pngData(), cropImage.pngData())
        XCTAssertEqual(40.0, cropImage.size.width)
        XCTAssertEqual(60.0, cropImage.size.height)
    }
    
    func testRotateCrop() async{
        let photo = PhotoMock("Lenna")
        let rotate = Rotate(photo)
        
        let rect = CGRect(x: 30, y: 30, width: 40, height: 60)
        let rotateCrop = Crop(rotate, rect)
        
        let photoImage = await sut.loadImage(photo)!.rotate(radians: .pi / 2)!
            .cgImage!.cropping(to: rect)
            .flatMap{ UIImage(cgImage: $0) }!
        
        let rotateCropImage = await sut.loadImage(rotateCrop)!
        
        XCTAssertEqual(photoImage.pngData(), rotateCropImage.pngData())
        XCTAssertEqual(40.0, rotateCropImage.size.width)
        XCTAssertEqual(60.0, rotateCropImage.size.height)
    }
    
    
    func testCropRotate() async{
        let photo = PhotoMock("Lenna")
        
        let rect = CGRect(x: 30, y: 30, width: 40, height: 60)
        let crop = Crop(photo, rect)
        
        let cropRotate = Rotate(crop)
        
        let photoImage = await sut.loadImage(photo)!
            .cgImage!.cropping(to: rect)
            .flatMap{ UIImage(cgImage: $0) }!
            .rotate(radians: .pi / 2)!
            
        
        let cropRotateImage = await sut.loadImage(cropRotate)!
        
        XCTAssertEqual(photoImage.pngData(), cropRotateImage.pngData())
        XCTAssertEqual(60, cropRotateImage.size.width)
        XCTAssertEqual(40, cropRotateImage.size.height)
    }
    

}
