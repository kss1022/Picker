//
//  PickerViewController.swift
//
//
//  Created by 한현규 on 3/4/24.
//

import UIKit
import ModernRIBs

protocol PickerHandler{
    func setLimnit(_ limit: Int)
}


public final class PickerViewController: UIViewController{
    
    private var routing: ViewableRouting?
    private var pickerHandler: PickerHandler?

    
    public init() {
        super.init(nibName: nil, bundle: nil)
        attachRoot()
        setView()
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    private func attachRoot(){
        let builder = PickerRootBuilder(dependency: PickerComponent())
        let result = builder.build(self)
        routing = result.router
        routing?.interactable.activate()
        routing?.load()
        
        pickerHandler = result.handler
    }
    
    private func setView(){
        guard let router = routing else { return }
        let vc = router.viewControllable.uiviewController
        view.addSubview(vc.view)
        vc.view.frame = view.bounds
    }

    public func setLimit(_ limit: Int){
        pickerHandler?.setLimnit(limit)
    }
}


extension PickerViewController: PickerRootListener{
    func pickerDidFinish() {
        self.dismiss(animated: true)
    }
}
