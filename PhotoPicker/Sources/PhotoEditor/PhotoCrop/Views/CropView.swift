//
//  CropView.swift
//  
//
//  Created by 한현규 on 3/12/24.
//


import UIKit


///Move
///centerView



///Resize React
///Setter: enableResizing, disableResizing
///
///
///Corner Resize
///topLeftCornerView
///topRightCornerView
///bottomLeftCornerView
///bottomRightCornerView
///
///
///Edge Resize
///topEdgeView
///leftEdgeView
///rightEdgeView
///bottomEdgeView
///



protocol CropViewDelegate: AnyObject {
    func didResizeStart(_ view: CropView)
    func didResizeChange(_ view: CropView)
    func didResizeEnd(_ view: CropView)
    
    func didMoveStart(_ view: CropView)
    func didMoveChange(_ view: CropView)
    func didMoveEnd(_ view: CropView)
}


final class CropView: UIView{
    
    weak var delegate: CropViewDelegate?
    
    private let gridManager: GridManager
    public var initialRect = CGRect.zero
    private var resizeImageView: UIImageView!
            
    private var keepRatio: Bool = false
    private var ratio = CGFloat.zero
    
    
    
    //Corners
    private let topLeftCornerView = CropResizeControl()
    private let topRightCornerView = CropResizeControl()
    private let bottomLeftCornerView = CropResizeControl()
    private let bottomRightCornerView = CropResizeControl()
    
    //Edges
    private let topEdgeView = CropResizeControl()
    private let leftEdgeView = CropResizeControl()
    private let rightEdgeView = CropResizeControl()
    private let bottomEdgeView = CropResizeControl()
    
    
    //Center
    private let centerView = CropMoveControl()
    
    override init(frame: CGRect) {
        gridManager = GridManager()
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        gridManager = GridManager()
        super.init(coder: aDecoder)
        setView()
    }
    
    private  func setView() {
        backgroundColor = .clear
        contentMode = .redraw // GridManager update gride and  setNeedsDisplay()  setNeedsDisplay() -> draw() grid
                
        resizeImageView = UIImageView(frame: bounds.insetBy(dx: -2.0, dy: -2.0))
        //resizeImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //let image = UIImage(systemName: "")
        //resizeImageView.image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 23.0, left: 23.0, bottom: 23.0, right: 23.0))
        
        addSubview(resizeImageView)
        
        addSubview(topEdgeView)
        addSubview(leftEdgeView)
        addSubview(rightEdgeView)
        addSubview(bottomEdgeView)
        addSubview(topLeftCornerView)
        addSubview(topRightCornerView)
        addSubview(bottomLeftCornerView)
        addSubview(bottomRightCornerView)
        
        addSubview(centerView)
        
        topEdgeView.delegate = self
        leftEdgeView.delegate = self
        rightEdgeView.delegate = self
        bottomEdgeView.delegate = self
    
        topLeftCornerView.delegate = self
        topRightCornerView.delegate = self
        bottomLeftCornerView.delegate = self
        bottomRightCornerView.delegate = self
        
        centerView.delegate = self
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews where subview is CropResizeControl {
            if subview.frame.contains(point) {
                return subview
            }
        }
        
        for subview in subviews where subview is CropMoveControl {
            if subview.frame.contains(point) {
                return subview
            }
        }
        
        
        return nil
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gridManager.draw(rect: rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setCornerViews()
        setEdgeViews()
   
    }
    
    
}




//MARK: Set Frame()
extension CropView{
    private func setCornerViews(){
        topLeftCornerView.frame.origin = CGPoint(
            x: topLeftCornerView.bounds.width / -2.0,
            y: topLeftCornerView.bounds.height / -2.0
        )
        
        topRightCornerView.frame.origin = CGPoint(
            x: bounds.width - topRightCornerView.bounds.width / 2.0,
            y: topRightCornerView.bounds.height / -2.0
        )
        

        
        bottomLeftCornerView.frame.origin = CGPoint(
            x: bottomLeftCornerView.bounds.width / -2.0,
            y: bounds.height - bottomLeftCornerView.bounds.height / 2.0
        )
        
        bottomRightCornerView.frame.origin = CGPoint(
            x: bounds.width - bottomRightCornerView.bounds.width / 2.0,
            y: bounds.height - bottomRightCornerView.bounds.height / 2.0
        )
    }
    
    private func setEdgeViews(){
        topEdgeView.frame = CGRect(
            x: topLeftCornerView.frame.maxX,
            y: topEdgeView.frame.height / -2.0,
            width: topRightCornerView.frame.minX - topLeftCornerView.frame.maxX,
            height: topEdgeView.bounds.height
        )
        
        leftEdgeView.frame = CGRect(
            x: leftEdgeView.frame.width / -2.0,
            y: topLeftCornerView.frame.maxY,
            width: leftEdgeView.frame.width,
            height: bottomLeftCornerView.frame.minY - topLeftCornerView.frame.maxY
        )
        
        
        bottomEdgeView.frame = CGRect(
            x: bottomLeftCornerView.frame.maxX,
            y: bottomLeftCornerView.frame.minY,
            width: bottomRightCornerView.frame.minX - bottomLeftCornerView.frame.maxX,
            height: bottomEdgeView.frame.height
        )
        
        
        rightEdgeView.frame = CGRect(
            x: bounds.width - rightEdgeView.frame.width / 2.0,
            y: topRightCornerView.frame.maxY,
            width: rightEdgeView.frame.width,
            height: bottomRightCornerView.frame.minY - topRightCornerView.frame.maxY
        )
        
        
        centerView.frame = CGRect(
            x: leftEdgeView.frame.maxX,
            y: topEdgeView.frame.maxY,
            width: rightEdgeView.frame.minX - leftEdgeView.frame.maxX,
            height: bottomEdgeView.frame.minY - topEdgeView.frame.maxY
        )
    }
}

//MARK: Setter
extension CropView{
    
    func enableKeepRatio(){
        keepRatio = true
    }
    
    func disableKeepRatio(){
        keepRatio = false
    }
    
    func setRatio(_ cropRatio: CropRatio){
        if case .freeform = cropRatio{
            return
        }
        
        switch cropRatio {
        case .square:
            ratio = 1.0
        case .fourToThree:
            ratio = 3 / 4
        case .threeToFour:
            ratio = 4 / 3
        default: fatalError()
        }
    }
    
    func enableResizing(){
        resizeImageView.isHidden = false
        [
            topLeftCornerView, topRightCornerView,
            bottomLeftCornerView, bottomRightCornerView,
            topEdgeView, leftEdgeView,
            rightEdgeView, bottomEdgeView].forEach {
            $0.enabled = true
        }
    }
    
    func disableResizing(){
        resizeImageView.isHidden = true
        [
            topLeftCornerView, topRightCornerView,
            bottomLeftCornerView, bottomRightCornerView,
            topEdgeView, leftEdgeView,
            rightEdgeView, bottomEdgeView
        ].forEach {
            $0.enabled = false
        }
    }
}



//MARK: ResizeControlDelegate : Update Frame
extension CropView: ResizeControlDelegate{

    func didBean(_ control: CropResizeControl) {
        initialRect = frame
        delegate?.didResizeStart(self)
    }
    
    func didChange(_ control: CropResizeControl) {
        frame = resizeFrame(control)
        delegate?.didResizeChange(self)
    }
    
    func didEndEditing(_ control: CropResizeControl) {
        delegate?.didResizeEnd(self)
    }
    
    
    private func resizeFrame(_ resizeControl: CropResizeControl) -> CGRect{
        var rect = frame
        
        if resizeControl == topEdgeView {
            rect = topEdgeView(resizeControl)
        } else if resizeControl == leftEdgeView {
            rect = leftEdgeView(resizeControl)
            if keepRatio{ rect = keepRatioOfWidth(rect) }   //Left check width Ratio
        } else if resizeControl == bottomEdgeView {
            rect = bottomEdgeView(resizeControl)
            if keepRatio{ rect = keepRatioOfHeight(rect) }  //Bottom check height Ratio
        }else if resizeControl == rightEdgeView {
            rect = rightEdgeView(resizeControl)
            if keepRatio { rect = keepRatioOfWidth(rect) }  //Right check width Ratio
        }
        
        //Corner
        else if resizeControl == topLeftCornerView {
            rect = topLeftCornerView(resizeControl)
            if keepRatio {
                var constrainedFrame: CGRect
                if abs(resizeControl.translation.x) < abs(resizeControl.translation.y) {
                    constrainedFrame = keepRatioOfHeight(rect)
                } else {
                    constrainedFrame = keepRatioOfWidth(rect)
                }
                constrainedFrame.origin.x -= constrainedFrame.width - rect.width
                constrainedFrame.origin.y -= constrainedFrame.height - rect.height
                rect = constrainedFrame
            }
        } else if resizeControl == topRightCornerView {
            rect = topRightCorner(resizeControl)
            
            if keepRatio {
                if abs(resizeControl.translation.x) < abs(resizeControl.translation.y) {
                    rect = keepRatioOfHeight(rect)
                } else {
                    rect = keepRatioOfWidth(rect)
                }
            }
        } else if resizeControl == bottomLeftCornerView {
            rect = bottomLeftCorner(resizeControl)
            
            if keepRatio {
                var constrainedFrame: CGRect
                if abs(resizeControl.translation.x) < abs(resizeControl.translation.y) {
                    constrainedFrame = keepRatioOfHeight(rect)
                } else {
                    constrainedFrame = keepRatioOfWidth(rect)
                }
                constrainedFrame.origin.x -= constrainedFrame.width - rect.width
                rect = constrainedFrame
            }
        } else if resizeControl == bottomRightCornerView {
            rect = bottomRightCorner(resizeControl)
            
            if keepRatio {
                if abs(resizeControl.translation.x) < abs(resizeControl.translation.y) {
                    rect = keepRatioOfHeight(rect)
                } else {
                    rect = keepRatioOfWidth(rect)
                }
            }
        }
                
        return rect
    }
}

//MARK:
extension CropView: MoveControlDelegate{
    func didBean(_ control: CropMoveControl) {
        initialRect = frame
        delegate?.didMoveStart(self)
    }
    
    func didChange(_ control: CropMoveControl) {
        frame.origin.x = initialRect.origin.x + control.translation.x
        frame.origin.y = initialRect.origin.y + control.translation.y
        delegate?.didMoveChange(self)
    }
    
    func didEndEditing(_ control: CropMoveControl) {
        delegate?.didMoveEnd(self)
    }
    
}

//MARK: ResizeFrame
extension CropView{
    private func topEdgeView(_ resizeControl: CropResizeControl) -> CGRect{
        var newRect = CGRect(
            x: initialRect.minX,
            y: initialRect.minY + resizeControl.translation.y,
            width: initialRect.width,
            height: initialRect.height - resizeControl.translation.y
        )
        
        if keepRatio{ newRect = keepRatioOfHeight(newRect) }  //Top check height Ratio
        
        let minHeight = minHeight()
        if resizeControl.translation.y > 0 && newRect.height < minHeight {
            newRect.origin.y = frame.maxY - minHeight
            newRect.size.height = minHeight
        }
        
        return newRect
    }
    
    private func leftEdgeView(_ resizeControl: CropResizeControl) -> CGRect{
        var newRect = CGRect(
            x: initialRect.minX + resizeControl.translation.x,
            y: initialRect.minY,
            width: initialRect.width - resizeControl.translation.x,
            height: initialRect.height
        )
        
        let minWidth = minWidh()
        if resizeControl.translation.x > 0 && newRect.width < minWidth{
            newRect.origin.x = frame.maxX - minWidth
            newRect.size.width = minWidth
        }
        
        return newRect
    }
    
    private func bottomEdgeView(_ resizeControl: CropResizeControl) -> CGRect{
        var newRect = CGRect(
            x: initialRect.minX,
            y: initialRect.minY,
            width: initialRect.width,
            height: initialRect.height + resizeControl.translation.y
        )
        
        let minHeight = minHeight()
        if resizeControl.translation.y < 0 && newRect.height < minHeight{
            newRect.size.height = minHeight
        }
        
        return newRect
    }
    
    private func rightEdgeView(_ resizeControl: CropResizeControl) -> CGRect{
        var newRect = CGRect(
            x: initialRect.minX,
            y: initialRect.minY,
            width: initialRect.width + resizeControl.translation.x,
            height: initialRect.height
        )
        
        let minWidth = minWidh()
        if resizeControl.translation.x < 0 && newRect.width < minWidth{
            newRect.size.width = minWidth
        }
        
        return newRect
    }
    
    private func topLeftCornerView(_ resizeControl: CropResizeControl) -> CGRect{
        var newRect = CGRect(
            x: initialRect.minX + resizeControl.translation.x,
            y: initialRect.minY + resizeControl.translation.y,
            width: initialRect.width - resizeControl.translation.x,
            height: initialRect.height - resizeControl.translation.y
        )
        
        //Check top
        let minHeight = minHeight()
        if resizeControl.translation.y > 0 && newRect.height < minHeight {
            newRect.origin.y = frame.maxY - minHeight
            newRect.size.height = minHeight
        }
        
        //Check left
        let minWidth = minWidh()
        if resizeControl.translation.x > 0 && newRect.width < minWidth{
            newRect.origin.x = frame.maxX - minWidth
            newRect.size.width = minWidth
        }
        
        return newRect
    }
    
    private func topRightCorner(_ resizeControl: CropResizeControl) -> CGRect{
        var newRect =  CGRect(
            x: initialRect.minX,
            y: initialRect.minY + resizeControl.translation.y,
            width: initialRect.width + resizeControl.translation.x,
            height: initialRect.height - resizeControl.translation.y
        )
        
        //Check top
        let minHeight = minHeight()
        if resizeControl.translation.y > 0 && newRect.height < minHeight {
            newRect.origin.y = frame.maxY - minHeight
            newRect.size.height = minHeight
        }
        
        //Check right
        let minWidth = minWidh()
        if resizeControl.translation.x < 0 && newRect.width < minWidth{
            newRect.size.width = minWidth
        }
        
        
        return newRect
    }
    
    private func bottomLeftCorner(_ resizeControl: CropResizeControl) -> CGRect{
        var newRect =  CGRect(
            x: initialRect.minX + resizeControl.translation.x,
            y: initialRect.minY,
            width: initialRect.width - resizeControl.translation.x,
            height: initialRect.height + resizeControl.translation.y
        )
        
        //Check bottom
        let minHeight = minHeight()
        if resizeControl.translation.y < 0 && newRect.height < minHeight{
            newRect.size.height = minHeight
        }
        
        //Check left
        let minWidth = minWidh()
        if resizeControl.translation.x > 0 && newRect.width < minWidth{
            newRect.origin.x = frame.maxX - minWidth
            newRect.size.width = minWidth
        }
        return newRect
    }

    
    private func bottomRightCorner(_ resizeControl: CropResizeControl) -> CGRect{
        var newRect = CGRect(
           x: initialRect.minX,
           y: initialRect.minY,
           width: initialRect.width + resizeControl.translation.x,
           height: initialRect.height + resizeControl.translation.y
       )
        
        //Check bottom
        let minHeight = minHeight()
        if resizeControl.translation.y < 01 && newRect.height < minHeight{
            newRect.size.height = minHeight
        }
        
        //Check right
        let minWidth = minWidh()
        if resizeControl.translation.x < 0 && newRect.width < minWidth{
            newRect.size.width = minWidth
        }
        
        return newRect
    }
    
    private func keepRatioOfWidth(_ frame: CGRect) -> CGRect {
        let size = CGSize(width: frame.width, height: frame.width * ratio)
        return CGRect(origin: frame.origin, size: size)
    }
    
    private func keepRatioOfHeight(_ frame: CGRect) -> CGRect {
        let size = CGSize(width: frame.height / ratio, height: frame.height)
        return CGRect(origin: frame.origin, size: size)
    }
    
    private func minWidh() -> CGFloat{
        leftEdgeView.bounds.width + rightEdgeView.bounds.width
    }
    
    private func minHeight() -> CGFloat{
        topEdgeView.bounds.height + bottomEdgeView.bounds.height
    }
    
}

