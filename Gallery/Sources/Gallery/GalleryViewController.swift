//
//  GalleryViewController.swift
//  Picker
//
//  Created by 한현규 on 3/3/24.
//

import ModernRIBs
import UIKit
import AlbumEntity


protocol GalleryPresentableListener: AnyObject {    
    func titleViewDidTap()
    func doneButtonDidTap()
    func permissionButtonDidTap()
    func photoDidtap(_ photo: Photo)
}

final class GalleryViewController: UIViewController, GalleryPresentable, GalleryViewControllable {

    weak var listener: GalleryPresentableListener?
    
    private lazy var titleView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .bold)
        button.addTarget(self, action: #selector(titleViewTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var doneBarButtonItem: DoneBarButtonItem = {
        let barButtonItem = DoneBarButtonItem()
        barButtonItem.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doneBarButtonItemTap))
        barButtonItem.addGestureRecognizer(tapGesture)
                
        return barButtonItem
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0.0
        return stackView
    }()
    
    
    private lazy var photoGridView: PhotoGridView = {
        let photoGridView = PhotoGridView()
        photoGridView.translatesAutoresizingMaskIntoConstraints = false
        photoGridView.delegate = self
        return photoGridView
    }()
            
    private lazy var permissionDeniedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("사진 접근 허용하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self,action: #selector(permissionButtonTap),for: .touchUpInside)
        return button
    }()
    
    private lazy var permissionLimitedButton: UIView = {
        let view = PermissionLimitedView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.requestPermoissionButton.addTarget(self,action: #selector(permissionButtonTap),for: .touchUpInside)
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
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBarButtonItem)

        view.addSubview(stackView)
        view.addSubview(permissionDeniedButton)
        
        
        stackView.addArrangedSubview(permissionLimitedButton)
        stackView.addArrangedSubview(photoGridView)
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            permissionDeniedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            permissionDeniedButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
     
    }
    
    //MARK: ViewControllerable
    func showAlbums(_ view: ViewControllable) {
        let vc = view.uiviewController
        
        let view = vc.view!
        photoGridView.addSubview(view)
        
        view.clipsToBounds = true
                    
        
        view.bounds.origin.y = view.frame.height
        UIView.animate(withDuration: 0.25) {
            view.bounds.origin.y = 0
        }
                
        vc.didMove(toParent: self)
    }
    
    func hideAlbums(_ view: ViewControllable) {
        let vc = view.uiviewController
        
        let view = vc.view!
        
        UIView.animate(withDuration: 0.25) {
            view.bounds.origin.y = view.frame.height
        } completion: { _ in
            view.removeFromSuperview()
            vc.didMove(toParent: nil)
        }
    }

    
    //MARK: Prsentable
    func showPermissionDenied() {
        permissionDeniedButton.isHidden = false
    }
    
    func showPermissionLimited() {
        permissionLimitedButton.isHidden = false
    }

    func openSetting() {
        URLSchemeManager.shared.openSetting()
    }
    
    func showAlbum(_ viewModel: PhotoGridViewModel) {
        navigationItem.titleView = nil
        titleView.setTitle(viewModel.name, for: .normal)
        navigationItem.titleView = titleView
        photoGridView.showPhotos(viewModel)
    }
    
    func albumChanged(_ change: AlbumChange) {
        photoGridView.albumChanged(change)
    }
    
    func limitedAlbumChanged() {
        photoGridView.limitedAlbumChanged()
    }
    
    func showSelectionCount(_ count: Int) {
        doneBarButtonItem.count(count)
    }
    
    @objc
    private func titleViewTap(){
        listener?.titleViewDidTap()
    }
    
    @objc
    private func doneBarButtonItemTap(){
        listener?.doneButtonDidTap()
    }
    
    @objc
    private func permissionButtonTap(){
        listener?.permissionButtonDidTap()
    }
}


extension GalleryViewController: PhotoGridViewDelegate{
    func photoDidTap(_ photo: Photo) {
        listener?.photoDidtap(photo)
    }
}
