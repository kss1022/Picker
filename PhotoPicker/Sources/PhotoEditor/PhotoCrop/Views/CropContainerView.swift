//
//  CropContainerView.swift
//
//
//  Created by 한현규 on 3/12/24.
//

import UIKit
import AlbumEntity
import AVFoundation


final class CropContainerView: UIView{
    
    private var image: UIImage?
    private var imageSize = CGSize(width: 1.0, height: 1.0)
    
    private var isResizing: Bool = false
    private var isMoving: Bool = false
    private var insetRect = CGRect.zero
    
    
    private var imageView : UIImageView?
    
    private let cropView = CropView()
    
    private var isKeepRaio: Bool = false
    
    private let topOverlayView = UIView()
    private let leftOverlayView = UIView()
    private let rightOverlayView = UIView()
    private let bottomOverlayView = UIView()
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if imageView == nil {
            insetRect = bounds.insetBy(dx: 0.0, dy: 0.0)
            setViews()
        }
    }
    
    private func setViews() {
        let cropRect = AVMakeRect(aspectRatio: imageSize, insideRect: insetRect)
        
        let imageView = UIImageView(frame: cropRect)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        addSubview(imageView)
        self.imageView = imageView
        
        addSubview(cropView)
        cropView.delegate = self
        cropView.frame = imageView.frame
        
        let color =  UIColor(white: 0.0, alpha: 0.4)
        topOverlayView.backgroundColor = color
        leftOverlayView.backgroundColor = color
        rightOverlayView.backgroundColor = color
        bottomOverlayView.backgroundColor = color
        
        addSubview(topOverlayView)
        addSubview(leftOverlayView)
        addSubview(rightOverlayView)
        addSubview(bottomOverlayView)
    }
    
    
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isUserInteractionEnabled {
            return nil
        }
        
        if let hitView = cropView.hitTest(convert(point, to: cropView), with: event) {
            return hitView
        }
        
        return super.hitTest(point, with: event)
    }
        
    
    func cropImage() -> UIImage?{
        let cropReact = cropRect()
        return image?.crop(rect: cropReact)
    }
 
    
    func setImage(_ image: UIImage?){
        if image != nil{
            imageSize = image!.size
        }
        
        self.image = image
        imageView?.image = image
    }
        
    
    func setRatio(_ cropRatio: CropRatio){
        guard let size = ratioSize(cropRatio) else  {
            isKeepRaio = false
            cropView.disableKeepRatio()
            return
        }
        
        let center = centerPoint()
        let origin = CGPoint(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2
        )
        let frame = CGRect(origin: origin, size: size)
        cropView.frame = frame
        updateOverlay(frame)
        
        isKeepRaio = true
        cropView.enableKeepRatio()
        cropView.setRatio(cropRatio)
    }
    
    
    func enableResizing(){
        cropView.enableResizing()
    }
    
    func diableResizing(){
        cropView.disableResizing()
    }
    
    
    public func cropRect() -> CGRect {
        let cropRect = self.convert(cropView.frame, to: imageView)
        
        let ratio = AVMakeRect(
            aspectRatio: imageSize,
            insideRect: insetRect
        ).width / imageSize.width
        
        return CGRect(
            x: cropRect.origin.x / ratio,
            y: cropRect.origin.y / ratio,
            width: cropRect.size.width / ratio,
            height: cropRect.size.height / ratio
        )
    }
    
}

extension CropContainerView{
    
    private func updateOverlay(_ cropRect: CGRect) {
        guard let imageView = imageView else { return }
        let image = imageView.frame
        
        
        topOverlayView.frame = CGRect(
            x: image.minX,
            y: image.minY,
            width: image.width,
            height: cropRect.minY - image.minY
        )
        
        leftOverlayView.frame = CGRect(
            x: image.minX,
            y: cropRect.minY,
            width: cropRect.minX - image.minX,
            height: cropRect.height
        )
        
        rightOverlayView.frame = CGRect(
            x: cropRect.maxX,
            y: cropRect.minY,
            width: image.maxX - cropRect.maxX,
            height: cropRect.height
        )
        
        bottomOverlayView.frame = CGRect(
            x: image.minX,
            y: image.maxY,
            width: image.width,
            height: cropRect.maxY - image.maxY
        )
    }
}


extension CropContainerView: CropViewDelegate{
    func didResizeStart(_ view: CropView) {
        isResizing = true
    }
    
    func didResizeChange(_ view: CropView) {
        
        let frame = adjustRectIfResize(view)
        cropView.frame = frame
        updateOverlay(frame)
    }
    
    func didResizeEnd(_ view: CropView) {
        isResizing = false
    }
    
    
    func didMoveStart(_ view: CropView) {
        isMoving = true
    }
    
    func didMoveChange(_ view: CropView) {
        let fram = adjustRectIfMove(view)
        cropView.frame = fram
        updateOverlay(fram)
    }
    
    func didMoveEnd(_ view: CropView) {
        isMoving = false
    }
    
    // isKeepRaio ->  multiply the ratio of the changed Height or Width
    
    private func adjustRectIfResize(_ view: CropView) -> CGRect {
        var frame = view.frame
        let convertFrame = self.convert(frame, to: self)
        
        
        if frame.minX < imageView!.frame.minX {
            frame.origin.x = self.convert(imageView!.frame, to: self).minX
            let width = convertFrame.maxX
            
            var height = frame.size.height
            if isKeepRaio{ height *=  (width / frame.size.width)}
            
            frame.size = CGSize(width: width, height: height)
        }
        
        if frame.minY < imageView!.frame.minY {
            let imageMinY = self.convert(imageView!.frame, to: self).minY
            let height = frame.maxY - imageMinY
            frame.origin.y = imageMinY
            
            var width = frame.size.width
            if isKeepRaio{
                width *= (height / frame.size.height)
            }
            
            frame.size = CGSize(width: width, height: height)
        }
        
        if frame.maxX > imageView!.frame.maxX {
            let width = self.convert(imageView!.frame, to: self).maxX - frame.minX
            
            var height = frame.size.height
            if isKeepRaio{ height *= (width / frame.size.width) }
            
            frame.size = CGSize(width: width, height: height)
        }
        
        if frame.maxY > imageView!.frame.maxY {
            let height = self.convert(imageView!.frame, to: self).maxY - frame.minY
            
            var width = frame.size.width
            if isKeepRaio{ width *= (height / frame.size.height) }
            
            frame.size = CGSize(width: width, height: height)
        }
        
        return frame
    }
    
    private func adjustRectIfMove(_ view: CropView) -> CGRect {
        var frame = view.frame
        
        if frame.minX < imageView!.frame.minX {
            frame.origin.x = self.convert(imageView!.frame, to: self).minX
        }
        
        if frame.minY < imageView!.frame.minY {
            frame.origin.y = self.convert(imageView!.frame, to: self).minY
        }
        
        if frame.maxX > imageView!.frame.maxX {
            frame.origin.x = self.convert(imageView!.frame, to: self).maxX - frame.width
        }
        
        if frame.maxY > imageView!.frame.maxY {
            frame.origin.y = self.convert(imageView!.frame, to: self).maxY - frame.height
        }
        
        return frame
    }
    
    private func centerPoint() -> CGPoint{
        imageView!.center
    }
    
    private func ratioSize(_ ratio: CropRatio) -> CGSize?{
        if case .freeform = ratio{
            return nil
        }
        
        let width = imageView!.frame.width
        let heigth = imageView!.frame.height
        
        //Image Portrait
        if width < heigth{
            return switch ratio {
            case .square:  CGSize(width: width, height: width)
            case .fourToThree: CGSize(width: width, height: width * (3 / 4))
            case .threeToFour:  CGSize(width: width, height: width * (4 / 3))
            default : fatalError()
            }
        }
        
        //Image Landscape
        return switch ratio {
        case .square: CGSize(width: heigth, height: heigth)
        case .fourToThree:  CGSize(width: heigth * (4 / 3), height: heigth)
        case .threeToFour: CGSize(width: heigth * (3 / 4), height: heigth)
        default : fatalError()
        }
    }
    
    
}

