//
//  CropMoveControl.swift
//
//
//  Created by 한현규 on 3/12/24.
//

import Foundation
import UIKit


protocol MoveControlDelegate: AnyObject {
    func didBean(_ control: CropMoveControl)    //Began
    func didChange(_ control: CropMoveControl)   //Change
    func didEndEditing(_ control: CropMoveControl)  //End , Called
}


class CropMoveControl: UIView {
    
    weak var delegate: MoveControlDelegate?
    
    private var startPoint = CGPoint.zero
    var translation = CGPoint.zero
    var enabled = true
    

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 44.0, height: 44.0))
        setView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect(x: 0, y: 0, width: 44.0, height: 44.0))
        setView()
    }
    
    private func setView() {
        backgroundColor = .clear
        isExclusiveTouch = true //Did not send touch event to other views
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CropResizeControl.handlePan(_:)))
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if !enabled {
            return
        }
        
        switch gestureRecognizer.state {
        case .began:
            let translation = gestureRecognizer.translation(in: superview)
            startPoint = CGPoint(
                x: round(translation.x),
                y: round(translation.y)
            )
            delegate?.didBean(self)
        case .changed:
            let translation = gestureRecognizer.translation(in: superview)
            self.translation = CGPoint(
                x: round(startPoint.x + translation.x),
                y: round(startPoint.y + translation.y)
            )
            delegate?.didChange(self)
        case .ended, .cancelled:
            delegate?.didEndEditing(self)
        default: ()
        }
    }
}
