//
//  GalleryMock.swift
//
//
//  Created by 한현규 on 3/3/24.
//

@testable import Gallery
import Permission
import PermissionTestSupport

import Foundation



final class GalleryDependencyMock: GalleryInteractorDependency{
    
    var permission: Permission
    
    init() {
        self.permission = PermissionMock()
    }
    
    
}


final class GalleryPresentableMock: GalleryPresentable{

    
    var listener: GalleryPresentableListener?
    
    
    var permissionDeniedIsHidden = true
    var permissionLimitedIsHidden = true
    
    var showPermissionDeniedCallCount = 0
    func showPermissionDenied() {
        showPermissionDeniedCallCount += 1
        permissionDeniedIsHidden = false
    }
    
    var showPermissionLimitedCallCount = 0
    func showPermissionLimited() {
        showPermissionLimitedCallCount += 1
        permissionLimitedIsHidden = false
    }
}
