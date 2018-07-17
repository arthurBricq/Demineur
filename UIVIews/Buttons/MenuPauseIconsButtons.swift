//
//  MenuPauseIconsButtons.swift
//  Demineur
//
//  Created by Arthur BRICQ on 16/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
class MenuPauseIconsButtons: UIButton {
    
    @IBInspectable var type: Int = 0
    @IBInspectable var width: CGFloat = 4.0
    @IBInspectable var color: UIColor = UIColor.lightGray
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if type == 0 {
            MenuPauseDrawings.drawCanvas1(frame: rect, resizing: .aspectFill, width: width, color: color)
        } else if type == 1 {
            MenuPauseDrawings.drawCanvas2(frame: rect, resizing: .aspectFill, width: width, color: color)
        } else {
            MenuPauseDrawings.drawCanvas3(frame: rect, resizing: .aspectFill, color: color)
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
                
    }
    
}








public class MenuPauseDrawings : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120), resizing: ResizingBehavior = .aspectFit, width: CGFloat = 5, color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 120, height: 120), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 120, y: resizedFrame.height / 120)
        
        
        //// Color Declarations
        let color3 = color
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 30.4, y: 49.54, width: 60, height: 47.64))
        color3.setStroke()
        rectanglePath.lineWidth = width
        rectanglePath.stroke()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 24.2, y: 49.61))
        bezierPath.addLine(to: CGPoint(x: 61.91, y: 15.43))
        bezierPath.addLine(to: CGPoint(x: 97.06, y: 49.48))
        color3.setFill()
        bezierPath.fill()
        color3.setStroke()
        bezierPath.lineWidth = width
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 23.46, y: 49.56))
        bezier2Path.addLine(to: CGPoint(x: 97.46, y: 49.56))
        color3.setStroke()
        bezier2Path.lineWidth = width
        bezier2Path.stroke()
        
        
        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 52.74, y: 72.87, width: 16, height: 23))
        color3.setFill()
        rectangle2Path.fill()
        
        context.restoreGState()
        
    }
    
    @objc dynamic public class func drawCanvas2(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120), resizing: ResizingBehavior = .aspectFit, width: CGFloat = 5, color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 120, height: 120), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 120, y: resizedFrame.height / 120)
        
        
        //// Color Declarations
        let color3 = color
        
        //// Oval Drawing
        let ovalRect = CGRect(x: 25.97, y: 23.79, width: 70, height: 70)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width / 2, startAngle: -131 * CGFloat.pi/180, endAngle: 132 * CGFloat.pi/180, clockwise: true)
        
        color3.setStroke()
        ovalPath.lineWidth = width
        ovalPath.lineCapStyle = .round
        ovalPath.stroke()
        
        
        //// Bezier Drawing
        context.saveGState()
        context.translateBy(x: 24.27, y: 49.08)
        context.rotate(by: -108.72 * CGFloat.pi/180)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: 24.84))
        bezierPath.addLine(to: CGPoint(x: 21.01, y: 12.26))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        color3.setFill()
        bezierPath.fill()
        color3.setStroke()
        bezierPath.lineWidth = width
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    @objc dynamic public class func drawCanvas3(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120), resizing: ResizingBehavior = .aspectFit, color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 120, height: 120), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 120, y: resizedFrame.height / 120)
        
        
        //// Color Declarations
        let color3 = color
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 32.22, y: 20.74))
        bezierPath.addLine(to: CGPoint(x: 32.22, y: 97.25))
        bezierPath.addLine(to: CGPoint(x: 93.09, y: 58.51))
        bezierPath.addLine(to: CGPoint(x: 32.22, y: 20.74))
        color3.setFill()
        bezierPath.fill()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(MenuPauseDrawingsResizingBehavior)
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
