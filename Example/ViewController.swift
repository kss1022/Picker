//
//  ViewController.swift
//  Picker
//
//  Created by 한현규 on 3/1/24.
//

import UIKit
import Gallery
import PhotoPicker

class ViewController: UIViewController {
    
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self, 
            action: #selector(addBarButtonItemTap)
        )
        return barButtonItem
    }()
    
    private let gridView: GridView = {
        let gridView = GridView()
        return gridView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
                                
        navigationItem.rightBarButtonItem = addBarButtonItem
        
        view.addSubview(gridView)
        gridView.frame = view.frame
    }


    @objc
    private func addBarButtonItemTap(){
        let picker = PickerViewController()
        picker.delegate = self
        picker.setLimit(5)
        present(picker, animated: true)
    }
}


extension ViewController: PickerViewControllerDelegate{
    func picker(_ picker: PickerViewController, didFinishPicking results: [PickerResult]) {
        picker.dismiss(animated: true)
        
        Task{
            let images = await PickerResult.loadImages(results).compactMap { $0 }
            await MainActor.run { gridView.showImages(images) }
        }
        
        
        
    }
}
