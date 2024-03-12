//
//  CaptureDevice.swift
//
//
//  Created by 한현규 on 3/12/24.
//

import Foundation
import AVFoundation


public protocol CaptureDevice{
    func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus
    func requestAccess(for mediaType: AVMediaType) async
}



extension AVCaptureDevice: CaptureDevice{
    public func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: mediaType)
    }
    
    public func requestAccess(for mediaType: AVMediaType) async{
        await AVCaptureDevice.requestAccess(for: .video)
    }
}

