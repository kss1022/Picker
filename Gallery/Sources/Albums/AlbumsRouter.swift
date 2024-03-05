//
//  AlbumsRouter.swift
//  Picker
//
//  Created by 한현규 on 3/5/24.
//

import ModernRIBs

protocol AlbumsInteractable: Interactable {
    var router: AlbumsRouting? { get set }
    var listener: AlbumsListener? { get set }
}

protocol AlbumsViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AlbumsRouter: ViewableRouter<AlbumsInteractable, AlbumsViewControllable>, AlbumsRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AlbumsInteractable, viewController: AlbumsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
