//
//  PhotoCropViewController.swift
//  
//
//  Created by 한현규 on 3/12/24.
//

import ModernRIBs
import UIKit
import AlbumEntity

protocol PhotoCropPresentableListener: AnyObject {
    func closeButtonDidTap()
    func doneButtonDidTap(_ rect: CGRect)
}

final class PhotoCropViewController: UIViewController, PhotoCropPresentable, PhotoCropViewControllable {
    
    weak var listener: PhotoCropPresentableListener?
    
    private let navigationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(doneButtonTap), for: .touchUpInside)
        return button
    }()
    
        
    private let cropContainerView: CropContainerView = {
        let view = CropContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let cropRatioButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        return stackView
    }()
        
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(cropContainerView)
        view.addSubview(navigationStackView)                
        view.addSubview(cropRatioButtonsStackView)
        
        navigationStackView.addArrangedSubview(closeButton)
        navigationStackView.addArrangedSubview(doneButton)
                
        let inset: CGFloat = 16.0
        let buttonSize: CGFloat = 24.0
        
        NSLayoutConstraint.activate([
            navigationStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            navigationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            navigationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            cropContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            cropContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cropContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            cropContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            
            cropRatioButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cropRatioButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            closeButton.widthAnchor.constraint(equalToConstant: buttonSize),
            closeButton.heightAnchor.constraint(equalToConstant: buttonSize),
            doneButton.widthAnchor.constraint(equalToConstant: buttonSize),
            doneButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return  [.portrait]
    }
    
    func setImage(_ image: Image) {
        ImageLoader.shared.loadImage(image) { [weak self] in
            self?.cropContainerView.setImage($0)
        }
    }
    
    func setCropRatios(_ viewModels: [CropRatioViewModel]) {
        viewModels.map(CropRatioButton.init)
            .forEach {
                cropRatioButtonsStackView.addArrangedSubview($0)
            }
    }
    
    func setCropRatio(_ cropRatio: CropRatio) {
        cropContainerView.setRatio(cropRatio)
    }
    
    func selectCropRatio(_ cropRatio: CropRatio) {
        guard let cropRatioButton = cropRatioButtonsStackView.arrangedSubviews[cropRatio.rawValue] as? CropRatioButton else {
            return
        }
        cropRatioButton.select()
    }
    
    func deSelectCropRatio(_ cropRatio: CropRatio) {
        guard let cropRatioButton = cropRatioButtonsStackView.arrangedSubviews[cropRatio.rawValue] as? CropRatioButton else {
            return
        }
        cropRatioButton.deSelect()
    }
    
    @objc
    private func closeButtonTap(){
        listener?.closeButtonDidTap()
    }
    
    @objc
    private func doneButtonTap(){
        let rect = cropContainerView.cropRect()        
        listener?.doneButtonDidTap(rect)
    }
}
