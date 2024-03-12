//
//  CameraMock.swift
//
//
//  Created by 한현규 on 3/12/24.
//

@testable import Camera
import Foundation
import ModernRIBs


final class CameraBuildableMock: CameraBuildable{
    
    var buildHandler: ( (_ listener: CameraListener) -> ViewableRouting)?
        
    var buildCallCount = 0
    func build(withListener listener: CameraListener) -> ViewableRouting {
        buildCallCount += 1
        
        if let buildHandler = buildHandler{
            return buildHandler(listener)
        }
        
        fatalError()
    }
    
}
