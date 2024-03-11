//
//  PhotoCropMock.swift
//
//
//  Created by 한현규 on 3/12/24.
//

@testable import PhotoEditor
import AlbumEntity

final class PhotoCropDependencyMock: PhotoCropInteractorDependency{
    var image: Image
    
    init() {
        self.image = PhotoMock("Lenna")
    }
}

final class PhotoCropPresentableMock: PhotoCropPresentable{
    var listener: PhotoCropPresentableListener?
    
    var setImageCallCount = 0
    var setImageImage: Image?
    func setImage(_ image: Image) {
        self.setImageCallCount += 1
        self.setImageImage = image
    }
    
    var setCropRatiosCallCount = 0
    var setCropRatiosViewModels: [CropRatioViewModel]?
    func setCropRatios(_ viewModels: [CropRatioViewModel]) {
        setCropRatiosCallCount += 1
        setCropRatiosViewModels = viewModels
    }
        
    var setCropRatioCallCount = 0
    var setCropRatioCropRatio: CropRatio?
    func setCropRatio(_ cropRatio: CropRatio) {
        setCropRatioCallCount += 1
        setCropRatioCropRatio = cropRatio
    }
    
    var selectCropRatioCallCount = 0
    var selectCropRatioCrioRatio: CropRatio?
    func selectCropRatio(_ cropRatio: CropRatio) {
        selectCropRatioCallCount += 1
        selectCropRatioCrioRatio = cropRatio
    }
    
    var deSelectCropRatioCallCount = 0
    var deSelectCropRatioCropRatio: CropRatio?
    func deSelectCropRatio(_ cropRatio: CropRatio) {
        deSelectCropRatioCallCount += 1
        deSelectCropRatioCropRatio = cropRatio
    }
    
    
}
