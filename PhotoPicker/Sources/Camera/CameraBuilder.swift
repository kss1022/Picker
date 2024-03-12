//
//  CameraBuilder.swift
//  
//
//  Created by 한현규 on 3/12/24.
//

import ModernRIBs

public protocol CameraDependency: Dependency {
}

final class CameraComponent: Component<CameraDependency> {
}

// MARK: - Builder

public protocol CameraBuildable: Buildable {
    func build(withListener listener: CameraListener) -> ViewableRouting
}

public final class CameraBuilder: Builder<CameraDependency>, CameraBuildable {

    public override init(dependency: CameraDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: CameraListener) -> ViewableRouting {
        let component = CameraComponent(dependency: dependency)
        let viewController = CameraViewController()
        viewController.setCamera()
        let interactor = CameraInteractor(presenter: viewController)
        interactor.listener = listener
        return CameraRouter(interactor: interactor, viewController: viewController)
    }
}
