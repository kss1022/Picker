//
//  CropRatioButton.swift
//
//
//  Created by 한현규 on 3/12/24.
//

import UIKit
import UIUtils

final class CropRatioButton: UIControl{
    
    private var tapHandler : (()->Void)?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    init(_ cropRatio: CropRatioViewModel){
        super.init(frame: .zero)
        
        
        setView()
        
        label.text = cropRatio.name
        imageView.image = cropRatio.image
        tapHandler = cropRatio.tapHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(stackView)
        
        let tapHandler = UITapGestureRecognizer()
        tapHandler.addTarget(self, action: #selector(didTap))
        addGestureRecognizer(tapHandler)
        //addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
        
    func select(){
        label.textColor = .primaryColor
        imageView.tintColor = .primaryColor
    }
    
    func deSelect(){
        label.textColor = .label
        imageView.tintColor = .label
    }
    
    @objc
    private func didTap(){
        tapHandler?()
    }
}

