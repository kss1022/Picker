//
//  GalleryInteractor.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import ModernRIBs
import Permission


protocol GalleryRouting: ViewableRouting {
}

protocol GalleryPresentable: Presentable {
    var listener: GalleryPresentableListener? { get set }
    func showPermissionDenied()
    func showPermissionLimited()
    func openSetting()
}

protocol GalleryListener: AnyObject {
}

protocol GalleryInteractorDependency{
    var permission: Permission{ get }
}

final class GalleryInteractor: PresentableInteractor<GalleryPresentable>, GalleryInteractable, GalleryPresentableListener {

    weak var router: GalleryRouting?
    weak var listener: GalleryListener?

    private let dependency: GalleryInteractorDependency
    private let permission : Permission
    
    init(
        presenter: GalleryPresentable,
        dependency: GalleryInteractorDependency
    ) {
        self.dependency = dependency
        self.permission = dependency.permission
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
    
    @MainActor
    func showPermissionState() async{
        switch permission.photoStatus() {
        case .notDetermined: fatalError()
        case .restricted: presenter.showPermissionDenied()
        case .denied: presenter.showPermissionDenied()
        case .authorized: break
        case .limited: presenter.showPermissionLimited()
        }
    }
    
    //MARK: PresnetableListener
    func permissionButtonDidTap() {
        presenter.openSetting()
    }
}

