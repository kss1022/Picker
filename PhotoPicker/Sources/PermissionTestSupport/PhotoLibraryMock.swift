//
//  PhotoLibraryMock.swift
//
//
//  Created by 한현규 on 3/1/24.
//

import Foundation
import Photos
import Permission


public class PhotoLibraryMock: PhotoLibrary {
    
    
    public var authorizationStatus: PHAuthorizationStatus
    
    public init() {
        self.authorizationStatus = .notDetermined
    }
    
    public func authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus{
        return authorizationStatus
    }
        
    public func requestAuthorization(for accessLevel: PHAccessLevel) async{
    }
        
    public func didTapDenied(){
        authorizationStatus = .denied
    }
    
    public func didTapAuthorized(){
        authorizationStatus = .authorized
    }
    
}

