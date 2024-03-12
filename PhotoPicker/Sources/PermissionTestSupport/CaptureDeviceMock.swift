//
//  CaptureDeviceMock.swift
//
//
//  Created by 한현규 on 3/12/24.
//

import Foundation
import AVFoundation
import Permission



public final class CaptureDeviceMock: CaptureDevice{
    
    public var authorizationStatus: AVAuthorizationStatus
    
    public init(){
        self.authorizationStatus = .notDetermined
    }

    public func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        return authorizationStatus
    }
    
    public func requestAccess(for mediaType: AVMediaType) async{
        
    }
    
    public func didTapDenied(){
        authorizationStatus = .denied
    }
    
    public func didTapAuthorized(){
        authorizationStatus = .authorized
    }
    
    
}
