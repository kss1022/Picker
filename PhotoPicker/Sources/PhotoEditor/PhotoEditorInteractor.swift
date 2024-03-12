//
//  PhotoEditorInteractor.swift
//  Picker
//
//  Created by 한현규 on 3/7/24.
//

import Foundation
import ModernRIBs
import UIUtils
import AlbumEntity


protocol PhotoEditorRouting: ViewableRouting {
    func attachPhotoCrop(_ image: Image)
    func detachPhotoCrop()
}

protocol PhotoEditorPresentable: Presentable {
    var listener: PhotoEditorPresentableListener? { get set }
        
    func setFullScreen()
    func setNormalScreen()
    
    func showPhotos(_ images: [Image], _ page: Int)
    func setPage(_ page: Int)
    
    func rotatePhoto(_ image: Image)
    func cropPhoto(_ image: Image)
}

public protocol PhotoEditorListener: AnyObject {
    func photoEditorDidFinish(_ images: [Image])
    func photoEditorDidMove()
}

protocol PhotoEditorInteractorDependency{
    var images: [Image]{ get }
}

final class PhotoEditorInteractor: PresentableInteractor<PhotoEditorPresentable>, PhotoEditorInteractable, PhotoEditorPresentableListener {

    weak var router: PhotoEditorRouting?
    weak var listener: PhotoEditorListener?
    
    private let dependency: PhotoEditorInteractorDependency
    
    private var screenMode: ScreenMode
    private var images: [Image]
    private var page: Int
    
    init(
        presenter: PhotoEditorPresentable,
        dependency: PhotoEditorInteractorDependency
    ) {
        self.dependency = dependency
        self.screenMode = .normal
        self.images = dependency.images
        self.page = dependency.images.count-1
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                
        presenter.showPhotos(images, page)
    }

    override func willResignActive() {
        super.willResignActive()
        
    }
    
    func rotatePhoto(_ image: Image){
        let rotate = Rotate(image)
        presenter.rotatePhoto(rotate)
        self.images[page] = rotate
    }
    
    func cropPhoto(_ image: Image, _ rect : CGRect){
        let crop = Crop(image, rect)
        presenter.cropPhoto(crop)
        self.images[page] = crop
    }
    
    
    //MARK: PresentableListner
    func didMove() {
        listener?.photoEditorDidMove()
    }
    
    func doneButtonDidTap() {
        listener?.photoEditorDidFinish(images)
    }
    
    func rotateButtonDidTap() {
        rotatePhoto(images[page])
    }
    
    func cropButtonDidTap() {
        router?.attachPhotoCrop(images[page])
    }
    
    func pageDidChange(_ page: Int) {
        presenter.setPage(page)
        self.page = page
    }
    
    
    func pageViewDidTap() {
        let screenMode = (screenMode == .full ? ScreenMode.normal : ScreenMode.full)        
        if screenMode == .full{
            presenter.setFullScreen()
        }else{
            presenter.setNormalScreen()
        }
        self.screenMode = screenMode
    }
    
    func photoCropDidFinish() {
        router?.detachPhotoCrop()
    }
    
    func photoCropDidCrop(_ image: Image, _ rect: CGRect) {
        cropPhoto(image, rect)
        router?.detachPhotoCrop()
    }
        
}
