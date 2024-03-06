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
    var albumRepository: AlbumRepository
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    init() {
        self.permission = PermissionMock()
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
    
    var openSettingCallCount = 0
    func openSetting() {
        openSettingCallCount += 1
    }
    
    
    var showAlbumCallCount = 0
    var album: PhotoGridViewModel?
    func showAlbum(_ viewModel: PhotoGridViewModel) {
        showAlbumCallCount += 1
        album = viewModel
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
    func limitedAlbumChanged() {
        limitedAlbumChangedCallCount += 1
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
