//
//  GalleryViewController.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import ModernRIBs
import UIKit

protocol GalleryPresentableListener: AnyObject {
    func permissionButtonDidTap()
}

final class GalleryViewController: UIViewController, GalleryPresentable, GalleryViewControllable {

    weak var listener: GalleryPresentableListener?
    
    private lazy var permissionDeniedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("사진 접근 허용하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var permissionLimitedButton: UIView = {
        let view = PermissionLimitedView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
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
        view.addSubview(permissionDeniedButton)
        view.addSubview(permissionLimitedButton)
        
        
        NSLayoutConstraint.activate([
            permissionDeniedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            permissionDeniedButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            permissionLimitedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            permissionLimitedButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            permissionLimitedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func showPermissionDenied() {
        permissionDeniedButton.isHidden = false
    }
    
    func showPermissionLimited() {
        permissionLimitedButton.isHidden = false
    }

    func openSetting() {
        URLSchemeManager.shared.openSetting()
    }
    
    func showAlbum(_ viewModel: AlbumViewModel) {
        //shwoTitle
        //showPhotos
    }
    
    
    @objc
    private func permissionButtonTap(){
        listener?.permissionButtonDidTap()
    }
}
