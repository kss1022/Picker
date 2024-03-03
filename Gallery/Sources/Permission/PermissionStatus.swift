//
//  PermissionStatus.swift
//
//
//  Created by 한현규 on 3/1/24.
//

import Foundation
import Photos

public enum PhotoStatus{
    case notDetermined //아직 권한을 요청하지 않음
    case restricted
    case denied //
    case authorized //권한이 허용됨
    case limited
}


internal struct PhotoPermission{
    
    private let photoLibrary: PhotoLibrary
    
    init(_ photoLibrary: PhotoLibrary = PHPhotoLibrary.shared()){
        self.photoLibrary = photoLibrary
    }
    
    func status() -> PhotoStatus {
        switch photoLibrary.authorizationStatus(for: .readWrite) {
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        case .denied: return .denied
        case .authorized: return .authorized
        case .limited: return .limited
        @unknown default: fatalError("PHAuthorizationStatus not handled")
        }
    }
}
