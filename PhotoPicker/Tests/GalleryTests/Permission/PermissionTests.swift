import XCTest
import PermissionTestSupport
@testable import Permission

final class PermissionTests: XCTestCase {
    
    private var sut: PermissionImp!
    private var library: PhotoLibraryMock!
    private var captureDevice: CaptureDeviceMock!
    
    override func setUp() {
        super.setUp()
        
        library = PhotoLibraryMock()
        captureDevice = CaptureDeviceMock()
        sut = PermissionImp(library, captureDevice)
    }
    
    //MARK: Photo permission tests

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
    
    
    //MARK: Capture permission tests
    
    func testCheckCameraPermissionNotDetermied() async{
        captureDevice.authorizationStatus = .notDetermined
        await sut.checkCameraPermission()
        captureDevice.didTapDenied()
        XCTAssertNotEqual(CameraStatus.notDetermined, sut.cameraStatus())
    }
        
    func testCheckCameraPermssionDenied() async{
        captureDevice.authorizationStatus = .denied
        await sut.checkCameraPermission()
        XCTAssertEqual(CameraStatus.denied, sut.cameraStatus())
    }
    
    func testCheckCameraPermssionAuthorized() async{
        captureDevice.authorizationStatus = .authorized
        await sut.checkCameraPermission()
        XCTAssertEqual(CameraStatus.authorized, sut.cameraStatus())
    }
    
    
    func testSetCameraPermissionAuthorized() async{
        captureDevice.authorizationStatus = .notDetermined
        await sut.checkCameraPermission()
        captureDevice.didTapAuthorized()
        XCTAssertEqual(CameraStatus.authorized, sut.cameraStatus())
    }
    
    
    
}
