import XCTest
@testable import Permission

final class PermissionTests: XCTestCase {
    
    private var permission: Permission!
    private var library: MockPhotoLibrary!
    
    override func setUp() {
        super.setUp()
        
        library = MockPhotoLibrary()
        permission = Permission(library)
    }

    func testCheckPhotoPermissionNotDetermied() async{
        library.authorizationStatus = .notDetermined
        await permission.checkPhotoPermission()
        library.didTapDenied()
        XCTAssertNotEqual(PhotoStatus.notDetermined, permission.photoStatus)
    }
        
    func testCheckPhotoPermssionDenied() async{
        library.authorizationStatus = .denied
        await permission.checkPhotoPermission()        
        XCTAssertEqual(PhotoStatus.denied, permission.photoStatus)
    }
    
    func testCheckPhotoPermssionAuthorized() async{
        library.authorizationStatus = .authorized
        await permission.checkPhotoPermission()
        XCTAssertEqual(PhotoStatus.authorized, permission.photoStatus)
    }
    
    
    func testSetPhotoPermissionAuthorized() async{
        library.authorizationStatus = .notDetermined
        await permission.checkPhotoPermission()
        library.didTapAuthorized()
        XCTAssertEqual(PhotoStatus.authorized, permission.photoStatus)
    }
    
    
    
    
}
