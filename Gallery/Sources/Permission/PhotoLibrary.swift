//
//  PhotoLibrary.swift
//
//
//  Created by 한현규 on 3/1/24.
//

import Foundation
import Photos



public protocol PhotoLibrary{
    func authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus
     func requestAuthorization(for accessLevel: PHAccessLevel) async

}

extension PHPhotoLibrary: PhotoLibrary{
    public func authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: accessLevel)
    }
    
    public func requestAuthorization(for accessLevel: PHAccessLevel) async{
        await PHPhotoLibrary.requestAuthorization(for: accessLevel)
    }
}

