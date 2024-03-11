//
//  PhotoCropBuilder.swift
//  
//
//  Created by 한현규 on 3/12/24.
//

import ModernRIBs
import AlbumEntity

protocol PhotoCropDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PhotoCropComponent: Component<PhotoCropDependency>, PhotoCropInteractorDependency {

    let image: Image
    
    init(dependency: PhotoCropDependency, image: Image) {
        self.image = image
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol PhotoCropBuildable: Buildable {
    func build(withListener listener: PhotoCropListener, image: Image) -> ViewableRouting
}

final class PhotoCropBuilder: Builder<PhotoCropDependency>, PhotoCropBuildable {

    override init(dependency: PhotoCropDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PhotoCropListener, image: Image) -> ViewableRouting {
        let component = PhotoCropComponent(dependency: dependency, image: image)
        let viewController = PhotoCropViewController()
        let interactor = PhotoCropInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return PhotoCropRouter(interactor: interactor, viewController: viewController)
    }
}
