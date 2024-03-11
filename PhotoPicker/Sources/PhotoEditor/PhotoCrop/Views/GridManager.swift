//
//  GridManager.swift
//
//
//  Created by 한현규 on 3/12/24.
//

import Foundation
import UIKit



final class GridManager{
    private let borderPadding: CGFloat
    private let mainColor: UIColor
    private let subColor: UIColor
    
    private var drawMainGride = true
    private var drawSubGride = true
    
    init(borderPadding: CGFloat = 0.5) {
        self.borderPadding = borderPadding
        self.mainColor = .white
        self.subColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 0.3)
    }
    
    func draw(rect: CGRect){
        if drawMainGride{
            drawMainGrid(rect: rect)
        }
        
        if drawSubGride{
            drawSubGrid(rect: rect)
        }
    }
    
    
    func showMainGride(){
        drawMainGride = true
    }
    
    func hideMainGride(){
        drawMainGride = false
    }
        
    func showSubGride(){
        drawSubGride = true
    }
    
    func hideSubGride(){
        drawSubGride = false
    }
    
}

//MARK: MainGride
extension GridManager{
    
    private func drawMainGrid(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        for i in 1..<3 {
            drawMainRow(width: width, height: height, i: i)
            drawMainCol(width: width, height: height, i: i)
        }
    }
        
    private func drawMainRow(width: CGFloat , height: CGFloat, i: Int){
        
        let rowPath = UIBezierPath()
        rowPath.move(
            to: CGPoint(
                x: borderPadding,
                y: round(CGFloat(i) * height / 3.0)
            )
        )
        rowPath.addLine(
            to: CGPoint(
                x: round(width) - borderPadding * 2.0,
                y: round(CGFloat(i) * height / 3.0)
            )
        )
        mainColor.set()
        rowPath.lineWidth = 1.0
        rowPath.stroke()
    }
    
    private func drawMainCol(width: CGFloat , height: CGFloat, i: Int){
        let colPath = UIBezierPath()
        colPath.move(
            to: CGPoint(
                x: round(CGFloat(i) * width / 3.0),
                y: borderPadding
            )
        )
        colPath.addLine(
            to: CGPoint(
                x: round(CGFloat(i) * width / 3.0),
                y: round(height) - borderPadding * 2.0)
        )
        mainColor.set()
        colPath.lineWidth = 1.0
        colPath.stroke()
    }
}

//MARK: SubGrid
extension GridManager{
    private func drawSubGrid(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        for i in 0..<3 {
            for j in 1..<3 {
                drawSubRow(width: width, height: height, i: i, j: j)
                drawSubCol(width: width, height: height, i: i, j: j)
            }
        }
    }


    private  func drawSubRow(width: CGFloat , height: CGFloat, i: Int, j : Int){
        let rowPath = UIBezierPath()
        rowPath.move(
            to: CGPoint(
                x: borderPadding,
                y: round((height / 9.0) * CGFloat(j) + (height / 3.0) * CGFloat(i)))
        )
        rowPath.addLine(
            to: CGPoint(
                x: round(width) - borderPadding * 2.0,
                y: round((height / 9.0) * CGFloat(j) + (height / 3.0) * CGFloat(i)))
        )
        
        subColor.set()
        rowPath.lineWidth = 1.0
        rowPath.stroke()
        
    }
    
    private  func drawSubCol(width: CGFloat , height: CGFloat, i: Int, j : Int){
        let colPath = UIBezierPath()
        colPath.move(
            to: CGPoint(
                x: round((width / 9.0) * CGFloat(j) + (width / 3.0) * CGFloat(i)),
                y: borderPadding
            )
        )
        colPath.addLine(
            to: CGPoint(
                x: round((width / 9.0) * CGFloat(j) + (width / 3.0) * CGFloat(i)),
                y: round(height) - borderPadding * 2.0)
        )
        subColor.set()
        colPath.lineWidth = 1.0
        colPath.stroke()
    }
}
