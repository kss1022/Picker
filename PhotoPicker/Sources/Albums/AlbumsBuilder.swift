//
//  AlbumsBuilder.swift
//  Picker
//
//  Created by 한현규 on 3/5/24.
//

import Foundation
import ModernRIBs
import AlbumRepository
import CombineSchedulers

public protocol AlbumsDependency: Dependency {
    var albumRepository: AlbumRepository{ get }
    var mainQueue: AnySchedulerOf<DispatchQueue>{ get }

}

final class AlbumsComponent: Component<AlbumsDependency>, AlbumsInteractorDependency {
    var albumRepository: AlbumRepository{ dependency.albumRepository }
    var mainQueue: AnySchedulerOf<DispatchQueue>{ dependency.mainQueue }

}

// MARK: - Builder

public protocol AlbumsBuildable: Buildable {
    func build(withListener listener: AlbumsListener) -> AlbumsRouting
}

public final class AlbumsBuilder: Builder<AlbumsDependency>, AlbumsBuildable {

    public override init(dependency: AlbumsDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: AlbumsListener) -> AlbumsRouting {
        let component = AlbumsComponent(dependency: dependency)
        let viewController = AlbumsViewController()
        let interactor = AlbumsInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return AlbumsRouter(interactor: interactor, viewController: viewController)
    }
}
