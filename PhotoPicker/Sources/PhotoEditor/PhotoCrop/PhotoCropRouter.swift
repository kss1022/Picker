//
//  PhotoCropRouter.swift
//  
//
//  Created by 한현규 on 3/12/24.
//

import ModernRIBs

protocol PhotoCropInteractable: Interactable {
    var router: PhotoCropRouting? { get set }
    var listener: PhotoCropListener? { get set }
}

protocol PhotoCropViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PhotoCropRouter: ViewableRouter<PhotoCropInteractable, PhotoCropViewControllable>, PhotoCropRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PhotoCropInteractable, viewController: PhotoCropViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
