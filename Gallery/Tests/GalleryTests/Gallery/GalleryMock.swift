//
//  GalleryMock.swift
//
//
//  Created by 한현규 on 3/3/24.
//

@testable import Gallery
import Permission
import PermissionTestSupport
import AlbumRepository
import AlbumRepositoryTestSupport
import AlbumEntity
import ModernRIBs
import RIBsTestSupports
import UIKit
import Combine


final class GalleryDependencyMock: GalleryInteractorDependency{
    
    var permission: Permission
    var albumRepository: AlbumRepository
    
    init() {
        self.permission = PermissionMock()
        self.albumRepository = AlbumRepositoryMock()
    }
}


final class GalleryPresentableMock: GalleryPresentable{
    var listener: GalleryPresentableListener?
    
    
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
    var album: AlbumViewModel?
    func showAlbum(_ viewModel: AlbumViewModel) {
        showAlbumCallCount += 1
        album = viewModel
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
