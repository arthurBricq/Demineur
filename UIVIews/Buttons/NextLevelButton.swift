//
//  NextLevelButton.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class NextLevelButton: UIButton {
    
    @IBInspectable var color: UIColor = UIColor.cyan
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        NextLevelDraw.drawCanvas1(frame: rect, resizing: .aspectFill, color: color)
    }
 

}

public class NextLevelDraw : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 240, height: 240), resizing: ResizingBehavior = .aspectFit, color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 240, height: 240), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 240, y: resizedFrame.height / 240)
        
        //// Group
        //// Group 2
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 141, y: 45))
        bezier3Path.addLine(to: CGPoint(x: 203, y: 122))
        color.setStroke()
        bezier3Path.lineWidth = 20
        bezier3Path.lineCapStyle = .round
        bezier3Path.stroke()
        
        
        
        
        //// Bezier Drawing
        context.saveGState()
        context.translateBy(x: 203, y: 122)
        context.scaleBy(x: -1, y: 1)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: 62, y: 77))
        color.setStroke()
        bezierPath.lineWidth = 20
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
        
        context.restoreGState()
        
        
        
        
        //// Group 3
        //// Group 4
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 48, y: 45))
        bezier2Path.addLine(to: CGPoint(x: 110, y: 122))
        color.setStroke()
        bezier2Path.lineWidth = 20
        bezier2Path.lineCapStyle = .round
        bezier2Path.stroke()
        
        
        
        
        //// Bezier 4 Drawing
        context.saveGState()
        context.translateBy(x: 110, y: 122)
        context.scaleBy(x: -1, y: 1)
        
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 0, y: 0))
        bezier4Path.addLine(to: CGPoint(x: 62, y: 77))
        color.setStroke()
        bezier4Path.lineWidth = 20
        bezier4Path.lineCapStyle = .round
        bezier4Path.stroke()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(NextLevelDrawResizingBehavior)
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

