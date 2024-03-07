//
//  PickerRootBuilder.swift
//  Picker
//
//  Created by 한현규 on 3/4/24.
//

import Foundation
import ModernRIBs
import Gallery
import Permission
import Selection
import AlbumRepository
import CombineSchedulers

protocol PickerRootDependency: Dependency{
    var permission: Permission{ get }
    var selection: Selection{ get }
    var albumRepository: AlbumRepository{ get}
    var mainQueue: AnySchedulerOf<DispatchQueue>{ get }
}

final class PickerRootComponent: Component<PickerRootDependency>, PickerRootInteractorDependency, GalleryDependency  {    
    var permission: Permission{ dependency.permission }
    var selection: Selection{ dependency.selection }
    var albumRepository: AlbumRepository{ dependency.albumRepository }
    var mainQueue: AnySchedulerOf<DispatchQueue>{ dependency.mainQueue }
}

// MARK: - Builder

protocol PickerRootBuildable: Buildable {
    func build(_ listener: PickerRootListener) -> (router: LaunchRouting, handler: PickerHandler)
}

final class PickerRootBuilder: Builder<PickerRootDependency>, PickerRootBuildable {

    override init(dependency: PickerRootDependency) {
        super.init(dependency: dependency)
    }

    func build(_ listener: PickerRootListener) -> (router: LaunchRouting, handler: PickerHandler) {
        let component = PickerRootComponent(dependency: dependency)
        let viewController = PickerRootViewController()
        let interactor = PickerRootInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        let galleryBuilder = GalleryBuilder(dependency: component)
        
        
        let router = PickerRootRouter(
            interactor: interactor,
            viewController: viewController,
            galleryBuildable: galleryBuilder
        )
        
        return (router, interactor)
    }
}
