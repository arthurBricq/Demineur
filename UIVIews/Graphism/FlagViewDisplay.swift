//
//  FlagViewDisplay.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 09/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

@IBDesignable
class FlagViewDisplay: UIView {
    
    @IBInspectable var  couleurBaton: UIColor = UIColor(red: 0.350, green: 0.274, blue: 0.000, alpha: 1.000)
    @IBInspectable var couleurDrapeau: UIColor = UIColor(red: 0.176, green: 0.523, blue: 0.035, alpha: 1.000)
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        Flag.drawCanvas2(frame: rect, resizing: .aspectFill, couleurDreapeau: couleurDrapeau, couleurBaton:  couleurBaton)
    }
    
    
}



public class Flag : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 240, height: 240), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 240, height: 240), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 240, y: resizedFrame.height / 240)
        
        
        //// Color Declarations
        let color4 = UIColor(red: 0.350, green: 0.274, blue: 0.000, alpha: 1.000)
        let color = UIColor(red: 0.176, green: 0.523, blue: 0.035, alpha: 1.000)
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 73, y: 13))
        bezier3Path.addLine(to: CGPoint(x: 73, y: 106))
        bezier3Path.addCurve(to: CGPoint(x: 120.64, y: 95), controlPoint1: CGPoint(x: 90.87, y: 90), controlPoint2: CGPoint(x: 105.96, y: 93.21))
        bezier3Path.addCurve(to: CGPoint(x: 159.78, y: 78), controlPoint1: CGPoint(x: 145.31, y: 98), controlPoint2: CGPoint(x: 159.78, y: 78))
        bezier3Path.addCurve(to: CGPoint(x: 187, y: 78), controlPoint1: CGPoint(x: 177.64, y: 63), controlPoint2: CGPoint(x: 187, y: 78))
        bezier3Path.addCurve(to: CGPoint(x: 153.82, y: 52), controlPoint1: CGPoint(x: 187, y: 78), controlPoint2: CGPoint(x: 177.89, y: 52))
        bezier3Path.addCurve(to: CGPoint(x: 120.64, y: 31), controlPoint1: CGPoint(x: 136.76, y: 52), controlPoint2: CGPoint(x: 129.15, y: 37))
        bezier3Path.addCurve(to: CGPoint(x: 73, y: 31), controlPoint1: CGPoint(x: 100.13, y: 16.53), controlPoint2: CGPoint(x: 73, y: 31))
        color.setFill()
        bezier3Path.fill()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 73, y: 30))
        bezier2Path.addCurve(to: CGPoint(x: 73, y: 240), controlPoint1: CGPoint(x: 73, y: 34.87), controlPoint2: CGPoint(x: 73, y: 240))
        color4.setStroke()
        bezier2Path.lineWidth = 8
        bezier2Path.stroke()
        
        context.restoreGState()
        
    }
    
    @objc dynamic public class func drawCanvas2(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 240, height: 240), resizing: ResizingBehavior = .aspectFit, couleurDreapeau: UIColor, couleurBaton: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 240, height: 240), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 240, y: resizedFrame.height / 240)
        
        
        //// Color Declarations
        let color4 = couleurBaton
        let color = couleurDreapeau
        
        //// Group
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 81.5, y: 29.5))
        bezier4Path.addLine(to: CGPoint(x: 81.5, y: 108.5))
        bezier4Path.addLine(to: CGPoint(x: 177.5, y: 73.5))
        bezier4Path.addLine(to: CGPoint(x: 81.5, y: 29.5))
        bezier4Path.close()
        color.setFill()
        bezier4Path.fill()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 81, y: 30))
        bezier2Path.addCurve(to: CGPoint(x: 81, y: 240), controlPoint1: CGPoint(x: 81, y: 34.87), controlPoint2: CGPoint(x: 81, y: 240))
        color4.setStroke()
        bezier2Path.lineWidth = 8
        bezier2Path.stroke()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(FlagResizingBehavior)
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
