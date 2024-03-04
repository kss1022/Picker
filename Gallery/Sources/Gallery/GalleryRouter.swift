//
//  GalleryRouter.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import ModernRIBs

protocol GalleryInteractable: Interactable {
    var router: GalleryRouting? { get set }
    var listener: GalleryListener? { get set }
}

protocol GalleryViewControllable: ViewControllable {
}

final class GalleryRouter: ViewableRouter<GalleryInteractable, GalleryViewControllable>, GalleryRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: GalleryInteractable, viewController: GalleryViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
