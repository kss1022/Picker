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
    func closeButtonDidTap()
    func doneButtonDidTap()
    func editButtonDidTap()
    func permissionButtonDidTap()    
    func photoDidtap(_ photo: Photo)
    func cameraDidTap()
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
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeBarButtonItemTap)
        )
        return barButtonItem
    }()
    
    private lazy var doneBarButtonItem: DoneBarButtonItem = {
        let barButtonItem = DoneBarButtonItem()
        barButtonItem.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doneBarButtonItemTap))
        barButtonItem.addGestureRecognizer(tapGesture)
                
        return barButtonItem
    }()
    
    
    private lazy var photoEditBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "wand.and.rays"),
            style: .plain,
            target: self,
            action: #selector(photoEditBarButtonItemTap)
        )
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    private lazy var cameraBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .camera,
            target: self,
            action: #selector(cameraBarButtonItemTap)
        )
        barButtonItem.tintColor = .label
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
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBarButtonItem)
        
        toolbarItems =  [photoEditBarButtonItem, cameraBarButtonItem]
        

        view.addSubview(stackView)
        view.addSubview(permissionDeniedButton)
        
        
        stackView.addArrangedSubview(permissionLimitedButton)
        stackView.addArrangedSubview(photoGridView)
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
    
    func showCameraPermissionDenied() {
        let alert = UIAlertController(
            title: "카메라에 대한 엑세스 권한이 없어요.",
            message: "설정 앱에서 권한을 수정할 수 있어요.",
            preferredStyle: .alert
        )
        
        let settingAction = UIAlertAction(
            title: "지금 설정하기",
            style: .default) { [weak self] _ in
                self?.listener?.permissionButtonDidTap()
            }
        
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel) { _ in
                alert.dismiss(animated: true)
            }
        
        [settingAction, cancelAction].forEach {
            alert.addAction($0)
        }
        
        
        self.present(alert, animated: true, completion: nil)
        
    }

    func openSetting() {
        URLSchemeManager.shared.openSetting()
    }
    
    func showPhotoGrid(_ viewModel: PhotoGridViewModel) {        
        photoGridView.showPhotos(viewModel)
    }    
    
    func showAlbumName(_ albumName: String?) {
        navigationItem.titleView = nil
        titleView.setTitle(albumName, for: .normal)
        navigationItem.titleView = titleView
    }
    
    func albumChanged(_ change: AlbumChange) {
        photoGridView.albumChanged(change)        
    }
    
    func limitedAlbumChanged(_ change: AlbumChange) {
        photoGridView.limitedAlbumChanged(change)
    }
    
    func showSelectionCount(_ count: Int) {
        doneBarButtonItem.count(count)
    }
    
    @objc
    private func titleViewTap(){
        listener?.titleViewDidTap()
    }
    
    @objc
    private func closeBarButtonItemTap(){
        listener?.closeButtonDidTap()
    }
    
    @objc
    private func doneBarButtonItemTap(){
        listener?.doneButtonDidTap()
    }
    
    @objc
    private func photoEditBarButtonItemTap(){
        listener?.editButtonDidTap()
    }
    
    @objc
    private func cameraBarButtonItemTap(){
        listener?.cameraDidTap()
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
