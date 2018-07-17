//
//  PauseButton.swift
//  DemineIt
//
//  Created by Marin on 23/06/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
class PauseButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawPauseButton(frame: rect, resizing: .aspectFill)
    }
    
    // Drawing methods
    func drawPauseButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 100, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 100, y: resizedFrame.height / 100)
        
        
        //// Color Declarations
        let fillColor = UIColor(red: 0.209, green: 0.216, blue: 0.243, alpha: 1.000)
        
        //// PauseButton Drawing
        let pauseButtonPath = UIBezierPath()
        pauseButtonPath.move(to: CGPoint(x: 27.23, y: 13))
        pauseButtonPath.addLine(to: CGPoint(x: 30.77, y: 13))
        pauseButtonPath.addCurve(to: CGPoint(x: 37.64, y: 13.52), controlPoint1: CGPoint(x: 34.29, y: 13), controlPoint2: CGPoint(x: 36.05, y: 13))
        pauseButtonPath.addLine(to: CGPoint(x: 37.95, y: 13.6))
        pauseButtonPath.addCurve(to: CGPoint(x: 42.4, y: 18.05), controlPoint1: CGPoint(x: 40.02, y: 14.35), controlPoint2: CGPoint(x: 41.65, y: 15.98))
        pauseButtonPath.addCurve(to: CGPoint(x: 43, y: 25.23), controlPoint1: CGPoint(x: 43, y: 19.95), controlPoint2: CGPoint(x: 43, y: 21.71))
        pauseButtonPath.addLine(to: CGPoint(x: 43, y: 75.77))
        pauseButtonPath.addCurve(to: CGPoint(x: 42.48, y: 82.64), controlPoint1: CGPoint(x: 43, y: 79.29), controlPoint2: CGPoint(x: 43, y: 81.05))
        pauseButtonPath.addLine(to: CGPoint(x: 42.4, y: 82.95))
        pauseButtonPath.addCurve(to: CGPoint(x: 37.95, y: 87.4), controlPoint1: CGPoint(x: 41.65, y: 85.02), controlPoint2: CGPoint(x: 40.02, y: 86.65))
        pauseButtonPath.addCurve(to: CGPoint(x: 30.77, y: 88), controlPoint1: CGPoint(x: 36.05, y: 88), controlPoint2: CGPoint(x: 34.29, y: 88))
        pauseButtonPath.addLine(to: CGPoint(x: 27.23, y: 88))
        pauseButtonPath.addCurve(to: CGPoint(x: 20.36, y: 87.48), controlPoint1: CGPoint(x: 23.71, y: 88), controlPoint2: CGPoint(x: 21.95, y: 88))
        pauseButtonPath.addLine(to: CGPoint(x: 20.05, y: 87.4))
        pauseButtonPath.addCurve(to: CGPoint(x: 15.6, y: 82.95), controlPoint1: CGPoint(x: 17.98, y: 86.65), controlPoint2: CGPoint(x: 16.35, y: 85.02))
        pauseButtonPath.addCurve(to: CGPoint(x: 15, y: 75.77), controlPoint1: CGPoint(x: 15, y: 81.05), controlPoint2: CGPoint(x: 15, y: 79.29))
        pauseButtonPath.addLine(to: CGPoint(x: 15, y: 25.23))
        pauseButtonPath.addCurve(to: CGPoint(x: 15.52, y: 18.36), controlPoint1: CGPoint(x: 15, y: 21.71), controlPoint2: CGPoint(x: 15, y: 19.95))
        pauseButtonPath.addLine(to: CGPoint(x: 15.6, y: 18.05))
        pauseButtonPath.addCurve(to: CGPoint(x: 20.05, y: 13.6), controlPoint1: CGPoint(x: 16.35, y: 15.98), controlPoint2: CGPoint(x: 17.98, y: 14.35))
        pauseButtonPath.addCurve(to: CGPoint(x: 27.23, y: 13), controlPoint1: CGPoint(x: 21.95, y: 13), controlPoint2: CGPoint(x: 23.71, y: 13))
        pauseButtonPath.close()
        pauseButtonPath.move(to: CGPoint(x: 69.23, y: 13))
        pauseButtonPath.addLine(to: CGPoint(x: 72.77, y: 13))
        pauseButtonPath.addCurve(to: CGPoint(x: 79.64, y: 13.52), controlPoint1: CGPoint(x: 76.29, y: 13), controlPoint2: CGPoint(x: 78.05, y: 13))
        pauseButtonPath.addLine(to: CGPoint(x: 79.95, y: 13.6))
        pauseButtonPath.addCurve(to: CGPoint(x: 84.4, y: 18.05), controlPoint1: CGPoint(x: 82.02, y: 14.35), controlPoint2: CGPoint(x: 83.65, y: 15.98))
        pauseButtonPath.addCurve(to: CGPoint(x: 85, y: 25.23), controlPoint1: CGPoint(x: 85, y: 19.95), controlPoint2: CGPoint(x: 85, y: 21.71))
        pauseButtonPath.addLine(to: CGPoint(x: 85, y: 75.77))
        pauseButtonPath.addCurve(to: CGPoint(x: 84.48, y: 82.64), controlPoint1: CGPoint(x: 85, y: 79.29), controlPoint2: CGPoint(x: 85, y: 81.05))
        pauseButtonPath.addLine(to: CGPoint(x: 84.4, y: 82.95))
        pauseButtonPath.addCurve(to: CGPoint(x: 79.95, y: 87.4), controlPoint1: CGPoint(x: 83.65, y: 85.02), controlPoint2: CGPoint(x: 82.02, y: 86.65))
        pauseButtonPath.addCurve(to: CGPoint(x: 72.77, y: 88), controlPoint1: CGPoint(x: 78.05, y: 88), controlPoint2: CGPoint(x: 76.29, y: 88))
        pauseButtonPath.addLine(to: CGPoint(x: 69.23, y: 88))
        pauseButtonPath.addCurve(to: CGPoint(x: 62.36, y: 87.48), controlPoint1: CGPoint(x: 65.71, y: 88), controlPoint2: CGPoint(x: 63.95, y: 88))
        pauseButtonPath.addLine(to: CGPoint(x: 62.05, y: 87.4))
        pauseButtonPath.addCurve(to: CGPoint(x: 57.6, y: 82.95), controlPoint1: CGPoint(x: 59.98, y: 86.65), controlPoint2: CGPoint(x: 58.35, y: 85.02))
        pauseButtonPath.addCurve(to: CGPoint(x: 57, y: 75.77), controlPoint1: CGPoint(x: 57, y: 81.05), controlPoint2: CGPoint(x: 57, y: 79.29))
        pauseButtonPath.addLine(to: CGPoint(x: 57, y: 25.23))
        pauseButtonPath.addCurve(to: CGPoint(x: 57.52, y: 18.36), controlPoint1: CGPoint(x: 57, y: 21.71), controlPoint2: CGPoint(x: 57, y: 19.95))
        pauseButtonPath.addLine(to: CGPoint(x: 57.6, y: 18.05))
        pauseButtonPath.addCurve(to: CGPoint(x: 62.05, y: 13.6), controlPoint1: CGPoint(x: 58.35, y: 15.98), controlPoint2: CGPoint(x: 59.98, y: 14.35))
        pauseButtonPath.addCurve(to: CGPoint(x: 69.23, y: 13), controlPoint1: CGPoint(x: 63.95, y: 13), controlPoint2: CGPoint(x: 65.71, y: 13))
        pauseButtonPath.close()
        fillColor.setFill()
        pauseButtonPath.fill()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(PauseResizingBehavior)
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
