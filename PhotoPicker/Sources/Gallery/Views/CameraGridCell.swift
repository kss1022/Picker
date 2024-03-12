//
//  CameraGridCell.swift
//
//
//  Created by 한현규 on 3/12/24.
//

import UIKit


final class CameraGridCell: UICollectionViewCell{
      
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
        let inset: CGFloat = 16.0
        imageView.frame = contentView.frame.insetBy(dx: inset, dy: inset)
    }
        
}
