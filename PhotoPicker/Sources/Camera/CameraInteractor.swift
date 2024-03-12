//
//  CameraInteractor.swift
//  
//
//  Created by 한현규 on 3/12/24.
//

import ModernRIBs
import AlbumEntity

protocol CameraRouting: ViewableRouting {
}

protocol CameraPresentable: Presentable {
    var listener: CameraPresentableListener? { get set }
}

public protocol CameraListener: AnyObject {
    func cameraDidCapture(_ capture: Capture)
    func cameraDidCancel()
}

final class CameraInteractor: PresentableInteractor<CameraPresentable>, CameraInteractable, CameraPresentableListener {

    weak var router: CameraRouting?
    weak var listener: CameraListener?

    override init(presenter: CameraPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didCapture(_ capture: Capture) {
        Task{
            try? await capture.saveImage()
            await MainActor.run { listener?.cameraDidCapture(capture) }
        }
        
        
    }
    
    func didCancel() {
        listener?.cameraDidCancel()
    }
    
}
