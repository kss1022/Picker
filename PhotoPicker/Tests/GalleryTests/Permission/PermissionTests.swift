import XCTest
import PermissionTestSupport
@testable import Permission

final class PermissionTests: XCTestCase {
    
    private var sut: PermissionImp!
    private var library: PhotoLibraryMock!
    
    override func setUp() {
        super.setUp()
        
        library = PhotoLibraryMock()
        sut = PermissionImp(library)
    }

    func testCheckPhotoPermissionNotDetermied() async{
        library.authorizationStatus = .notDetermined
        await sut.checkPhotoPermission()
        library.didTapDenied()
        XCTAssertNotEqual(PhotoStatus.notDetermined, sut.photoStatus())
    }
        
    func testCheckPhotoPermssionDenied() async{
        library.authorizationStatus = .denied
        await sut.checkPhotoPermission()        
        XCTAssertEqual(PhotoStatus.denied, sut.photoStatus())
    }
    
    func testCheckPhotoPermssionAuthorized() async{
        library.authorizationStatus = .authorized
        await sut.checkPhotoPermission()
        XCTAssertEqual(PhotoStatus.authorized, sut.photoStatus())
    }
    
    
    func testSetPhotoPermissionAuthorized() async{
        library.authorizationStatus = .notDetermined
        await sut.checkPhotoPermission()
        library.didTapAuthorized()
        XCTAssertEqual(PhotoStatus.authorized, sut.photoStatus())
    }
    
    
    
    
}
