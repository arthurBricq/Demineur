//
//  HeartView.swift
//  Demineur
//
//  Created by Arthur BRICQ on 22/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class HeartView: UIView {

    override func draw(_ rect: CGRect) {
        Heart.drawCanvas1(frame: rect, resizing: .aspectFill)
    }
    
}


public class Heart : NSObject {
    
    //// Cache
    
    private struct Cache {
        static let color2: UIColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.000)
    }
    
    //// Colors
    
    @objc dynamic public class var color2: UIColor { return Cache.color2 }
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 95, height: 95), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 95, height: 95), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 95, y: resizedFrame.height / 95)
        
        
        //// Group
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 47.61, y: 20.98))
        bezierPath.addCurve(to: CGPoint(x: 31.71, y: 3.4), controlPoint1: CGPoint(x: 47.61, y: 20.98), controlPoint2: CGPoint(x: 46.39, y: 7.54))
        bezierPath.addCurve(to: CGPoint(x: 3.09, y: 15.35), controlPoint1: CGPoint(x: 17.03, y: -0.74), controlPoint2: CGPoint(x: 6.96, y: 7.02))
        bezierPath.addCurve(to: CGPoint(x: 12.08, y: 57.15), controlPoint1: CGPoint(x: -0.78, y: 23.68), controlPoint2: CGPoint(x: -0.65, y: 43.91))
        bezierPath.addCurve(to: CGPoint(x: 47.58, y: 93.99), controlPoint1: CGPoint(x: 24.81, y: 70.38), controlPoint2: CGPoint(x: 31.73, y: 77.04))
        Heart.color2.setFill()
        bezierPath.fill()
        
        
        //// Bezier 2 Drawing
        context.saveGState()
        context.translateBy(x: 93.72, y: 2.33)
        context.scaleBy(x: -1, y: 1)
        
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 46.74, y: 18.73))
        bezier2Path.addCurve(to: CGPoint(x: 30.85, y: 1.15), controlPoint1: CGPoint(x: 46.74, y: 18.73), controlPoint2: CGPoint(x: 45.52, y: 5.28))
        bezier2Path.addCurve(to: CGPoint(x: 2.22, y: 13.1), controlPoint1: CGPoint(x: 16.17, y: -2.99), controlPoint2: CGPoint(x: 6.09, y: 4.77))
        bezier2Path.addCurve(to: CGPoint(x: 11.21, y: 54.89), controlPoint1: CGPoint(x: -1.64, y: 21.43), controlPoint2: CGPoint(x: -1.52, y: 41.66))
        bezier2Path.addCurve(to: CGPoint(x: 46.71, y: 91.74), controlPoint1: CGPoint(x: 23.94, y: 68.13), controlPoint2: CGPoint(x: 30.87, y: 74.78))
        Heart.color2.setFill()
        bezier2Path.fill()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(HeartResizingBehavior)
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
