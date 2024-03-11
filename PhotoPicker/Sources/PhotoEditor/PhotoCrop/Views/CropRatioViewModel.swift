//
//  CropRatioViewModel.swift
//
//
//  Created by 한현규 on 3/12/24.
//

import UIKit



struct CropRatioViewModel: Equatable{
    
    private let cropRatio: CropRatio
    
    var name: String{
        switch cropRatio {
        case .freeform: "자유롭게"
        case .square: "1:1"
        case .fourToThree: "4:3"
        case .threeToFour: "3:4"
        }
    }
    
    var image: UIImage?{
        switch cropRatio {
        case .freeform: UIImage(systemName: "square.dashed")
        case .square: UIImage(systemName: "square")
        case .fourToThree: UIImage(systemName: "rectangle")
        case .threeToFour: UIImage(systemName: "rectangle.portrait")
        }
    }
    
    let tapHandler: () -> Void
    
    init(cropRatio: CropRatio, tapHandler: @escaping () -> Void){
        self.cropRatio = cropRatio
        self.tapHandler = tapHandler
    }
    
    
    static func ==(lhs: CropRatioViewModel, rhs: CropRatioViewModel) -> Bool{
        lhs.cropRatio == rhs.cropRatio
    }
}
