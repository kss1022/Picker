//
//  PhotoEditorMock.swift
//
//
//  Created by 한현규 on 3/7/24.
//

@testable import PhotoEditor
import AlbumEntity
import ModernRIBs


final class PhotoEditorDependencyMock: PhotoEditorInteractorDependency{
    var photos: [Photo]
    
    init() {
        self.photos = [Photo(),Photo(),Photo(),Photo(),Photo()]
    }
    
}

final class PhotoEditorPresentableMock: PhotoEditorPresentable{
    var listener: PhotoEditorPresentableListener?
    
    var screenMode: ScreenMode?
    var setFullCreenCallCount = 0
    func setFullScreen() {
        setFullCreenCallCount += 1
        screenMode = .full
    }
    
    var setNormalScreenCallCount = 0
    func setNormalScreen() {
        setNormalScreenCallCount += 1
        screenMode = .normal
    }
    
    var showPhotosCallCount = 0
    var showPhotosImages: [Image]?
    var showPhotosPage: Int?
    func showPhotos(_ images: [Image], _ page: Int) {
        showPhotosCallCount += 1
        showPhotosImages = images
        showPhotosPage = page
    }
    
    var setPageCallCount = 0
    var setPagePage: Int?
    func setPage(_ page: Int) {
        setPageCallCount += 1
        setPagePage = page
    }
    
    
    var rotatePhotoCallCount = 0
    var rotatePhotoImage: Image?    
    func rotatePhoto(_ image: Image) {
        rotatePhotoCallCount += 1
        rotatePhotoImage = image
    }
    
    var cropPhotoCallCount = 0
    var cropPhotoImage: Image?
    func cropPhoto(_ image: Image) {
        cropPhotoCallCount += 1
        cropPhotoImage = image        
    }
}


final class PhotoEditorBuildableMock: PhotoEditorBuildable{
    
    var buildHandler: ( (_ listener: PhotoEditorListener) -> ViewableRouting)?
        
    
    var buildCallCount = 0
    func build(withListener listener:  PhotoEditorListener, photos: [Photo]) ->  ViewableRouting {
        buildCallCount += 1
        
        if let buildHandler = buildHandler{
            return buildHandler(listener)
        }
        
        fatalError()
    }
    
    
}
