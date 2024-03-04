//
//  PickerRootRouter.swift
//  Picker
//
//  Created by 한현규 on 3/4/24.
//

import ModernRIBs
import Gallery

protocol PickerRootInteractable: Interactable, GalleryListener {
    var router: PickerRootRouting? { get set }
    var listener: PickerRootListener? { get set }
}

protocol PickerRootViewControllable: ViewControllable {
    func setGallery(_ view: ViewControllable)
}

final class PickerRootRouter: LaunchRouter<PickerRootInteractable, PickerRootViewControllable>, PickerRootRouting {

    private var galleryBuildable: GalleryBuildable
    private var galleryRouting: ViewableRouting?
    
    init(
        interactor: PickerRootInteractable,
        viewController: PickerRootViewControllable,
        galleryBuildable: GalleryBuildable
    ) {
        self.galleryBuildable = galleryBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachGallery() {
        if galleryRouting != nil{
            return
        }
        
        
        let router = galleryBuildable.build(withListener: interactor)
        viewController.setGallery(router.viewControllable)
        galleryRouting = router
        attachChild(router)
    }
}
