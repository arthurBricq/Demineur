//
//  BombViewDisplay.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 08/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class BombViewDisplay: UIView {
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        Bombe.drawCanvas1(frame: rect, resizing: .aspectFill)
    }
    
    
}


public class Bombe : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 240, height: 240), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 240, height: 240), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 240, y: resizedFrame.height / 240)
        
        
        //// Color Declarations
        let color3 = UIColor(red: 0.194, green: 0.134, blue: 0.000, alpha: 1.000)
        let color4 = UIColor(red: 0.171, green: 0.107, blue: 0.000, alpha: 0.899)
        
        //// Gradient Declarations
        let gradient = CGGradient(colorsSpace: nil, colors: [UIColor.gray.cgColor, UIColor.gray.blended(withFraction: 0.5, of: UIColor.lightGray).cgColor, UIColor.lightGray.cgColor] as CFArray, locations: [0.13, 0.48, 0.75])!
        
        //// Group
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 116.5, y: 59.5))
        bezier2Path.addCurve(to: CGPoint(x: 118.5, y: 42.5), controlPoint1: CGPoint(x: 116.5, y: 59.5), controlPoint2: CGPoint(x: 114.5, y: 45))
        bezier2Path.addCurve(to: CGPoint(x: 129.5, y: 29.5), controlPoint1: CGPoint(x: 117.5, y: 39.5), controlPoint2: CGPoint(x: 126, y: 29.5))
        bezier2Path.addCurve(to: CGPoint(x: 143.5, y: 23.5), controlPoint1: CGPoint(x: 130.5, y: 26.5), controlPoint2: CGPoint(x: 140.5, y: 22.5))
        bezier2Path.addCurve(to: CGPoint(x: 161.5, y: 21.5), controlPoint1: CGPoint(x: 145.5, y: 20), controlPoint2: CGPoint(x: 158.5, y: 19.5))
        bezier2Path.addCurve(to: CGPoint(x: 178.5, y: 23.5), controlPoint1: CGPoint(x: 164.5, y: 18.5), controlPoint2: CGPoint(x: 177.5, y: 21.5))
        bezier2Path.addCurve(to: CGPoint(x: 190.5, y: 29.5), controlPoint1: CGPoint(x: 181.5, y: 22), controlPoint2: CGPoint(x: 191.5, y: 26.5))
        bezier2Path.addCurve(to: CGPoint(x: 198.5, y: 35.5), controlPoint1: CGPoint(x: 193.5, y: 29.5), controlPoint2: CGPoint(x: 198.5, y: 32.5))
        bezier2Path.addCurve(to: CGPoint(x: 201.5, y: 46.5), controlPoint1: CGPoint(x: 201, y: 35.5), controlPoint2: CGPoint(x: 202, y: 43.5))
        bezier2Path.addCurve(to: CGPoint(x: 193.5, y: 48.5), controlPoint1: CGPoint(x: 199.5, y: 48.5), controlPoint2: CGPoint(x: 193.5, y: 48.5))
        bezier2Path.addCurve(to: CGPoint(x: 187.5, y: 40.5), controlPoint1: CGPoint(x: 193.5, y: 48.5), controlPoint2: CGPoint(x: 188.5, y: 43.5))
        bezier2Path.addCurve(to: CGPoint(x: 179.5, y: 36.5), controlPoint1: CGPoint(x: 185, y: 40), controlPoint2: CGPoint(x: 179.5, y: 36.5))
        bezier2Path.addCurve(to: CGPoint(x: 168.5, y: 33.5), controlPoint1: CGPoint(x: 179.5, y: 36.5), controlPoint2: CGPoint(x: 172.5, y: 35.5))
        bezier2Path.addCurve(to: CGPoint(x: 156.5, y: 33.5), controlPoint1: CGPoint(x: 165, y: 34), controlPoint2: CGPoint(x: 161.5, y: 34.5))
        bezier2Path.addCurve(to: CGPoint(x: 141.5, y: 37.5), controlPoint1: CGPoint(x: 151, y: 36), controlPoint2: CGPoint(x: 147.5, y: 36.5))
        bezier2Path.addCurve(to: CGPoint(x: 131.5, y: 46.5), controlPoint1: CGPoint(x: 138.5, y: 42), controlPoint2: CGPoint(x: 134.5, y: 44.5))
        bezier2Path.addCurve(to: CGPoint(x: 129.5, y: 59.5), controlPoint1: CGPoint(x: 132, y: 52.5), controlPoint2: CGPoint(x: 129.5, y: 59.5))
        color4.setFill()
        bezier2Path.fill()
        color3.setStroke()
        bezier2Path.lineWidth = 1
        bezier2Path.stroke()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 118.5, y: 42.5))
        bezier4Path.addLine(to: CGPoint(x: 141.5, y: 37.5))
        color3.setStroke()
        bezier4Path.lineWidth = 1
        bezier4Path.stroke()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 116.5, y: 59.5))
        bezier3Path.addLine(to: CGPoint(x: 131.5, y: 46.5))
        color3.setStroke()
        bezier3Path.lineWidth = 1
        bezier3Path.stroke()
        
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 45, y: 90, width: 150, height: 150))
        UIColor.gray.setFill()
        ovalPath.fill()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 102, y: 95))
        bezierPath.addLine(to: CGPoint(x: 102, y: 69))
        bezierPath.addCurve(to: CGPoint(x: 122, y: 58), controlPoint1: CGPoint(x: 102, y: 69), controlPoint2: CGPoint(x: 103, y: 58))
        bezierPath.addCurve(to: CGPoint(x: 144, y: 69), controlPoint1: CGPoint(x: 141, y: 58), controlPoint2: CGPoint(x: 144, y: 69))
        bezierPath.addLine(to: CGPoint(x: 144, y: 95))
        UIColor.gray.setFill()
        bezierPath.fill()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 129.5, y: 29.5))
        bezier5Path.addLine(to: CGPoint(x: 156.5, y: 33.5))
        color3.setStroke()
        bezier5Path.lineWidth = 1
        bezier5Path.stroke()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 143.5, y: 23.5))
        bezier6Path.addLine(to: CGPoint(x: 168.5, y: 33.5))
        color3.setStroke()
        bezier6Path.lineWidth = 1
        bezier6Path.stroke()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 161.5, y: 21.5))
        bezier7Path.addLine(to: CGPoint(x: 179.5, y: 36.5))
        color3.setStroke()
        bezier7Path.lineWidth = 1
        bezier7Path.stroke()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 178.5, y: 23.5))
        bezier8Path.addLine(to: CGPoint(x: 187.5, y: 40.5))
        color3.setStroke()
        bezier8Path.lineWidth = 1
        bezier8Path.stroke()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: 198.5, y: 35.5))
        bezier9Path.addLine(to: CGPoint(x: 193.5, y: 48.5))
        color3.setStroke()
        bezier9Path.lineWidth = 1
        bezier9Path.stroke()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: 190.5, y: 29.5))
        bezier10Path.addLine(to: CGPoint(x: 193.5, y: 48.5))
        color3.setStroke()
        bezier10Path.lineWidth = 1
        bezier10Path.stroke()
        
        
        //// Bezier 11 Drawing
        context.saveGState()
        context.translateBy(x: 69.74, y: 61.23)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier11Path = UIBezierPath()
        bezier11Path.move(to: CGPoint(x: 44.33, y: -9.28))
        bezier11Path.addCurve(to: CGPoint(x: 46.92, y: -24.82), controlPoint1: CGPoint(x: 27.57, y: -30.95), controlPoint2: CGPoint(x: 24.77, y: -44.86))
        bezier11Path.addCurve(to: CGPoint(x: 54.09, y: -0.34), controlPoint1: CGPoint(x: 75.72, y: 1.25), controlPoint2: CGPoint(x: 54.09, y: -0.34))
        bezier11Path.addCurve(to: CGPoint(x: 44.33, y: -9.28), controlPoint1: CGPoint(x: 54.09, y: -0.34), controlPoint2: CGPoint(x: 49.36, y: -2.78))
        bezier11Path.close()
        context.saveGState()
        bezier11Path.addClip()
        context.drawLinearGradient(gradient, start: CGPoint(x: 49.99, y: -22), end: CGPoint(x: 40.55, y: -12.57), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(BombeResizingBehavior)
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



private extension UIColor {
    func blended(withFraction fraction: CGFloat, of color: UIColor) -> UIColor {
        var r1: CGFloat = 1, g1: CGFloat = 1, b1: CGFloat = 1, a1: CGFloat = 1
        var r2: CGFloat = 1, g2: CGFloat = 1, b2: CGFloat = 1, a2: CGFloat = 1
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: r1 * (1 - fraction) + r2 * fraction,
                       green: g1 * (1 - fraction) + g2 * fraction,
                       blue: b1 * (1 - fraction) + b2 * fraction,
                       alpha: a1 * (1 - fraction) + a2 * fraction);
    }
}


