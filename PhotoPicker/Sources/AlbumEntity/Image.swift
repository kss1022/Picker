//
//  PhotoImage.swift
//
//
//  Created by 한현규 on 3/11/24.
//

import Foundation
import UIKit
import Photos

public protocol Image{
    func loadImage(_ options: PHImageRequestOptions, _ completionHandler: @escaping (UIImage?) -> Void)    
}
