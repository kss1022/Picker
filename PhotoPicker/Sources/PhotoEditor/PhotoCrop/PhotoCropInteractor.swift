//
//  PhotoCropInteractor.swift
//  
//
//  Created by 한현규 on 3/12/24.
//

import Foundation
import ModernRIBs
import AlbumEntity

protocol PhotoCropRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PhotoCropPresentable: Presentable {
    var listener: PhotoCropPresentableListener? { get set }
    
    func setImage(_ image: Image)
    
    func setCropRatios(_ viewModels: [CropRatioViewModel])
    func setCropRatio(_ cropRatio: CropRatio)
    
    func selectCropRatio(_ cropRatio: CropRatio)
    func deSelectCropRatio(_ cropRatio: CropRatio)
}

protocol PhotoCropListener: AnyObject {
    func photoCropDidCrop(_ image: Image, _ rect: CGRect)
    func photoCropDidFinish()
}

protocol PhotoCropInteractorDependency{
    var image: Image{ get }
}

final class PhotoCropInteractor: PresentableInteractor<PhotoCropPresentable>, PhotoCropInteractable, PhotoCropPresentableListener {

    weak var router: PhotoCropRouting?
    weak var listener: PhotoCropListener?

    private let dependency: PhotoCropInteractorDependency
    private let image: Image
    
    private var cropRatio: CropRatio


    init(
        presenter: PhotoCropPresentable,
        dependency: PhotoCropInteractorDependency
    ) {
        cropRatio = .freeform
        self.dependency = dependency
        self.image = dependency.image
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let viewModels = CropRatio.allCases.map { cropRatio in
            CropRatioViewModel(cropRatio: cropRatio) { [weak self] in
                self?.cropRatioButtonDidTap(cropRatio)
            }
        }
        
        presenter.setImage(image)
        presenter.setCropRatios(viewModels)
        presenter.selectCropRatio(cropRatio)
        presenter.setCropRatio(cropRatio)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func closeButtonDidTap() {
        listener?.photoCropDidFinish()
    }
    
    func doneButtonDidTap(_ rect: CGRect) {
        listener?.photoCropDidCrop(image, rect)
    }
    
    func cropRatioButtonDidTap(_ cropRatio: CropRatio) {
        presenter.deSelectCropRatio(self.cropRatio)
        presenter.selectCropRatio(cropRatio)
        presenter.setCropRatio(cropRatio)
        self.cropRatio = cropRatio
    }
}
