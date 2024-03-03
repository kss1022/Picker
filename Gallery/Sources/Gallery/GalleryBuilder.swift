//
//  GalleryBuilder.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import ModernRIBs
import Permission

protocol GalleryDependency: Dependency {
    var permission: Permission{ get }
}

final class GalleryComponent: Component<GalleryDependency>, GalleryInteractorDependency {
    var permission: Permission{ dependency.permission }
}

// MARK: - Builder

protocol GalleryBuildable: Buildable {
    func build(withListener listener: GalleryListener) -> GalleryRouting
}

final class GalleryBuilder: Builder<GalleryDependency>, GalleryBuildable {

    override init(dependency: GalleryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: GalleryListener) -> GalleryRouting {
        let component = GalleryComponent(dependency: dependency)
        let viewController = GalleryViewController()
        let interactor = GalleryInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return GalleryRouter(interactor: interactor, viewController: viewController)
    }
}
