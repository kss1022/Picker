//
//  GalleryInteractor.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import Foundation
import Combine
import ModernRIBs
import CombineSchedulers
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
        
    //TODO: ShowAlbumName
    func showPhotoGrid(_ viewModel: PhotoGridViewModel)
    func showAlbumName(_ albumName: String?)
    
    func albumChanged(_ change: AlbumChange)
    func limitedAlbumChanged(_ change: AlbumChange)
    
    func showSelectionCount(_ count: Int)
}

public protocol GalleryListener: AnyObject {
    func galleryDidFinish()
}

protocol GalleryInteractorDependency{
    var permission: Permission{ get }
    var selection: Selection{ get }
    var albumRepository: AlbumRepository{ get }
    var mainQueue: AnySchedulerOf<DispatchQueue>{ get }
}

final class GalleryInteractor: PresentableInteractor<GalleryPresentable>, GalleryInteractable, GalleryPresentableListener {

    weak var router: GalleryRouting?
    weak var listener: GalleryListener?

    private let dependency: GalleryInteractorDependency
    private var cancellablse: Set<AnyCancellable>

    private let permission : Permission
    private let selection: Selection
    private let albumRepository: AlbumRepository
    private let mainQueue: AnySchedulerOf<DispatchQueue>
        
    
    private var album: Album?
    private var showAlbums: Bool = false
    
    init(
        presenter: GalleryPresentable,
        dependency: GalleryInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellablse = .init()
        self.permission = dependency.permission
        self.selection = dependency.selection
        self.albumRepository = dependency.albumRepository
        self.mainQueue = dependency.mainQueue        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        Task{
            await checkPermssion()
            await showPermissionState()
        }
        
        albumRepository.albumChanges
            .receive(on: mainQueue)
            .sink { change in
                self.permission.photoStatus() == .limited ? self.presenter.limitedAlbumChanged(change) : self.presenter.albumChanged(change)
                self.checkAlbumChange()
            }
            .store(in: &cancellablse)
    }
    
    override func willResignActive() {
        super.willResignActive()
        cancellablse.forEach { $0.cancel() }
        cancellablse.removeAll()
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
            await MainActor.run { 
                presenter.showPhotoGrid(PhotoGridViewModel(album, selection))
                presenter.showAlbumName(album.name())
            }
            self.album = album
        case .limited:
            await albumRepository.fetch()
            await MainActor.run {
                presenter.showPermissionLimited()
                guard let album = albumRepository.albums.value.first else { return }
                presenter.showPhotoGrid(PhotoGridViewModel(album, selection))
                presenter.showAlbumName(album.name())
                self.album = album
            }
        }
    }
        
    
    func titleViewDidTap() {
        showAlbums.toggle()
        
        if showAlbums{
            router?.attachAlbums()
            return
        }
        
        router?.detachAlbums()
    }
    
    func albumsDidFinish(_ album: Album) {                
        showAlbums = false
        router?.detachAlbums()
        presenter.showPhotoGrid(PhotoGridViewModel(album, selection))
        presenter.showAlbumName(album.name())
        self.album = album
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


extension GalleryInteractor{
    func checkAlbumChange(){
        guard let currentAlbum = self.album else { return }
        let albums =  self.albumRepository.albums.value
        
        let album = changedAlbum()
        setPhotosWhenAlbumDeleted()
        presenter.showAlbumName(album.name())
        self.album  = album
        
                
        
        func setPhotosWhenAlbumDeleted(){
            if albums.contains(currentAlbum){
                return
            }
            self.presenter.showPhotoGrid(PhotoGridViewModel(album, selection))
        }
        
        func changedAlbum() -> Album{
            if albums.contains(currentAlbum){
                return albums.first(where: { $0 ==  self.album})!
            }
            return albums.first!
        }
    }
}

