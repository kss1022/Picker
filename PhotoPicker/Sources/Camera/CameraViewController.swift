//
//  CameraViewController.swift
//  
//
//  Created by 한현규 on 3/12/24.
//

import ModernRIBs
import UIKit
import AlbumEntity

protocol CameraPresentableListener: AnyObject {
    func didCapture(_ capture: Capture)
    func didCancel()
}

final class CameraViewController: UIImagePickerController, CameraPresentable, CameraViewControllable {

    weak var listener: CameraPresentableListener?
    
        
    
    func setCamera() {
        self.sourceType = .camera
        self.cameraCaptureMode = .photo
        self.cameraFlashMode = .off
        self.cameraDevice = .rear
        self.allowsEditing = false
        self.delegate = self
    }
}



extension CameraViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            listener?.didCancel()
            return
        }
        
        let capture = Capture(image)
        listener?.didCapture(capture)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        listener?.didCancel()
    }
}
