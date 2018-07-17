//
//  HautParleur.swift
//  Demineur
//
//  Created by Arthur BRICQ on 16/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
class HautParleur: UIView {

    @IBInspectable var color: UIColor = UIColor.lightGray

    override func draw(_ rect: CGRect) {
        HautParlerDraw.drawCanvas1(frame: rect, resizing: .aspectFill, color: color)
    }    

}


public class HautParlerDraw : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 90, height: 80), resizing: ResizingBehavior = .aspectFit, color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 90, height: 80), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 90, y: resizedFrame.height / 80)
        
     
        //// Group
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 34, y: 25.35))
        bezier2Path.addCurve(to: CGPoint(x: 39, y: 40), controlPoint1: CGPoint(x: 37.85, y: 23.12), controlPoint2: CGPoint(x: 39, y: 31.78))
        bezier2Path.addCurve(to: CGPoint(x: 34, y: 55.12), controlPoint1: CGPoint(x: 39, y: 48.22), controlPoint2: CGPoint(x: 37.85, y: 57.35))
        bezier2Path.addLine(to: CGPoint(x: 34, y: 40.23))
        bezier2Path.addLine(to: CGPoint(x: 34, y: 25.35))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: 34, y: 25.35))
        bezier2Path.addLine(to: CGPoint(x: 13.65, y: 36.51))
        bezier2Path.addCurve(to: CGPoint(x: 12, y: 40.23), controlPoint1: CGPoint(x: 13.65, y: 36.51), controlPoint2: CGPoint(x: 12, y: 37.26))
        bezier2Path.addCurve(to: CGPoint(x: 13.65, y: 43.96), controlPoint1: CGPoint(x: 12, y: 43.21), controlPoint2: CGPoint(x: 13.65, y: 43.96))
        bezier2Path.addLine(to: CGPoint(x: 34, y: 55.12))
        bezier2Path.addLine(to: CGPoint(x: 34, y: 25.35))
        bezier2Path.close()
        color.setFill() ; color.setStroke()
        bezier2Path.fill()
        
        
        //// Oval Drawing
        let ovalRect = CGRect(x: 20, y: 4, width: 59, height: 72)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint.zero, radius: ovalRect.width / 2, startAngle: -50 * CGFloat.pi/180, endAngle: 50 * CGFloat.pi/180, clockwise: true)
        
        var ovalTransform = CGAffineTransform(translationX: ovalRect.midX, y: ovalRect.midY)
        ovalTransform = ovalTransform.scaledBy(x: 1, y: ovalRect.height / ovalRect.width)
        ovalPath.apply(ovalTransform)
        
        color.setStroke()
        ovalPath.lineWidth = 4.5
        ovalPath.lineCapStyle = .round
        ovalPath.stroke()
        
        
        //// Oval 2 Drawing
        let oval2Rect = CGRect(x: 15, y: 11, width: 52, height: 59)
        let oval2Path = UIBezierPath()
        oval2Path.addArc(withCenter: CGPoint.zero, radius: oval2Rect.width / 2, startAngle: -50 * CGFloat.pi/180, endAngle: 50 * CGFloat.pi/180, clockwise: true)
        
        var oval2Transform = CGAffineTransform(translationX: oval2Rect.midX, y: oval2Rect.midY)
        oval2Transform = oval2Transform.scaledBy(x: 1, y: oval2Rect.height / oval2Rect.width)
        oval2Path.apply(oval2Transform)
        
        color.setStroke()
        oval2Path.lineWidth = 4.5
        oval2Path.lineCapStyle = .round
        oval2Path.stroke()
        
        
        //// Oval 3 Drawing
        let oval3Rect = CGRect(x: 9, y: 19, width: 46, height: 43)
        let oval3Path = UIBezierPath()
        oval3Path.addArc(withCenter: CGPoint.zero, radius: oval3Rect.width / 2, startAngle: -50 * CGFloat.pi/180, endAngle: 50 * CGFloat.pi/180, clockwise: true)
        
        var oval3Transform = CGAffineTransform(translationX: oval3Rect.midX, y: oval3Rect.midY)
        oval3Transform = oval3Transform.scaledBy(x: 1, y: oval3Rect.height / oval3Rect.width)
        oval3Path.apply(oval3Transform)
        
        color.setStroke()
        oval3Path.lineWidth = 4.5
        oval3Path.lineCapStyle = .round
        oval3Path.stroke()
        
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 12, y: 34, width: 19, height: 13), cornerRadius: 2)
        color.setFill()
        rectanglePath.fill()
        color.setStroke()
        rectanglePath.lineWidth = 4.5
        rectanglePath.stroke()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(HautParlerDrawResizingBehavior)
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
