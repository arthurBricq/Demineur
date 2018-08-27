//
//  HeaderInfinite.swift
//  Demineur
//
//  Created by Marin on 12/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class HeaderInfinite: UIView {

    var color1: UIColor = UIColor(red: 0.678, green: 0.359, blue: 0.020, alpha: 1.000)
    var color2: UIColor = colorForRGB(r: 66, g: 66, b: 66)
    
    override func draw(_ rect: CGRect) {
        InfiniHeader.drawCanvas1(frame: rect, resizing: .aspectFill, color: color1, color2: color2)
    }
 

}

public class InfiniHeader : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 163, height: 57), resizing: ResizingBehavior = .aspectFit, color: UIColor = UIColor(red: 0.678, green: 0.359, blue: 0.020, alpha: 1.000), color2: UIColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 163, height: 57), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 163, y: resizedFrame.height / 57)
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 19.15, y: 10.9))
        bezier2Path.addLine(to: CGPoint(x: 19.29, y: 49.04))
        color.setStroke()
        bezier2Path.lineWidth = 1
        bezier2Path.stroke()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 22.57, y: 10.9))
        bezier3Path.addLine(to: CGPoint(x: 49.72, y: 46.95))
        bezier3Path.addLine(to: CGPoint(x: 49.72, y: 10.9))
        color.setStroke()
        bezier3Path.lineWidth = 1
        bezier3Path.stroke()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 60.22, y: 10.38))
        bezier4Path.addLine(to: CGPoint(x: 60.22, y: 48.38))
        color.setStroke()
        bezier4Path.lineWidth = 1
        bezier4Path.stroke()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 63.25, y: 11.02))
        bezier5Path.addLine(to: CGPoint(x: 90.5, y: 10.5))
        color.setStroke()
        bezier5Path.lineWidth = 1
        bezier5Path.stroke()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 63.87, y: 28.87))
        bezier6Path.addLine(to: CGPoint(x: 75.5, y: 28.5))
        color.setStroke()
        bezier6Path.lineWidth = 1
        bezier6Path.stroke()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 99.93, y: 10.18))
        bezier7Path.addLine(to: CGPoint(x: 99.93, y: 48.18))
        color.setStroke()
        bezier7Path.lineWidth = 1
        bezier7Path.stroke()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 111.26, y: 9.8))
        bezier8Path.addLine(to: CGPoint(x: 111.39, y: 47.84))
        color.setStroke()
        bezier8Path.lineWidth = 1
        bezier8Path.stroke()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: 152.4, y: 9.45))
        bezier10Path.addLine(to: CGPoint(x: 152.4, y: 47.45))
        color.setStroke()
        bezier10Path.lineWidth = 1
        bezier10Path.stroke()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 114.57, y: 9.9))
        bezierPath.addLine(to: CGPoint(x: 141.72, y: 45.95))
        bezierPath.addLine(to: CGPoint(x: 141.72, y: 9.9))
        color.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(InfiniHeaderResizingBehavior)
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
