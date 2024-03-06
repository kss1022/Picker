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
import Selection


public protocol GalleryRouting: ViewableRouting {
    func attachAlbums()
    func detachAlbums()
}

protocol GalleryPresentable: Presentable {
    var listener: GalleryPresentableListener? { get set }
    
    func showPermissionDenied()
    func showPermissionLimited()
    func openSetting()
        
    func showAlbum(_ viewModel: PhotoGridViewModel)
    
    func showSelectionCount(_ count: Int)
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
        
    private var selection: Selection
    
    init(
        presenter: GalleryPresentable,
        dependency: GalleryInteractorDependency
    ) {
        self.dependency = dependency
        self.permission = dependency.permission
        self.albumRepository = dependency.albumRepository
        self.selection = Selection()
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
            await MainActor.run { presenter.showAlbum(PhotoGridViewModel(album, selection)) }
        case .limited:
            await albumRepository.fetch()
            
            await MainActor.run {
                presenter.showPermissionLimited()
                guard let album = albumRepository.albums.value.first else { return }
                presenter.showAlbum(PhotoGridViewModel(album, selection))
            }
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
        presenter.showAlbum(PhotoGridViewModel(album, selection))
    }
    
    func doneButtonDidTap() {
        listener?.galleryDidFinish()
    }
    
    func permissionButtonDidTap() {
        presenter.openSetting()
    }
    
    func photoDidtap(_ photo: Photo) {
        selection.toogle(photo)
        presenter.showSelectionCount(selection.count)
    }
}

