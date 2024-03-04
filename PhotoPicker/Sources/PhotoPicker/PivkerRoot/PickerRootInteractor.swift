//
//  PickerRootInteractor.swift
//  Picker
//
//  Created by 한현규 on 3/4/24.
//

import ModernRIBs

protocol PickerRootRouting: ViewableRouting {
    func attachGallery()
}

protocol PickerRootPresentable: Presentable {
    var listener: PickerRootPresentableListener? { get set }    
}

protocol PickerRootListener: AnyObject {
    func pickerDidFinish()
}

final class PickerRootInteractor: PresentableInteractor<PickerRootPresentable>, PickerRootInteractable, PickerRootPresentableListener {

    weak var router: PickerRootRouting?
    weak var listener: PickerRootListener?

    override init(presenter: PickerRootPresentable) {
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
    func galleryDidFinish() {
        listener?.pickerDidFinish()
    }
}
