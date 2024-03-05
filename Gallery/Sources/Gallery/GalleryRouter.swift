//
//  GalleryRouter.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import ModernRIBs
import Albums

protocol GalleryInteractable: Interactable, AlbumsListener {
    var router: GalleryRouting? { get set }
    var listener: GalleryListener? { get set }
}

protocol GalleryViewControllable: ViewControllable {
    func showAlbums(_ view: ViewControllable)
    func hideAlbums(_ view: ViewControllable)
}

final class GalleryRouter: ViewableRouter<GalleryInteractable, GalleryViewControllable>, GalleryRouting {

    private let albumsBuildable: AlbumsBuildable
    private var albumRouter: ViewableRouting?
    
    init(
        interactor: GalleryInteractable,
        viewController: GalleryViewControllable,
        albumsBuildable: AlbumsBuildable
    ) {
        self.albumsBuildable = albumsBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAlbums() {
        if albumRouter != nil{
            return
        }
        
        
        let router = albumsBuildable.build(withListener: interactor)
        viewController.showAlbums(router.viewControllable)
        albumRouter = router
        attachChild(router)
    }
    
    func detachAlbums() {
        guard let router = albumRouter else {
            return
        }
        
        viewController.hideAlbums(router.viewControllable)
        detachChild(router)
        albumRouter = nil
    }
    
}
