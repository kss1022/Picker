//
//  CameraRouter.swift
//  
//
//  Created by 한현규 on 3/12/24.
//

import ModernRIBs

protocol CameraInteractable: Interactable {
    var router: CameraRouting? { get set }
    var listener: CameraListener? { get set }
}

protocol CameraViewControllable: ViewControllable {
}

final class CameraRouter: ViewableRouter<CameraInteractable, CameraViewControllable>, CameraRouting {


    override init(interactor: CameraInteractable, viewController: CameraViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
