//
//  SelectionTests.swift
//  
//
//  Created by 한현규 on 3/5/24.
//

@testable import Selection
import XCTest
import AlbumEntity


final class SelectionTests: XCTestCase {
    
    private var sut: Selection!
    
    override func setUp() {
        super.setUp()
        
        self.sut = Selection()
    }

    func testSelect(){
        let photo = Photo()
        sut.select(photo)
        
        XCTAssertEqual(1, sut.count)
        XCTAssertEqual(photo, sut[0])
    }
        
    func testDeSelect(){
        let photo = Photo()
        sut.select(photo)
        
        sut.deSelect(photo)
        sut.deSelect(photo)
        XCTAssertEqual(0, sut.count)
    }
    
    func testIsSelect(){
        let photo = Photo()
        sut.select(photo)
        
        XCTAssertEqual(true, sut.isSelect(photo))
        XCTAssertNotEqual(true, sut.isSelect(Photo()))
    }
    
    func testIsEmpty(){
        let photo = Photo()
        sut.select(photo)
        
        sut.deSelect(photo)
        
        XCTAssertEqual(true, sut.isEmpty)
    }
    
    
    func testToogleSelected(){
        let photo = Photo()
        sut.select(photo)
        
        sut.toogle(photo)
        
        XCTAssertEqual(0, sut.count)
        XCTAssertEqual(true, sut.isEmpty)
    }
        
    func testToogleNotSelected(){
        let photo = Photo()
        
        sut.toogle(photo)
        
        XCTAssertEqual(1, sut.count)
        XCTAssertEqual(false, sut.isEmpty)
    }
    
    func testSelectWhenLimited(){
        sut.setLimit(1)
        
        sut.select(Photo())
        sut.select(Photo())
        
        XCTAssertEqual(1, sut.count)
    }
    
    func testSetLimitFail(){
        sut.setLimit(2)
        
        sut.select(Photo())
        sut.select(Photo())
        sut.select(Photo())
        
        sut.setLimit(1)
        
        XCTAssertEqual(2, sut.limit)
    }
    
    
    func testSelectNum(){
        let firstPhoto = Photo()
        let secondPhoto = Photo()
        let thirdPhoto = Photo()
        
        sut.select(firstPhoto)
        sut.select(secondPhoto)
        sut.select(thirdPhoto)
        
        XCTAssertEqual(1, sut.selectNum(firstPhoto))
    }
    
    func testDeselectNum(){
        let firstPhoto = Photo()
        let secondPhoto = Photo()
        let thirdPhoto = Photo()
        
        sut.select(firstPhoto)
        sut.select(secondPhoto)
        sut.select(thirdPhoto)
        
        
        sut.deSelect(secondPhoto)
        
        XCTAssertEqual(2, sut.selectNum(thirdPhoto))
    }
    
    
}
