//
//  AlbumsInteractor.swift
//  Picker
//
//  Created by 한현규 on 3/5/24.
//

import Foundation
import ModernRIBs
import AlbumRepository
import AlbumEntity
import Combine
import CombineUtils
import CombineSchedulers

public protocol AlbumsRouting: ViewableRouting {
}

protocol AlbumsPresentable: Presentable {
    var listener: AlbumsPresentableListener? { get set }
    func showAlbums(_ viewModels: [AlbumViewModel])    
}

public protocol AlbumsListener: AnyObject {
    func albumsDidFinish(_ album: Album)
}

protocol AlbumsInteractorDependency{
    var albumRepository: AlbumRepository{ get }
    var mainQueue: AnySchedulerOf<DispatchQueue>{ get }
}

final class AlbumsInteractor: PresentableInteractor<AlbumsPresentable>, AlbumsInteractable, AlbumsPresentableListener {

    weak var router: AlbumsRouting?
    weak var listener: AlbumsListener?

    private let dependency: AlbumsInteractorDependency
    private let albumRepository: AlbumRepository
    private let mainQueue: AnySchedulerOf<DispatchQueue>
    
    
    private var cancellablse: Set<AnyCancellable>
    
    init(
        presenter: AlbumsPresentable,
        dependency: AlbumsInteractorDependency
    ) {
        self.dependency = dependency
        self.albumRepository = dependency.albumRepository
        self.mainQueue = dependency.mainQueue
        self.cancellablse = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                
        albumRepository.albums
            .receive(on: mainQueue)
            .sink { albums in
                let viewModels = albums.map(AlbumViewModel.init)
                self.presenter.showAlbums(viewModels)
            }
            .store(in: &cancellablse)
    }

    override func willResignActive() {
        super.willResignActive()
        cancellablse.forEach { $0.cancel() }
        cancellablse.removeAll()
    }
    
    func albumDidTap(_ viewModel: AlbumViewModel) {
        listener?.albumsDidFinish(viewModel.album)
    }
}
