//
//  StyleKitName.swift
//  DemineIt
//
//  Created by Marin Bricq on 09/07/2018.
//  Copyright © 2018 Bricq.Bros. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class Rayure: NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawRayure(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), resizing: ResizingBehavior = .aspectFit, color: UIColor = UIColor(red: 0.800, green: 0.320, blue: 0.320, alpha: 1.000), color2: UIColor = UIColor(red: 0.652, green: 0.800, blue: 0.320, alpha: 1.000)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 100, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 100, y: resizedFrame.height / 100)
        
        
        //// Group
        context.saveGState()
        context.translateBy(x: 64, y: -68)
        context.rotate(by: 45 * CGFloat.pi/180)
        
        
        
        //// Rectangle 3 Drawing
        let rectangle3Path = UIBezierPath(rect: CGRect(x: 0, y: 20, width: 150, height: 10))
        color.setFill()
        rectangle3Path.fill()
        
        
        //// Rectangle 4 Drawing
        let rectangle4Path = UIBezierPath(rect: CGRect(x: 0, y: 30, width: 150, height: 10))
        color2.setFill()
        rectangle4Path.fill()
        
        
        //// Rectangle 5 Drawing
        let rectangle5Path = UIBezierPath(rect: CGRect(x: 0, y: 40, width: 150, height: 10))
        color.setFill()
        rectangle5Path.fill()
        
        
        //// Rectangle 6 Drawing
        let rectangle6Path = UIBezierPath(rect: CGRect(x: 0, y: 50, width: 150, height: 10))
        color2.setFill()
        rectangle6Path.fill()
        
        
        //// Rectangle 7 Drawing
        let rectangle7Path = UIBezierPath(rect: CGRect(x: 0, y: 60, width: 150, height: 10))
        color.setFill()
        rectangle7Path.fill()
        
        
        //// Rectangle 8 Drawing
        let rectangle8Path = UIBezierPath(rect: CGRect(x: 0, y: 70, width: 150, height: 10))
        color2.setFill()
        rectangle8Path.fill()
        
        
        //// Rectangle 9 Drawing
        let rectangle9Path = UIBezierPath(rect: CGRect(x: 0, y: 80, width: 150, height: 10))
        color.setFill()
        rectangle9Path.fill()
        
        
        //// Rectangle 10 Drawing
        let rectangle10Path = UIBezierPath(rect: CGRect(x: 0, y: 90, width: 150, height: 10))
        color2.setFill()
        rectangle10Path.fill()
        
        
        //// Rectangle 11 Drawing
        let rectangle11Path = UIBezierPath(rect: CGRect(x: 0, y: 100, width: 150, height: 10))
        color.setFill()
        rectangle11Path.fill()
        
        
        //// Rectangle 12 Drawing
        let rectangle12Path = UIBezierPath(rect: CGRect(x: 0, y: 110, width: 150, height: 10))
        color2.setFill()
        rectangle12Path.fill()
        
        
        //// Rectangle 13 Drawing
        let rectangle13Path = UIBezierPath(rect: CGRect(x: 0, y: 120, width: 150, height: 10))
        color.setFill()
        rectangle13Path.fill()
        
        
        //// Rectangle 14 Drawing
        let rectangle14Path = UIBezierPath(rect: CGRect(x: 0, y: 130, width: 150, height: 10))
        color2.setFill()
        rectangle14Path.fill()
        
        
        //// Rectangle 15 Drawing
        let rectangle15Path = UIBezierPath(rect: CGRect(x: 0, y: 140, width: 150, height: 10))
        color.setFill()
        rectangle15Path.fill()
        
        
        //// Rectangle 16 Drawing
        let rectangle16Path = UIBezierPath(rect: CGRect(x: 0, y: 150, width: 150, height: 10))
        color2.setFill()
        rectangle16Path.fill()
        
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(StyleKitNameResizingBehavior)
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
