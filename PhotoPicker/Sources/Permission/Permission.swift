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
    
    func cameraStatus() -> CameraStatus
    func checkCameraPermission() async
}


public class PermissionImp: Permission{
    
    private let photoPermission: PhotoPermission
    private let photoLibrary: PhotoLibrary
    
    private let cameraPermission: CameraPermission
    private let captureDevice: CaptureDevice?
    
    public func photoStatus() -> PhotoStatus {
        photoPermission.status()
    }
    
    public func cameraStatus() -> CameraStatus{
        cameraPermission.status()
    }
            
    public init(
        _ photoLibrary: PhotoLibrary = PHPhotoLibrary.shared(),
        _ captureDevice: CaptureDevice? = AVCaptureDevice.default(for: .video)
    ){
        self.photoLibrary = photoLibrary
        self.photoPermission = PhotoPermission(photoLibrary)
        
        self.captureDevice = captureDevice
        self.cameraPermission = CameraPermission(captureDevice)
    }
    
    public func checkPhotoPermission() async{
        if photoStatus() != .notDetermined{
            return
        }
        await requestPhotoPermission()
    }
        
    public func checkCameraPermission() async {
        if cameraStatus() != .notDetermined{
            return
        }
        
        await requestCameraPermission()
    }
    
    private func requestPhotoPermission() async{        
        _ = await photoLibrary.requestAuthorization(for: .readWrite)
    }
    
    
    private func requestCameraPermission() async{
        _ = await captureDevice?.requestAccess(for: .video)
    }
    


}
