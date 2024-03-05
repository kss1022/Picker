//
//  AlbumCell.swift
//
//
//  Created by 한현규 on 3/5/24.
//

import UIKit
import UIUtils
import GalleryUtils

final class AlbumCell: UITableViewCell{
    
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.roundCorners(4.0)
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.minimumScaleFactor = 1.0
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        contentView.addSubview(previewImageView)
        contentView.addSubview(labelStackView)
        
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(countLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            previewImageView.centerYAnchor.constraint(equalTo: labelStackView.centerYAnchor),
            previewImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 60.0),
            previewImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 60.0),
            
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: inset),
            labelStackView.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor , constant: inset),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -inset),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor , constant: -inset),
        ])

    }
    
    func bindView(_ viewModel: AlbumViewModel){
        if viewModel.count != 0{
            let photo = viewModel.photo(0)
            previewImageView.load(photo.asset)
        }
                
        nameLabel.text = viewModel.name
        countLabel.text = "\(viewModel.count)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        previewImageView.image = nil
        nameLabel.text = nil
        countLabel.text = nil
    }
}
