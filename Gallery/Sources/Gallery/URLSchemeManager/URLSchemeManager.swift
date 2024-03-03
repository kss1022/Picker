//
//  URLSchemeManager.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import UIKit



public final class URLSchemeManager{
    
    public static let shared = URLSchemeManager()
    
    private init(){}
    
    public func openSetting(){
        if let url = URL(string: UIApplication.openSettingsURLString){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
        
}
