//
//  PhotoEditorFramViewController.swift
//
//
//  Created by 한현규 on 3/7/24.
//

import UIKit
import AlbumEntity
import AVFoundation

class PhotoEditorFramViewController: UIViewController {
    
    var index: Int = 0
    
    private var imageSize = CGSize(width: 1.0, height: 1.0)
    
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    

    func showPhoto(_ image : Image){
        ImageLoader.shared.loadImage(image) { [weak self] image in
            self?.setImage(image)
        }
    }
    
    private func setImage(_ image: UIImage?){
        if image != nil{
            imageSize = image!.size
        }
        
        imageView.image = image
        imageView.transform = .identity
                
        updateFrame()
    }
    
    func rorateImage(radians: CGFloat){
        self.imageSize = reverseImageSize()
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self  else { return }
            imageView.transform = imageView.transform.rotated(by: radians)
            updateFrame()
            self.view.layoutIfNeeded()
        }
    }
    

    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFrame()
    }
    
    func setLayout(){
        view.addSubview(imageView)
    }
    
    private func updateFrame(){
        let cropRect = AVMakeRect(aspectRatio: imageSize, insideRect: view.bounds)
        imageView.frame = cropRect
    }
    
    private func reverseImageSize() -> CGSize{
        CGSize(width: imageSize.height, height: imageSize.width)
    }
       
}

