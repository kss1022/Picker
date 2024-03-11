//
//  PhotoEditorRouter.swift
//  Picker
//
//  Created by 한현규 on 3/7/24.
//

import ModernRIBs
import RIBsUtils
import UIUtils
import AlbumEntity

protocol PhotoEditorInteractable: Interactable, PhotoCropListener {
    var router: PhotoEditorRouting? { get set }
    var listener: PhotoEditorListener? { get set }
}

protocol PhotoEditorViewControllable: ViewControllable {
}

final class PhotoEditorRouter: ViewableRouter<PhotoEditorInteractable, PhotoEditorViewControllable>, PhotoEditorRouting {

    private let photoCropBuildable: PhotoCropBuildable
    private var photoCropRouting: ViewableRouting?
    
    init(
        interactor: PhotoEditorInteractable,
        viewController: PhotoEditorViewControllable,
        photoCropBuildable: PhotoCropBuildable
    ) {
        self.photoCropBuildable = photoCropBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachPhotoCrop(_ image: Image) {
        if photoCropRouting != nil{
            return
        }
        
        let router = photoCropBuildable.build(withListener: interactor, image: image)
        let vc = router.viewControllable.uiviewController
        vc.modalPresentationStyle = .fullScreen
     
        viewController.present(router.viewControllable, animated: false, completion: nil)
        photoCropRouting = router
        attachChild(router)
    }
    
    func detachPhotoCrop() {
        guard let router = photoCropRouting else {
            return
        }
        
        viewController.dismiss(animated: false, completion: nil)
        detachChild(router)
        photoCropRouting = nil
    }
}
