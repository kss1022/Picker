//
//  PickerRootComponent.swift
//  
//
//  Created by 한현규 on 3/4/24.
//

import ModernRIBs
import Gallery
import Permission
import AlbumRepository

final class PickerComponent: Component<EmptyDependency>, PickerRootDependency{
    var permission: Permission
    var albumRepository: AlbumRepository
    
    init(){
        self.permission = PermissionImp()
        self.albumRepository = AlbumRepositoryImp()
        super.init(dependency: EmptyComponent())        
    }
}
