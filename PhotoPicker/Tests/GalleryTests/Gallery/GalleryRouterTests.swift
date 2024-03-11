//
//  GalleryRouterTests.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

@testable import Gallery
import XCTest
import Albums
import PhotoEditor
import ModernRIBs
import RIBsTestSupports

final class GalleryRouterTests: XCTestCase {

    private var sut: GalleryRouter!
        
    private var interactor: GalleryInteractable!
    private var viewController: GalleryViewControllableMock!
    private var albumBuildable: AlbumsBuildableMock!
    private var photoBuildable: PhotoEditorBuildableMock!
    

    override func setUp() {
        super.setUp()
                
        self.interactor = GalleryInteractorMock()
        self.viewController = GalleryViewControllableMock()
        self.albumBuildable = AlbumsBuildableMock()
        self.photoBuildable = PhotoEditorBuildableMock()

        self.sut = GalleryRouter(
            interactor: interactor,
            viewController: viewController,
            albumsBuildable: albumBuildable, 
            photoEditorBuildable: photoBuildable
        )
    }

    // MARK: - Tests

    func testAttachAlbums(){
        let router = ALbumsRoutingMock(
            interactable: Interactor(),
            viewControllable: ViewControllableMock()
        )
        
        
        var albumListener: AlbumsListener?
        albumBuildable.buildHandler = { listener in
            albumListener = listener
            return router
        }
        
        sut.attachAlbums()
        
        
        XCTAssertEqual(1, albumBuildable.buildCallCount)
        XCTAssertEqual(viewController.showAlbumsCallCount, 1)
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertTrue(albumListener === interactor)

    }
}
