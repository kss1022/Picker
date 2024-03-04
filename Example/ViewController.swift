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

    override func viewDidLoad() {
        super.viewDidLoad()
                                
        navigationItem.rightBarButtonItem = addBarButtonItem
    }


    @objc
    private func addBarButtonItemTap(){
        let picker = PickerViewController()
        present(picker, animated: true)
    }
}

