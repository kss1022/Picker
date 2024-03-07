//
//  GridCell.swift
//  Picker
//
//  Created by 한현규 on 3/7/24.
//

import UIKit



final class GridCell: UICollectionViewCell{
                
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        
        imageView.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
    }
    
    func setImage(_ image: UIImage){
        imageView.image = image
    }
    

  
}
