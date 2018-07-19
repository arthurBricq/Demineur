//
//  CheckerButton.swift
//  Demineur
//
//  Created by Arthur BRICQ on 16/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

@IBDesignable
class CheckerButton: UIButton {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    @IBInspectable var strokeColor: UIColor = UIColor.lightGray
    @IBInspectable var widthForCheck: CGFloat = 4.0
    @IBInspectable var strokeWidth: CGFloat = 5.0

    
    override func draw(_ rect: CGRect) {
        let contour = UIBezierPath(rect: rect)
        strokeColor.setStroke()
        contour.lineWidth = strokeWidth
        contour.stroke()
     
        if options.areVibrationsOn == true {
            Checker.drawCanvas1(frame: rect, resizing: .aspectFill, width: widthForCheck)
        }
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
        
        
        self.setNeedsDisplay()
        
    }
    
    
}


public class Checker : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 91, height: 91), resizing: ResizingBehavior = .aspectFit, width: CGFloat = 5) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 91, height: 91), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 91, y: resizedFrame.height / 91)
        
        
        //// Color Declarations
        let color = UIColor(red: 0.320, green: 0.623, blue: 0.355, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 9, y: 48))
        bezierPath.addCurve(to: CGPoint(x: 21, y: 62), controlPoint1: CGPoint(x: 9, y: 48), controlPoint2: CGPoint(x: 15.29, y: 53.62))
        bezierPath.addCurve(to: CGPoint(x: 31.85, y: 81.5), controlPoint1: CGPoint(x: 26.71, y: 70.38), controlPoint2: CGPoint(x: 31.85, y: 81.5))
        bezierPath.addCurve(to: CGPoint(x: 57.5, y: 37.5), controlPoint1: CGPoint(x: 31.85, y: 81.5), controlPoint2: CGPoint(x: 43.5, y: 56.5))
        bezierPath.addCurve(to: CGPoint(x: 84.5, y: 5.5), controlPoint1: CGPoint(x: 71.5, y: 18.5), controlPoint2: CGPoint(x: 84.5, y: 5.5))
        color.setStroke()
        bezierPath.lineWidth = width
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(CheckerResizingBehavior)
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
