//
//  MockPhotoLibrary.swift
//
//
//  Created by 한현규 on 3/1/24.
//

import Foundation
import Photos
import Permission


class MockPhotoLibrary: PhotoLibrary {
    
    
    var authorizationStatus: PHAuthorizationStatus
    
    init() {
        self.authorizationStatus = .notDetermined
    }
    
    func authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus{
        return authorizationStatus
    }
        
    func requestAuthorization(for accessLevel: PHAccessLevel) async{
    }
        
    func didTapDenied(){
        authorizationStatus = .denied
    }
    
    func didTapAuthorized(){
        authorizationStatus = .authorized
    }
    
}

