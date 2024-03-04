//
//  PickerRootViewController.swift
//  Picker
//
//  Created by 한현규 on 3/4/24.
//

import ModernRIBs
import UIKit

protocol PickerRootPresentableListener: AnyObject {
    
}

final class PickerRootViewController: UINavigationController, PickerRootPresentable, PickerRootViewControllable {
    

    weak var listener: PickerRootPresentableListener?
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGallery(_ view: ViewControllable) {
        let vc = view.uiviewController
        setViewControllers([vc], animated: true)
    }
    
}
