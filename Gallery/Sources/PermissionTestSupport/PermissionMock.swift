//
//  PermissionMock.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import Permission


public final class PermissionMock: Permission{
    
    public var photoStatusMock: PhotoStatus

    public func photoStatus() -> PhotoStatus {
        photoStatusMock
    }
    
    public init() {
        photoStatusMock = .notDetermined
    }
    
    public var checkPhotoPermissionCallCount = 0
    public func checkPhotoPermission() async {
        checkPhotoPermissionCallCount += 1
    }
}
