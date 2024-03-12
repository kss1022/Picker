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
    
    func attachPhtoEditor(_ images: [Image])
    func detachPhotoEditor()
    
    func attachCamera()
    func detachCamera()
}

protocol GalleryPresentable: Presentable {
    var listener: GalleryPresentableListener? { get set }
    
    func showPermissionDenied()
    func showPermissionLimited()
    func openSetting()
    
    func showCameraPermissionDenied()
            
    func showPhotoGrid(_ viewModel: PhotoGridViewModel)
    func showAlbumName(_ albumName: String?)
    
    func albumChanged(_ change: AlbumChange)
    func limitedAlbumChanged(_ change: AlbumChange)
    
    func showSelectionCount(_ count: Int)
    
    func startLoading()
    func stopLoading()
}

public protocol GalleryListener: AnyObject {
    func galleryDidFinish(_ images: [Image])
    func galleryDidCancel()
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
        
        presenter.startLoading()
        
        Task{
            await checkPhotoPermssion()
            await showPhotoPermissionState()
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
    
    func checkPhotoPermssion() async{
        await permission.checkPhotoPermission()
    }
        
    func showPhotoPermissionState() async{
        switch permission.photoStatus() {
        case .notDetermined:  fatalError()
        case .restricted: await MainActor.run { 
            presenter.showPermissionDenied()
            presenter.stopLoading()
        }
        case .denied:
            await MainActor.run { 
                presenter.showPermissionDenied()
                presenter.stopLoading()
            }
        case .authorized:
            await albumRepository.fetch()
            await MainActor.run {
                if let album = albumRepository.albums.value.first{
                    presenter.showPhotoGrid(PhotoGridViewModel(album, selection))
                    presenter.showAlbumName(album.name())
                    self.album = album
                }
                self.presenter.stopLoading()
            }
        case .limited:
            await albumRepository.fetch()
            await MainActor.run {
                presenter.showPermissionLimited()
                if let album = albumRepository.albums.value.first{
                    presenter.showPhotoGrid(PhotoGridViewModel(album, selection))
                    presenter.showAlbumName(album.name())
                    self.album = album
                }
                self.presenter.stopLoading()
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
    
    func closeButtonDidTap() {
        listener?.galleryDidCancel()
    }
    
    func doneButtonDidTap() {
        listener?.galleryDidFinish(selection.photos())
    }
    
    func editButtonDidTap() {
        router?.attachPhtoEditor(selection.photos())
    }
    
    func photoEditorDidMove() {
        router?.detachPhotoEditor()
    }
    
    func photoEditorDidFinish(_ images: [Image]) {
        router?.detachPhotoEditor()
        listener?.galleryDidFinish(images)
    }
    
    func permissionButtonDidTap() {
        presenter.openSetting()
    }
    
    func photoDidtap(_ photo: Photo) {
        selection.toogle(photo)
        presenter.showSelectionCount(selection.count)
    }
        
    func cameraDidTap() {
        Task{
            await checkCameraPermission()
            await showCameraPermissionState()
        }
    }
    
    func cameraDidCapture(_ capture: Capture) {
        router?.attachPhtoEditor([capture])
        router?.detachCamera()                
    }
    
    func cameraDidCancel() {
        router?.detachCamera()
    }
    
    
    func checkCameraPermission() async{
        await permission.checkCameraPermission()
    }
    
    @MainActor
    func showCameraPermissionState(){
        switch permission.cameraStatus() {
        case .notDetermined: fatalError()
        case .restricted: presenter.showCameraPermissionDenied()
        case .denied: presenter.showCameraPermissionDenied()
        case .authorized: router?.attachCamera()
        }
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

