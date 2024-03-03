//
//  PermissionLimitedView.swift
//  
//
//  Created by 한현규 on 3/3/24.
//

import UIKit



final class PermissionLimitedView: UIView{
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0.0
        return stackView
    }()
    
    private let permissionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.text = "지금 모든 사진 접근 권한을 허용하면 더 쉽고 편하게 사진을 올릴수 있어요."
        label.numberOfLines = 2
        return label
    }()
    
    lazy var requestPermoissionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("사진 접근 허용하기", for: .normal)
        return button
    }()
    
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    
    private func setView(){
        backgroundColor = .secondarySystemBackground
        addSubview(stackView)
                
        
        stackView.addArrangedSubview(permissionDescriptionLabel)
        stackView.addArrangedSubview(requestPermoissionButton)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        
    }
    
}
