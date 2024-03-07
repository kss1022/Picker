//
//  File.swift
//  
//
//  Created by 한현규 on 3/3/24.
//

import UIKit
import UIUtils
import GalleryUtils
import AlbumEntity
import Selection


final class PhotoCell: UICollectionViewCell{
                
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = .none
        return imageView
    }()
    
    private let selectLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center        
        label.layer.borderWidth = 1.0
        return label
    }()
    
    private let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
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
        contentView.addSubview(selectLabel)
        contentView.addSubview(dimView)
        
        imageView.frame = self.bounds
        dimView.frame = self.bounds
        
        
        let inset: CGFloat = 8.0
        let boxSize: CGFloat = 22.0
        
        
        selectLabel.roundCorners(boxSize / 2)
        NSLayoutConstraint.activate([
            selectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            selectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            selectLabel.widthAnchor.constraint(equalToConstant: boxSize),
            selectLabel.heightAnchor.constraint(equalToConstant: boxSize)
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
        dimView.frame = self.bounds
    }
    
    func bindPhoto(_ viewModel: PhotoGridCellViewModel){
        let photo = viewModel.photo
        imageView.load(photo.asset)
        imageView.layer.borderColor = viewModel.imageBorderColor
        dimView.isHidden = viewModel.dimIsHidden
        
        selectLabel.text = viewModel.selectNum
        selectLabel.backgroundColor = viewModel.selectLabelBackgroundColor
        selectLabel.layer.borderColor = viewModel.selectLabelBorderColor
    }
    

  
}
