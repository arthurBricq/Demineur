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
    
    // MARK: - Variables
    
    @IBInspectable var lineWidth: CGFloat = 1
    @IBInspectable var strokeColor: UIColor = UIColor(red: 0.720, green: 0.469, blue: 0.000, alpha: 1.000)//184,120,0
    @IBInspectable var isVertical: Bool = true
    
    // MARK: - Functions
    
    /// Creates a line with the desired properties, with its tag set to -1 and with a clear background color. All the position/size properties are set to zero.
    init(lineWidth: CGFloat, isVertical: Bool, strokeColor: UIColor) {
        self.lineWidth = lineWidth
        self.isVertical = isVertical
        self.strokeColor = strokeColor
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tag = -1
        self.backgroundColor = UIColor.clear
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        strokeColor.setStroke()
        let p1 = isVertical ? CGPoint(x: rect.width/2, y: 0) : CGPoint(x: 0, y: rect.height/2)
        let p2 = isVertical ? CGPoint(x: rect.width/2, y: rect.height) : CGPoint(x: rect.width, y: rect.height/2)
        let line = UIBezierPath()
        line.move(to: p1)
        line.addLine(to: p2)
        line.lineWidth = lineWidth
        line.stroke()
        
    }
    
    
    
}
