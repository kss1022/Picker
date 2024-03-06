//
//  PickerRootComponent.swift
//  
//
//  Created by 한현규 on 3/4/24.
//

import Foundation
import ModernRIBs
import Gallery
import Permission
import AlbumRepository
import CombineSchedulers

final class PickerComponent: Component<EmptyDependency>, PickerRootDependency{
    var permission: Permission
    var albumRepository: AlbumRepository
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    init(){
        self.permission = PermissionImp()
        self.albumRepository = AlbumRepositoryImp()
        self.mainQueue = AnySchedulerOf<DispatchQueue>.main
        super.init(dependency: EmptyComponent())
    }
}
