//
//  AlbumsInteractor.swift
//  Picker
//
//  Created by 한현규 on 3/5/24.
//

import ModernRIBs
import AlbumRepository
import AlbumEntity

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
}

final class AlbumsInteractor: PresentableInteractor<AlbumsPresentable>, AlbumsInteractable, AlbumsPresentableListener {

    weak var router: AlbumsRouting?
    weak var listener: AlbumsListener?

    private let dependency: AlbumsInteractorDependency
    private var albumRepository: AlbumRepository
    
    init(
        presenter: AlbumsPresentable,
        dependency: AlbumsInteractorDependency
    ) {
        self.dependency = dependency
        self.albumRepository = dependency.albumRepository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let viewModels = self.albumRepository.albums.value
            .map(AlbumViewModel.init)
        presenter.showAlbums(viewModels)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func albumDidTap(_ viewModel: AlbumViewModel) {
        listener?.albumsDidFinish(viewModel.album)
    }
}
