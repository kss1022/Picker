import XCTest
import PermissionTestSupport
@testable import Permission

final class PermissionTests: XCTestCase {
    
    private var permission: PermissionImp!
    private var library: PhotoLibraryMock!
    
    override func setUp() {
        super.setUp()
        
        library = PhotoLibraryMock()
        permission = PermissionImp(library)
    }

    func testCheckPhotoPermissionNotDetermied() async{
        library.authorizationStatus = .notDetermined
        await permission.checkPhotoPermission()
        library.didTapDenied()
        XCTAssertNotEqual(PhotoStatus.notDetermined, permission.photoStatus())
    }
        
    func testCheckPhotoPermssionDenied() async{
        library.authorizationStatus = .denied
        await permission.checkPhotoPermission()        
        XCTAssertEqual(PhotoStatus.denied, permission.photoStatus())
    }
    
    func testCheckPhotoPermssionAuthorized() async{
        library.authorizationStatus = .authorized
        await permission.checkPhotoPermission()
        XCTAssertEqual(PhotoStatus.authorized, permission.photoStatus())
    }
    
    
    func testSetPhotoPermissionAuthorized() async{
        library.authorizationStatus = .notDetermined
        await permission.checkPhotoPermission()
        library.didTapAuthorized()
        XCTAssertEqual(PhotoStatus.authorized, permission.photoStatus())
    }
    
    
    
    
}
