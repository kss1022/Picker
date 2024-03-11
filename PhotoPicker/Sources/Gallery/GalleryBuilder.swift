//
//  GalleryBuilder.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import ModernRIBs
import Permission
import Selection
import AlbumRepository
import Albums
import PhotoEditor
import CombineSchedulers

public protocol GalleryDependency: Dependency {
    var permission: Permission{ get }
    var selection: Selection{ get }
    var albumRepository: AlbumRepository{ get }
    var mainQueue: AnySchedulerOf<DispatchQueue>{ get }
}

final class GalleryComponent: Component<GalleryDependency>, GalleryInteractorDependency , AlbumsDependency, PhotoEditorDependency{
    var permission: Permission{ dependency.permission }
    var selection: Selection{ dependency.selection }
    var albumRepository: AlbumRepository{ dependency.albumRepository }
    var mainQueue: AnySchedulerOf<DispatchQueue>{ dependency.mainQueue }
}

// MARK: - Builder

public protocol GalleryBuildable: Buildable {
    func build(withListener listener: GalleryListener) -> GalleryRouting
}

public final class GalleryBuilder: Builder<GalleryDependency>, GalleryBuildable {

    public override init(dependency: GalleryDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: GalleryListener) -> GalleryRouting {
        let component = GalleryComponent(dependency: dependency)
        let viewController = GalleryViewController()
        let interactor = GalleryInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let albumsBuilder = AlbumsBuilder(dependency: component)
        let photoEditorBuilder = PhotoEditorBuilder(dependency: component)
        
        return GalleryRouter(
            interactor: interactor,
            viewController: viewController,
            albumsBuildable: albumsBuilder, 
            photoEditorBuildable: photoEditorBuilder
        )
    }
}
