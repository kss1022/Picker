//
//  GalleryMock.swift
//
//
//  Created by 한현규 on 3/3/24.
//

@testable import Gallery
import Permission
import PermissionTestSupport
import Selection
import AlbumRepository
import AlbumRepositoryTestSupport
import AlbumEntity
import ModernRIBs
import RIBsTestSupports
import UIKit
import Combine
import CombineSchedulers


final class GalleryDependencyMock: GalleryInteractorDependency{
    
    var permission: Permission
    var selection: Selection
    var albumRepository: AlbumRepository
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    init() {
        self.permission = PermissionMock()
        self.selection = Selection()
        self.albumRepository = AlbumRepositoryMock()
        self.mainQueue = AnySchedulerOf<DispatchQueue>.immediate
    }
}


final class GalleryPresentableMock: GalleryPresentable{
        
    var listener: GalleryPresentableListener?
    var selector: Selection?
    
    var permissionDeniedIsHidden = true
    var permissionLimitedIsHidden = true
    
    var showPermissionDeniedCallCount = 0
    func showPermissionDenied() {
        showPermissionDeniedCallCount += 1
        permissionDeniedIsHidden = false
    }
    
    var showPermissionLimitedCallCount = 0
    func showPermissionLimited() {
        showPermissionLimitedCallCount += 1
        permissionLimitedIsHidden = false
    }
    
    var showCamerPermissionDeniedCallCount = 0
    func showCameraPermissionDenied() {
        showCamerPermissionDeniedCallCount += 1
    }
    
    var openSettingCallCount = 0
    func openSetting() {
        openSettingCallCount += 1
    }
    
    
    var showPhotoGridCallCount = 0
    var showPhotoGridPhotoGridViewModel: PhotoGridViewModel?
    func showPhotoGrid(_ viewModel: PhotoGridViewModel) {
        showPhotoGridCallCount += 1
        showPhotoGridPhotoGridViewModel = viewModel
    }
    
    var showAlbumNameCallCount = 0
    var showAlbumNameAlbumName: String?
    func showAlbumName(_ albumName: String?) {
        showAlbumNameCallCount += 1
        showAlbumNameAlbumName = albumName
    }
    
    var showSelectionCountCallCount = 0
    var showSelectionCount = 0
    func showSelectionCount(_ count: Int) {
        showSelectionCountCallCount += 1
        showSelectionCount = count
    }
    
    var albumChangedCallCount = 0
    var albumChangedChange: AlbumChange?
    func albumChanged(_ change: AlbumChange) {
        albumChangedCallCount += 1
        albumChangedChange = change
    }
    
    var limitedAlbumChangedCallCount = 0
    var limitedAlbumChangedChange: AlbumChange?
    func limitedAlbumChanged(_ change: AlbumChange) {
        limitedAlbumChangedCallCount += 1
        limitedAlbumChangedChange = change
    }
    
    var isLoading: Bool?
    var startLoadingCallCount = 0
    func startLoading() {
        startLoadingCallCount += 1
        isLoading = true
    }
    
    var stopLoadingCallCount = 0
    func stopLoading() {
        stopLoadingCallCount += 1
        isLoading = false
    }
    
    var doneButtonIsEnable: Bool?
    var doneButtonEnableCallCount = 0
    func doneButtonEnable() {
        doneButtonEnableCallCount += 1
        doneButtonIsEnable = true
    }
    
    var doneButtonDisableCallCount = 0
    func doneButtonDisable() {
        doneButtonDisableCallCount += 1
        doneButtonIsEnable = false
    }
    
    var photoEditButtonIsEnable: Bool?
    var photoEditButtonEanbleCallCount = 0
    func photoEditButtonEnable() {
        photoEditButtonEanbleCallCount += 1
        photoEditButtonIsEnable = true
    }
    
    var photoEditButtonDisableCallCount = 0
    func photoEditButtonDisable() {
        photoEditButtonDisableCallCount += 1
        photoEditButtonIsEnable = false
    }
}



final class GalleryInteractorMock: GalleryInteractable{

    
    var router: GalleryRouting?
    
    var listener: GalleryListener?
    
    func activate() {
        
    }
    
    func deactivate() {
        
    }
    
    var albumsDidFinishAlbum: Album?
    var albumsDidFinishCallCount = 0
    func albumsDidFinish(_ album: Album) {
        albumsDidFinishCallCount += 1
        albumsDidFinishAlbum = album
    }
    
    
    var photoEditorDidFinishImages: [Image]?
    var photoEditorDidFinishCallCount = 0
    func photoEditorDidFinish(_ images: [Image]) {
        photoEditorDidFinishCallCount += 1
        photoEditorDidFinishImages = images
    }
    
    var photoEditorDidMoveCallCount = 0
    func photoEditorDidMove() {
        photoEditorDidMoveCallCount += 1
    }
    
    var cameraDidCaptureCallCount = 0
    func cameraDidCapture(_ capture: Capture) {
        cameraDidCaptureCallCount += 1
    }
    
    var camerDidCancelCallCount = 0
    func cameraDidCancel() {
        camerDidCancelCallCount += 1
    }
    
    
    var isActive: Bool { isActiveSubject.value }
    var isActiveStream: AnyPublisher<Bool, Never> { isActiveSubject.eraseToAnyPublisher() }
    private let isActiveSubject = CurrentValueSubject<Bool, Never>(false)
    
    
}



final class GalleryViewControllableMock: GalleryViewControllable{
    
    var showAlbumsCallCount = 0
    func showAlbums(_ view: ViewControllable) {
        showAlbumsCallCount += 1
    }
    
    var hideAlbumsCallCount = 0
    func hideAlbums(_ view: ViewControllable) {
        hideAlbumsCallCount += 1
    }
    
    var uiviewController: UIViewController = UIViewController()
        
}
