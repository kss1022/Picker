//
//  PickerRootBuilder.swift
//  Picker
//
//  Created by 한현규 on 3/4/24.
//

import ModernRIBs
import Gallery
import Permission
import AlbumRepository

protocol PickerRootDependency: Dependency{
    var permission: Permission{ get }
    var albumRepository: AlbumRepository{ get}
}

final class PickerRootComponent: Component<PickerRootDependency>, GalleryDependency {

    var permission: Permission{ dependency.permission }
    var albumRepository: AlbumRepository{ dependency.albumRepository }
}

// MARK: - Builder

protocol PickerRootBuildable: Buildable {
    func build(_ listener: PickerRootListener) -> LaunchRouting
}

final class PickerRootBuilder: Builder<PickerRootDependency>, PickerRootBuildable {

    override init(dependency: PickerRootDependency) {
        super.init(dependency: dependency)
    }

    func build(_ listener: PickerRootListener) -> LaunchRouting {
        let component = PickerRootComponent(dependency: dependency)
        let viewController = PickerRootViewController()
        let interactor = PickerRootInteractor(presenter: viewController)
        interactor.listener = listener
        let galleryBuilder = GalleryBuilder(dependency: component)
        
        return PickerRootRouter(
            interactor: interactor,
            viewController: viewController,
            galleryBuildable: galleryBuilder
        )
    }
}
