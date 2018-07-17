//
//  Letter.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 06/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit


 // @IBDesignable
class Letter: UIView {
    
    @IBInspectable var letter: String = "M" // lettre en majuscule !
    
    // pour la lettre M
    @IBInspectable var scale: CGFloat = 0.9
    @IBInspectable var width: CGFloat = 2
    @IBInspectable var color: UIColor = UIColor(red: 0.720, green: 0.469, blue: 0.000, alpha: 1.000)
    
    // pour la lettre E
    @IBInspectable var longueurRelativePetiteBarre: CGFloat = 0.6
    @IBInspectable var decalage: CGFloat = 10
    
    // Pour la lettre N
    @IBInspectable var pos1: CGFloat = 20
    
    override func draw(_ rect: CGRect) {
        
        if letter == "M" {
            M.drawCanvas1(frame: rect, resizing: .aspectFill, scale: scale, width: width, color: color)
        } else if letter == "E" {
            E.drawCanvas1(frame: rect, resizing: .aspectFill, longueurRelativePetiteBarre: longueurRelativePetiteBarre, width: width, decalage: decalage, color: color)
        } else if letter == "N" {
            N.drawCanvas1(frame: rect, resizing: .aspectFill, decalage: decalage, width: width, color: color, pos1: pos1)
        }
        else if letter == "U" {
            U.drawCanvas2(frame: rect, resizing: .aspectFill, width: width, color: color)
        }
        else {
            return
        }
        
    }
    
    
}



public class U : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas2(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200), resizing: ResizingBehavior = .aspectFit, width: CGFloat = 3, color:UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 200, height: 200), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 200, y: resizedFrame.height / 200)
        
        
        //// Color Declarations
        
        //// Group
        //// Oval Drawing
        let ovalRect = CGRect(x: 5.5, y: 47.5, width: 150, height: 150)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width / 2, startAngle: 0 * CGFloat.pi/180, endAngle: -180 * CGFloat.pi/180, clockwise: true)
        
        color.setStroke()
        ovalPath.lineWidth = width
        ovalPath.stroke()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 5.5, y: 122.5))
        bezierPath.addLine(to: CGPoint(x: 5.5, y: -0.5))
        color.setStroke()
        bezierPath.lineWidth = width
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 155.5, y: 122.5))
        bezier2Path.addLine(to: CGPoint(x: 155.5, y: -0.5))
        color.setStroke()
        bezier2Path.lineWidth = width
        bezier2Path.stroke()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(UResizingBehavior)
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

public class N : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 102, height: 102), resizing: ResizingBehavior = .aspectFit, decalage: CGFloat = 9, width: CGFloat = 3, color: UIColor = .black, pos1: CGFloat = 27) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 102, height: 102), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 102, y: resizedFrame.height / 102)
        
        
        //// Color Declarations
        let color = color
        
        //// Variable Declarations
        let expression: CGFloat = pos1 - decalage
        
        //// Bezier Drawing
        context.saveGState()
        context.translateBy(x: 35, y: 0)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 65, y: -0))
        bezierPath.addLine(to: CGPoint(x: 65, y: 100))
        bezierPath.addLine(to: CGPoint(x: (pos1 - 35), y: -0))
        color.setStroke()
        bezierPath.lineWidth = width
        bezierPath.stroke()
        
        context.restoreGState()
        
        
        //// Bezier 2 Drawing
        context.saveGState()
        context.translateBy(x: expression, y: 0)
        
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 0, y: 100))
        bezier2Path.addLine(to: CGPoint(x: 0, y: 0))
        color.setStroke()
        bezier2Path.lineWidth = width
        bezier2Path.stroke()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(NResizingBehavior)
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


public class M : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120), resizing: ResizingBehavior = .aspectFit, scale: CGFloat = 0.8, width: CGFloat = 2, color: UIColor = .black) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 120, height: 120), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 120, y: resizedFrame.height / 120)
        
        
        //// Color Declarations
        let color = color
        
        //// Bezier Drawing
        context.saveGState()
        context.scaleBy(x: scale, y: 1)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: -0))
        bezierPath.addLine(to: CGPoint(x: 50, y: 54.5))
        bezierPath.addLine(to: CGPoint(x: 100, y: -0))
        bezierPath.addLine(to: CGPoint(x: 100.5, y: 119.5))
        color.setStroke()
        bezierPath.lineWidth = width
        bezierPath.stroke()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(MResizingBehavior)
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


public class E : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), resizing: ResizingBehavior = .aspectFit, longueurRelativePetiteBarre: CGFloat = 0.6,width: CGFloat = 1.0, decalage: CGFloat = 10, color: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 100, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 100, y: resizedFrame.height / 100)
        
        
        //// Color Declarations
        let color = color
        
        //// Variable Declarations
        let positionPetiteBarre: CGFloat = 30 + decalage
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 30, y: 2.0))
        bezierPath.addLine(to: CGPoint(x: 106, y: 2.0))
        color.setStroke()
        bezierPath.lineWidth = width
        bezierPath.stroke()
        
        
        //// Bezier 3 Drawing
        context.saveGState()
        context.translateBy(x: positionPetiteBarre, y: 50)
        context.scaleBy(x: longueurRelativePetiteBarre, y: 1)
        
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 0, y: 0))
        bezier3Path.addLine(to: CGPoint(x: 60, y: 0.5))
        color.setStroke()
        bezier3Path.lineWidth = width
        bezier3Path.stroke()
        
        context.restoreGState()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 30, y: 98))
        bezier2Path.addLine(to: CGPoint(x: 100, y: 98))
        color.setStroke()
        bezier2Path.lineWidth = width
        bezier2Path.stroke()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(EResizingBehavior)
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

