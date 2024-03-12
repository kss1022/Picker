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
    
    public var cameraStatusMock: CameraStatus
    public func cameraStatus() -> CameraStatus {
        cameraStatusMock
    }
    
    public init() {
        photoStatusMock = .notDetermined
        cameraStatusMock = .notDetermined
    }
    
    public var checkPhotoPermissionCallCount = 0
    public func checkPhotoPermission() async {
        checkPhotoPermissionCallCount += 1
    }
    
    public var checkCameraPermissionCallCount = 0
    public func checkCameraPermission() async {
        checkCameraPermissionCallCount += 1
    }
    
}
