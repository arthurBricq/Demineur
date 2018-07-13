//
//  CrossView.swift
//  DemineIt
//
//  Created by Marin on 06/06/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

@IBDesignable
class BombView: UIView {
    
    @IBInspectable var percent: CGFloat = 1.0
    @IBInspectable var color: UIColor = UIColor.red
    @IBInspectable var lineWidth: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    init(frame: CGRect, percentOfCase: CGFloat = 1.0, lineWidth: CGFloat = 1.0, color: UIColor = UIColor.red) {
        super.init(frame: frame)
        self.percent = percentOfCase
        self.lineWidth = lineWidth
        self.color = color
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let percent = (1-self.percent)/2
        
        let point1 = CGPoint(x: percent*rect.width, y: percent*rect.height)
        let point2 = CGPoint(x: (1-percent)*rect.width, y: (1-percent)*rect.height)
        let point3 = CGPoint(x: percent*rect.width, y: (1-percent)*rect.height)
        let point4 = CGPoint(x: (1-percent)*rect.width, y: percent*rect.height)
        
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.move(to: point3)
        path.addLine(to: point4)
        
        path.lineWidth = lineWidth
        
        color.setStroke()
        path.stroke()
        
    }
    
}
