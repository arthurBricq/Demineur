//
//  RoundButtonWithNumber.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 09/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
class RoundButtonWithNumber: UIButton {
    
    var strokeColor: UIColor = .brown
    var lineWidth: CGFloat = 1.0
    var delegate: RoundButtonsCanCallVC?
    var number: Int = 1
    
    override func draw(_ rect: CGRect) {
        
        if rect.width != rect.height {
            print("le boutton rond n'est pas un carre")
        }
        
        // dessin du cercle
        let radius = rect.width/2
        let p1 = CGPoint(x: radius, y:radius )
        let circle1 = UIBezierPath(arcCenter: p1, radius: 0.96*radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        strokeColor.setStroke()
        circle1.stroke()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.alpha = 0.4
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
        
        delegate!.buttonTapped(withIndex: number)
        
    }
    
    
}
