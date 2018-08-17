//
//  LockView.swift
//  Demineur
//
//  Created by Marin on 17/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class LockView: UIView {

    override func draw(_ rect: CGRect) {
        // Drawing code
        LockDraw.drawLockCanvas(frame: rect, resizing: .aspectFill)
    }

}

public class LockDraw : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawLockCanvas(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 100, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 100, y: resizedFrame.height / 100)
        
        
        //// Color Declarations
        let lockColor = UIColor(red: 0.698, green: 0.698, blue: 0.698, alpha: 1.000)
        let holeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.000)
        
        //// Gray
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 20, y: 40.5, width: 60, height: 45), cornerRadius: 10)
        lockColor.setFill()
        rectanglePath.fill()
        
        
        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 30, y: 27, width: 6, height: 20))
        lockColor.setFill()
        rectangle2Path.fill()
        
        
        //// Rectangle 3 Drawing
        context.saveGState()
        context.translateBy(x: 70, y: 27)
        
        let rectangle3Path = UIBezierPath(rect: CGRect(x: -6, y: 0, width: 6, height: 20))
        lockColor.setFill()
        rectangle3Path.fill()
        
        context.restoreGState()
        
        
        //// Oval Drawing
        let ovalRect = CGRect(x: 33, y: 13, width: 34, height: 30)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint.zero, radius: ovalRect.width / 2, startAngle: -180 * CGFloat.pi/180, endAngle: 0 * CGFloat.pi/180, clockwise: true)
        
        var ovalTransform = CGAffineTransform(translationX: ovalRect.midX, y: ovalRect.midY)
        ovalTransform = ovalTransform.scaledBy(x: 1, y: ovalRect.height / ovalRect.width)
        ovalPath.apply(ovalTransform)
        
        lockColor.setStroke()
        ovalPath.lineWidth = 6
        ovalPath.stroke()
        
        
        
        
        //// Hole
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 45, y: 54, width: 10, height: 10))
        holeColor.setFill()
        oval2Path.fill()
        
        
        //// Rectangle 4 Drawing
        let rectangle4Path = UIBezierPath(rect: CGRect(x: 48, y: 59, width: 4, height: 13))
        holeColor.setFill()
        rectangle4Path.fill()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(LockDrawResizingBehavior)
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
