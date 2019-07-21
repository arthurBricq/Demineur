//
//  FlagView.swift
//  DemineIt
//
//  Created by Marin on 07/06/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
class FlagView: UIView {
    
    var color: UIColor
    var circleCenter: CGPoint
    var r: CGFloat
    var id: String
    
    override init(frame: CGRect) {
        self.color = UIColor.orange
        self.circleCenter = CGPoint.zero
        self.r = 0.0
        self.id = ""
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    init(frame: CGRect, circleCenter: CGPoint, r: CGFloat, id: String, color: UIColor = UIColor.orange) {
        self.circleCenter = circleCenter
        self.r = r
        self.color = color
        self.id = id
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        print("frame = \(frame)")
        let path = UIBezierPath(arcCenter: circleCenter, radius: r, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        color.setFill()
        path.fill()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
}
