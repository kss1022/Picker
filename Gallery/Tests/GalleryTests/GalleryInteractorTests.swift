//
//  GalleryInteractorTests.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

@testable import Gallery
import Permission
import PermissionTestSupport
import XCTest


final class GalleryInteractorTests: XCTestCase {
    
    private var interactor: GalleryInteractor!
    private var presentable: GalleryPresentableMock!
    private var dependecny: GalleryInteractorDependency!
    
    private var permission: PermissionMock!{
        dependecny.permission as! PermissionMock
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
}
