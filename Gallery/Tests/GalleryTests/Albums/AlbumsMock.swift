//
//  AlbumsMock.swift
//
//
//  Created by 한현규 on 3/5/24.
//

@testable import Albums
import ModernRIBs
import Combine
import RIBsTestSupports

final class ALbumsRoutingMock: ViewableRoutingMock, AlbumsRouting{
   
    
}

final class AlbumsBuildableMock: AlbumsBuildable{
    
    var buildHandler: ( (_ listener: AlbumsListener) -> AlbumsRouting)?
        
    var buildCallCount = 0
    func build(withListener listener: AlbumsListener) -> AlbumsRouting {
        buildCallCount += 1
        
        if let buildHandler = buildHandler{
            return buildHandler(listener)
        }
        
        fatalError()
    }

}
