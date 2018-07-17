//
//  LineView.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 06/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/*
 Cette classe trace une ligne verticale
 **/
// @IBDesignable
class LineView: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 2
    @IBInspectable var strokeColor: UIColor = UIColor(red: 0.720, green: 0.469, blue: 0.000, alpha: 1.000)
    @IBInspectable var isVertical: Bool = true
    
    override func draw(_ rect: CGRect) {
        
        let p1 = isVertical ? CGPoint(x: rect.width/2, y: 0) : CGPoint(x: 0, y: rect.height/2)
        let p2 = isVertical ? CGPoint(x: rect.width/2, y: rect.height) : CGPoint(x: rect.width, y: rect.height/2)
        let line = UIBezierPath()
        line.move(to: p1)
        line.addLine(to: p2)
        line.lineWidth = lineWidth
        strokeColor.setStroke()
        line.stroke()
        
    }
    
    
}
