//
//  PhotoEditorViewController.swift
//  Picker
//
//  Created by 한현규 on 3/7/24.
//

import ModernRIBs
import UIKit
import AlbumEntity

protocol PhotoEditorPresentableListener: AnyObject {
    func didMove()
                
    func doneButtonDidTap()
    func rotateButtonDidTap()
    func cropButtonDidTap()
    
    func pageDidChange(_ page: Int)
    func pageViewDidTap()
}

final class PhotoEditorViewController: UIViewController, PhotoEditorPresentable, PhotoEditorViewControllable {
    

    weak var listener: PhotoEditorPresentableListener?

    
    private var images: [Image]
    
    private var currentIndex : Int{
        didSet{
            let position = currentIndex + 1
            pageControl.text = "\(position)"
            title  = "\(position) / \(images.count)"
        }
    }
    private var nextIndex: Int?
    
    var singleTapGestureRecognizer: UITapGestureRecognizer!
    public var frameViewController = PhotoEditorFramViewController()
    
    
    private lazy var doneBarButtonItem: DoneBarButtonItem = {
        let barButtonItem = DoneBarButtonItem()
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(doneBarButtonTap))
        barButtonItem.addGestureRecognizer(tapHandler)
        return barButtonItem
    }()
    
    private lazy var cropBarButtonItem: UIBarButtonItem = {
        let barButtonItme = UIBarButtonItem(
            image: UIImage(systemName: "crop"),
            style: .plain,
            target: self,
            action: #selector(cropBarButtonTap)
        )
        
        barButtonItme.tintColor = .label
        return barButtonItme
    }()
    
    private lazy var rotateBarButtonItem: UIBarButtonItem = {
        let barButtonItme = UIBarButtonItem(
            image: UIImage(systemName: "rotate.left"),
            style: .plain,
            target: self,
            action: #selector(rotateBarButtonTap)
        )
        barButtonItme.tintColor = .label
        return barButtonItme
    }()
    
    
    private func flexibleSpaceToolbarItem() -> UIBarButtonItem{
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [.interPageSpacing : 32.0])
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return pageViewController
    }()
    
    var currentViewController: PhotoEditorFramViewController {
        return self.pageViewController.viewControllers![0] as! PhotoEditorFramViewController
    }
    
    private let pageControl : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        label.textColor = .white
        label.backgroundColor = .primaryColor
        
        label.roundCorners(24.0)
        
        return label
    }()
    
    init(){
        self.images = []
        self.currentIndex = 0
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        self.images = []
        self.currentIndex = 0
        super.init(coder: coder)
        
        setLayout()
    }
    

    
    private func setLayout(){
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: doneBarButtonItem)]
        
        toolbarItems = [
            flexibleSpaceToolbarItem(),
            cropBarButtonItem,
            flexibleSpaceToolbarItem(),
            rotateBarButtonItem,
            flexibleSpaceToolbarItem()
        ]
        navigationController?.isToolbarHidden = false
        
        
        view.addSubview(pageViewController.view)
        view.addSubview(pageControl)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
            pageControl.widthAnchor.constraint(equalToConstant: 48.0),
            pageControl.heightAnchor.constraint(equalToConstant: 48.0)
        ])
        
        pageViewController.didMove(toParent: self)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTapWith(gestureRecognizer:)))
        self.pageViewController.view.addGestureRecognizer(singleTapGestureRecognizer)
        
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil{
            listener?.didMove()
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: Set default index
    func showPhotos(_ images: [Image], _ page: Int) {
        self.images = images
        self.currentIndex = page
        
        let vc = PhotoEditorFramViewController()
        vc.index = self.currentIndex
        vc.showPhoto(images[currentIndex])
        let viewControllers = [vc]
        
        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        doneBarButtonItem.count(images.count)
    }
    
    func setPage(_ page: Int) {
        currentIndex = page
    }
    
    func rotatePhoto(_ image: Image) {
        if let vc = pageViewController.viewControllers?.first as? PhotoEditorFramViewController{
            vc.rorateImage(radians: .pi / 2)
        }
        images[currentIndex] = image
    }
    
    func cropPhoto(_ image: Image) {
        if let vc = pageViewController.viewControllers?.first as? PhotoEditorFramViewController{
            vc.showPhoto(image)
        }
        images[currentIndex] = image
    }
    
    @objc
    private func didSingleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        listener?.pageViewDidTap()        
    }
    
    
    func setFullScreen() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isToolbarHidden = true
        pageControl.isHidden = true
        UIView.animate(
            withDuration: 0.25,
            animations: { [weak self] in
                self?.view.backgroundColor = .black
            },
            completion: { completed in }
        )
    }
    
    func setNormalScreen() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.isToolbarHidden = false
        pageControl.isHidden = false
        UIView.animate(
            withDuration: 0.25,
            animations: { [weak self] in
                self?.view.backgroundColor = .systemBackground
            },
            completion: { completed in }
        )
    }

    

    @objc
    private func doneBarButtonTap(){        
        listener?.doneButtonDidTap()
    }
    
    @objc
    private func cropBarButtonTap(){
        listener?.cropButtonDidTap()
    }
    
    @objc
    private func rotateBarButtonTap(){
        listener?.rotateButtonDidTap()
    }
    
}





extension PhotoEditorViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if currentIndex == 0 {
            return nil
        }
        
        let vc = PhotoEditorFramViewController()
        vc.showPhoto(images[currentIndex - 1])
        vc.index = currentIndex - 1
        return vc
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if currentIndex == (images.count - 1) {
            return nil
        }
        
        let vc =  PhotoEditorFramViewController()
        vc.showPhoto(images[currentIndex + 1])
        vc.index = currentIndex + 1
        return vc
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let nextVC = pendingViewControllers.first as? PhotoEditorFramViewController else {
            return
        }
        
        nextIndex = nextVC.index
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed && self.nextIndex != nil) {
            listener?.pageDidChange(self.nextIndex!)
            //currentIndex = self.nextIndex!
        }
        
        nextIndex = nil
    }
    
}



