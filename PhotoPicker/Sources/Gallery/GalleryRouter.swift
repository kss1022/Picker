//
//  GalleryRouter.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import ModernRIBs
import RIBsUtils
import Albums
import AlbumEntity
import PhotoEditor

protocol GalleryInteractable: Interactable, AlbumsListener, PhotoEditorListener {
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
    
    private let photoEditorBuildable: PhotoEditorBuildable
    private var photoEditorRouter: ViewableRouting?
    
    init(
        interactor: GalleryInteractable,
        viewController: GalleryViewControllable,
        albumsBuildable: AlbumsBuildable,
        photoEditorBuildable: PhotoEditorBuildable
    ) {
        self.albumsBuildable = albumsBuildable
        self.photoEditorBuildable = photoEditorBuildable
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
    
    func attachPhtoEditor(_ photos: [Photo]) {
        if photoEditorRouter != nil{
            return
        }
        
        let router = photoEditorBuildable.build(withListener: interactor, photos: photos)
        viewController.pushViewController(router.viewControllable, animated: true)
        photoEditorRouter = router
        attachChild(router)
    }
    
    func detachPhotoEditor() {
        guard let router = photoEditorRouter else{
            return
        }
        
        viewController.popViewController(animated: true)
        detachChild(router)
        photoEditorRouter = nil
    }
    
    
}
