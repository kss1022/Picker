//
//  PhotoGridViewModel.swift
//
//
//  Created by 한현규 on 3/6/24.
//

import Foundation
import UIKit
import AlbumEntity
import Selection


struct PhotoGridCellViewModel{
    let photo: Photo
        
    //ImageView
    let imageBorderColor: CGColor
    
    //Dim
    let dimIsHidden: Bool
    
    //SelectBox
    let selectNum: String
    let selectLabelBackgroundColor: UIColor
    let selectLabelBorderColor: CGColor
    
    
    init(photo: Photo, isSelect: Bool, selectNum: Int) {
        self.photo = photo
        self.dimIsHidden = !isSelect
        self.imageBorderColor = isSelect ? UIColor.primaryColor.cgColor : UIColor.clear.cgColor
        self.selectNum = isSelect ? "\(selectNum)" : ""
        self.selectLabelBackgroundColor = isSelect ? UIColor.primaryColor : .clear
        self.selectLabelBorderColor = isSelect ? UIColor.clear.cgColor : UIColor.white.cgColor
    }
}
