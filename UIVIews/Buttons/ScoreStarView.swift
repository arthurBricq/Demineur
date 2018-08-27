//
//  ScoreStarView.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation

import UIKit

class ScoreStarView: UIButton {
    
    @IBInspectable var color: UIColor = UIColor.lightGray
    
    override func draw(_ rect: CGRect) {
        StarDrawing.drawCanvas1(frame: rect, resizing: .aspectFill, color: color)
    }
    
}

public class StarDrawing : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 240, height: 240), resizing: ResizingBehavior = .aspectFit, color: UIColor = UIColor(red: 0.865, green: 0.860, blue: 0.860, alpha: 1.000)) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 240, height: 240), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 240, y: resizedFrame.height / 240)
        
        
       
        //// Star Drawing
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 121, y: 45))
        starPath.addLine(to: CGPoint(x: 142.46, y: 100.46))
        starPath.addLine(to: CGPoint(x: 201.84, y: 103.73))
        starPath.addLine(to: CGPoint(x: 155.73, y: 141.28))
        starPath.addLine(to: CGPoint(x: 170.96, y: 198.77))
        starPath.addLine(to: CGPoint(x: 121, y: 166.51))
        starPath.addLine(to: CGPoint(x: 71.04, y: 198.77))
        starPath.addLine(to: CGPoint(x: 86.27, y: 141.28))
        starPath.addLine(to: CGPoint(x: 40.16, y: 103.73))
        starPath.addLine(to: CGPoint(x: 99.54, y: 100.46))
        starPath.close()
        color.setFill()
        starPath.fill()
        
        context.restoreGState()
        
    }

    
    
    
    @objc(StarDrawingResizingBehavior)
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
