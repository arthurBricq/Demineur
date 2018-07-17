//
//  ClockView.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 04/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
class ClockView: UIView {
    
    @IBInspectable var pourcentage: CGFloat = 0.1 {// is the ratio of the time already used to be shown.
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var roundEpaisseur: CGFloat = 2.0
    
    override func draw(_ rect: CGRect) {
        let angle = -270 + pourcentage*359 // in degrees
        ClockTimer.drawCanvas1(frame: rect, resizing: .aspectFill, angle: angle, roundEpaisseur: roundEpaisseur)
    }
    
}


public class ClockTimer : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 104, height: 104), resizing: ResizingBehavior = .aspectFit, angle: CGFloat = -270, roundEpaisseur: CGFloat = 2.0) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 104, height: 104), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 104, y: resizedFrame.height / 104)
        
        
        //// Color Declarations
        let color3 = UIColor(red: 0.791, green: 0.047, blue: 0.047, alpha: 1.000)
        
        //// Oval Drawing
        context.saveGState()
        context.translateBy(x: 52, y: 52)
        
        let ovalRect = CGRect(x: -50, y: -50, width: 100, height: 100)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width / 2, startAngle: -90 * CGFloat.pi/180, endAngle: -angle * CGFloat.pi/180, clockwise: true)
        
        UIColor.gray.setStroke()
        ovalPath.lineWidth = 2
        ovalPath.stroke()
        
        context.restoreGState()
        
        
        //// Bezier Drawing
        context.saveGState()
        context.translateBy(x: 52, y: 52)
        context.scaleBy(x: 1, y: -1)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 36))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        UIColor.gray.setStroke()
        bezierPath.lineWidth = 4
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
        
        context.restoreGState()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 52, y: 52))
        bezier2Path.addLine(to: CGPoint(x: 72, y: 52))
        UIColor.gray.setStroke()
        bezier2Path.lineWidth = 4
        bezier2Path.lineCapStyle = .round
        bezier2Path.stroke()
        
        
        //// Oval 2 Drawing
        context.saveGState()
        context.translateBy(x: 52, y: 52)
        context.rotate(by: -angle * CGFloat.pi/180)
        
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 48, y: -2, width: 4, height: 4))
        color3.setFill()
        color3.setStroke()
        oval2Path.lineWidth = roundEpaisseur
        oval2Path.fill()
        oval2Path.stroke()
        
        context.restoreGState()
        context.restoreGState()
        
    }
    
    
    @objc(ClockTimerResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
