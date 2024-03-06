//
//  Selection.swift
//
//
//  Created by 한현규 on 3/5/24.
//

import Foundation
import AlbumEntity


public final class Selection{
    
    private(set) var selectedItems: [Photo]
    private(set) var limit: Int

    
    public func select(_ photo: Photo){
        if selectedItems.count == limit{
            return
        }
        
        selectedItems.append(photo)
    }
    
    public func deSelect(_ photo: Photo){
        for i in 0..<count{
            if selectedItems[i] == photo{
                selectedItems.remove(at: i)
                return
            }
        }
    }
    
    
    public func toogle(_ photo: Photo){
        if isSelect(photo){
            deSelect(photo)
            return
        }
        
        select(photo)
    }
    
    
    public func setLimit(_ limit: Int){
        if selectedItems.count > limit{
            return
        }
        
        self.limit = limit
    }
    
    public func selectNum(_ photo: Photo) -> Int{
        var result = 0
        for i in 0..<selectedItems.count{
            if selectedItems[i] == photo{
                result = i + 1
                break
            }
        }
        
        return result
    }
    
    public func isSelect(_ photo: Photo) -> Bool{
        selectedItems.contains { $0 == photo }
    }
    
    public var count: Int{
        selectedItems.count
    }
    
    public var isEmpty: Bool{
        selectedItems.isEmpty
    }
    
    public subscript(position: Int) -> Photo{
        selectedItems[position]
    }
    
    public init(){
        selectedItems = []
        limit = 10
    }
        
}
