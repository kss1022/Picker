//
//  PickerViewController.swift
//
//
//  Created by 한현규 on 3/4/24.
//

import UIKit
import ModernRIBs
import AlbumEntity

protocol PickerHandler{
    func setLimnit(_ limit: Int)
}

public protocol PickerViewControllerDelegate: AnyObject{
    func picker(_ picker: PickerViewController, didFinishPicking results: [PickerResult])
}

public final class PickerViewController: UIViewController{
    
    private var routing: ViewableRouting?
    private var pickerHandler: PickerHandler?

    
    public weak var delegate: PickerViewControllerDelegate?
    
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
        addChild(vc)
    }

    public func setLimit(_ limit: Int){
        pickerHandler?.setLimnit(limit)
    }
}


extension PickerViewController: PickerRootListener{
    func pickerDidFinish(_ images: [Image]) {
        delegate?.picker(self, didFinishPicking: images.map(PickerResult.init))
    }
}
