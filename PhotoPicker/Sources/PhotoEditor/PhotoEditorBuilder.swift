//
//  PhotoEditorBuilder.swift
//  Picker
//
//  Created by 한현규 on 3/7/24.
//

import ModernRIBs
import AlbumEntity

public protocol PhotoEditorDependency: Dependency {
}

final class PhotoEditorComponent: Component<PhotoEditorDependency>, PhotoEditorInteractorDependency, PhotoCropDependency {
    
    let photos: [Photo]
    
    init(
        dependency: PhotoEditorDependency,
        photos: [Photo]
    ) {
        self.photos = photos
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol PhotoEditorBuildable: Buildable {
    func build(withListener listener: PhotoEditorListener, photos: [Photo]) -> ViewableRouting
}

public final class PhotoEditorBuilder: Builder<PhotoEditorDependency>, PhotoEditorBuildable {

    public override init(dependency: PhotoEditorDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: PhotoEditorListener, photos: [Photo]) -> ViewableRouting {
        let component = PhotoEditorComponent(dependency: dependency, photos: photos)
        let viewController = PhotoEditorViewController()
        let interactor = PhotoEditorInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let photoCropBuilder = PhotoCropBuilder(dependency: component)
        
        return PhotoEditorRouter(
            interactor: interactor,
            viewController: viewController,
            photoCropBuildable: photoCropBuilder
        )
    }
}
