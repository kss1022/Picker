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
            let viewModel = AlbumViewModel(album)
            await MainActor.run { presenter.showAlbum(viewModel) }
        case .limited:
            await MainActor.run { presenter.showPermissionLimited() }
        }
    }
    
    //MARK: PresnetableListener
    func doneButtonDidTap() {
        listener?.galleryDidFinish()
    }
    
    func permissionButtonDidTap() {
        presenter.openSetting()
    }
}

