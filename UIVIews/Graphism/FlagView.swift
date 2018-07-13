//
//  FlagView.swift
//  DemineIt
//
//  Created by Marin on 07/06/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class FlagView: UIView {
    
    var color: UIColor = UIColor.orange
    var circleCenter: CGPoint = CGPoint.zero
    var r: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    init(frame: CGRect, circleCenter: CGPoint, r: CGFloat, color: UIColor = UIColor.orange) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.circleCenter = circleCenter
        self.r = r
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(arcCenter: circleCenter, radius: r, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        color.setFill()
        path.fill()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}
