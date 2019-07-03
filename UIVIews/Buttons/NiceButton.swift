//
//  NiceButton.swift
//  Demineur
//
//  Created by Arthur BRICQ on 25/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

@IBDesignable
class NiceButton: UIButton {
    
    @IBInspectable var color: UIColor = colorForRGB(r: 94, g: 94, b: 94) { didSet { updateText() } }
    @IBInspectable var textColor: UIColor = colorForRGB(r: 66, g: 66, b: 66) { didSet { updateText() } }

    @IBInspectable var lineWidth: CGFloat = 1.0
    
    @IBInspectable var text: String = "" { didSet { updateText() } }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let dec = lineWidth/2
        let insideRect = CGRect(x: dec, y: dec, width: rect.width - 2*dec, height: rect.height - 2*dec)
        let path = UIBezierPath(roundedRect: insideRect, cornerRadius: 10.0)
        
        path.lineWidth = lineWidth
        color.setStroke()
        
        path.stroke()
        
    }
    
    func updateText() {
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel!.font = UIFont(name: "PingFangSC-Regular", size: 15)
        self.tintColor = color
        self.setNeedsDisplay()
    }

}
