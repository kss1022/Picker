//
//  PickerRootInteractor.swift
//  Picker
//
//  Created by 한현규 on 3/4/24.
//

import ModernRIBs
import AlbumEntity
import Selection

protocol PickerRootRouting: ViewableRouting {
    func attachGallery()
}

protocol PickerRootPresentable: Presentable {
    var listener: PickerRootPresentableListener? { get set }    
}

protocol PickerRootListener: AnyObject {
    func pickerDidFinish(_ images: [Image])
    func pickerDidCancel()
}

protocol PickerRootInteractorDependency{
    var selection: Selection{ get }
}

final class PickerRootInteractor: PresentableInteractor<PickerRootPresentable>, PickerRootInteractable, PickerRootPresentableListener {
    
    weak var router: PickerRootRouting?
    weak var listener: PickerRootListener?
    
    private let dependency: PickerRootInteractorDependency
    private let selection: Selection

    init(
        presenter: PickerRootPresentable,
        dependency: PickerRootInteractorDependency
    ) {
        self.dependency = dependency
        self.selection = dependency.selection
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachGallery()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    
    // MARK: Gallery
    func galleryDidFinish(_ images: [Image]) {
        listener?.pickerDidFinish(images)
    }
    
    func galleryDidCancel() {
        listener?.pickerDidCancel()
    }

}


extension PickerRootInteractor: PickerHandler{
    func setLimnit(_ limit: Int) {        
        selection.setLimit(limit)
    }
}
