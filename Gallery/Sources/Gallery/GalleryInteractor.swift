//
//  GalleryInteractor.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import ModernRIBs
import Permission
import AlbumRepository
import AlbumEntity


public protocol GalleryRouting: ViewableRouting {
    func attachAlbums()
    func detachAlbums()
}

protocol GalleryPresentable: Presentable {
    var listener: GalleryPresentableListener? { get set }
    func showPermissionDenied()
    func showPermissionLimited()
    func openSetting()
        
    func showAlbum(_ viewModel: AlbumViewModel)
}

public protocol GalleryListener: AnyObject {
    func galleryDidFinish()
}

protocol GalleryInteractorDependency{
    var permission: Permission{ get }
    var albumRepository: AlbumRepository{ get }
}

final class GalleryInteractor: PresentableInteractor<GalleryPresentable>, GalleryInteractable, GalleryPresentableListener {

    weak var router: GalleryRouting?
    weak var listener: GalleryListener?

    private let dependency: GalleryInteractorDependency
    private let permission : Permission
    private let albumRepository: AlbumRepository
    
    private var showAlbum: Bool = false
    
    init(
        presenter: GalleryPresentable,
        dependency: GalleryInteractorDependency
    ) {
        self.dependency = dependency
        self.permission = dependency.permission
        self.albumRepository = dependency.albumRepository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        Task{
            await checkPermssion()
            await showPermissionState()
        }
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func checkPermssion() async{
        await permission.checkPhotoPermission()
    }
        
    func showPermissionState() async{
        switch permission.photoStatus() {
        case .notDetermined:  fatalError()
        case .restricted: await MainActor.run { presenter.showPermissionDenied() }
        case .denied: await MainActor.run { presenter.showPermissionDenied() }
        case .authorized:
            await albumRepository.fetch()
            guard let album = albumRepository.albums.value.first else { return }
            await MainActor.run { presenter.showAlbum(AlbumViewModel(album)) }
        case .limited:
            await MainActor.run { presenter.showPermissionLimited() }
        }
    }
        
    
    func titleViewDidTap() {
        showAlbum.toggle()
        
        if showAlbum{
            router?.attachAlbums()
            return
        }
        
        router?.detachAlbums()
    }
    
    func albumsDidFinish(_ album: Album) {                
        showAlbum = false
        router?.detachAlbums()
        presenter.showAlbum(AlbumViewModel(album))
    }
    
    func doneButtonDidTap() {
        listener?.galleryDidFinish()
    }
    
    func permissionButtonDidTap() {
        presenter.openSetting()
    }
}

