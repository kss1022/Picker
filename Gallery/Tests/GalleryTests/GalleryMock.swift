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
