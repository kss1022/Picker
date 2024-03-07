//
//  Permission.swift
//
//
//  Created by 한현규 on 3/1/24.
//

import Foundation
import Photos

public protocol Permission{
    func photoStatus() -> PhotoStatus
    func checkPhotoPermission() async    
}


public class PermissionImp: Permission{
    
    private let photoPermission: PhotoPermission
    private let photoLibrary: PhotoLibrary
    
    public func photoStatus() -> PhotoStatus {
        photoPermission.status()
    }
            
    public init(_ photoLibrary: PhotoLibrary = PHPhotoLibrary.shared()){
        self.photoLibrary = photoLibrary
        self.photoPermission = PhotoPermission(photoLibrary)
    }
    
    public func checkPhotoPermission() async{
        if photoStatus() != .notDetermined{
            return
        }
        await requestPhotoPermission()
    }
        

    
    private func requestPhotoPermission() async{        
        _ = await photoLibrary.requestAuthorization(for: .readWrite)
    }

}
