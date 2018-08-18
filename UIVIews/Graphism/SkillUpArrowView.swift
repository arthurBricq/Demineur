//
//  SkillUpArrowView.swift
//  Demineur
//
//  Created by Marin on 18/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class SkillUpArrowView: UIView {
    
    override func draw(_ rect: CGRect) {
        SkillUpArrow.drawSkillUpArrowCanvas(frame: rect, resizing: .aspectFill)
    }

}

public class SkillUpArrow : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawSkillUpArrowCanvas(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 50, height: 70), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 50, height: 70), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 50, y: resizedFrame.height / 70)
        
        
        //// Color Declarations
        let arrowColor = colorForRGB(r: 76, g: 175, b: 81)
        
        //// Arrow
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 18, y: 30, width: 13.5, height: 35.5))
        arrowColor.setFill()
        rectanglePath.fill()
        arrowColor.setStroke()
        rectanglePath.lineWidth = 1
        rectanglePath.lineJoinStyle = .round
        rectanglePath.stroke()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 5, y: 30.5))
        bezierPath.addLine(to: CGPoint(x: 45, y: 30.5))
        bezierPath.addLine(to: CGPoint(x: 25, y: 5.5))
        bezierPath.addLine(to: CGPoint(x: 5, y: 30.5))
        bezierPath.close()
        arrowColor.setFill()
        bezierPath.fill()
        arrowColor.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.lineJoinStyle = .round
        bezierPath.stroke()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(SkillUpArrowResizingBehavior)
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
