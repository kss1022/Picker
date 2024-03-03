//
//  Permission.swift
//
//
//  Created by 한현규 on 3/1/24.
//

import Foundation
import Photos


public class Permission{
    
    private let photoPermission: PhotoPermission
    private let photoLibrary: PhotoLibrary
    
    public var photoStatus: PhotoStatus{
        photoPermission.status()
    }
            
    public init(_ photoLibrary: PhotoLibrary = PHPhotoLibrary.shared()){
        self.photoLibrary = photoLibrary
        self.photoPermission = PhotoPermission(photoLibrary)
    }
    
    public func checkPhotoPermission() async{
        if photoStatus != .notDetermined{
            return
        }
        await requestPhotoPermission()
    }
        

    
    private func requestPhotoPermission() async{        
        _ = await photoLibrary.requestAuthorization(for: .readWrite)
    }

}
