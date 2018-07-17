//
//  PieceView.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

@IBDesignable
class PieceView: UIView {

    override func draw(_ rect: CGRect) {
        Piece.drawCanvas1(frame: rect, resizing: .aspectFill)
    }
 

}



public class Piece : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 120, height: 120), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 120, height: 120), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 120, y: resizedFrame.height / 120)
        
        
        //// Color Declarations
        let color3 = UIColor(red: 1.000, green: 0.746, blue: 0.000, alpha: 1.000)
        let color4 = UIColor(red: 1.000, green: 0.848, blue: 0.000, alpha: 1.000)
        let color5 = UIColor(red: 0.533, green: 0.368, blue: 0.000, alpha: 1.000)
        let color = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        let gradientColor = UIColor(red: 0.874, green: 0.829, blue: 0.688, alpha: 1.000)
        let gradientColor2 = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient = CGGradient(colorsSpace: nil, colors: [gradientColor2.cgColor, gradientColor2.blended(withFraction: 0.5, of: gradientColor).cgColor, gradientColor.cgColor] as CFArray, locations: [0, 0.72, 1])!
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 20, y: 20, width: 80, height: 80))
        color3.setFill()
        ovalPath.fill()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 38.45, y: 40.68))
        bezier3Path.addCurve(to: CGPoint(x: 43.27, y: 26.46), controlPoint1: CGPoint(x: 47.9, y: 27.2), controlPoint2: CGPoint(x: 56.45, y: 21.03))
        bezier3Path.addCurve(to: CGPoint(x: 28.62, y: 39.6), controlPoint1: CGPoint(x: 37.59, y: 28.81), controlPoint2: CGPoint(x: 30.68, y: 35.91))
        bezier3Path.addCurve(to: CGPoint(x: 24.36, y: 65.15), controlPoint1: CGPoint(x: 20.4, y: 54.38), controlPoint2: CGPoint(x: 20.11, y: 68.54))
        bezier3Path.addCurve(to: CGPoint(x: 38.45, y: 40.68), controlPoint1: CGPoint(x: 26.15, y: 63.73), controlPoint2: CGPoint(x: 31.6, y: 50.46))
        bezier3Path.close()
        color4.setFill()
        bezier3Path.fill()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 58.27, y: 44.43))
        bezier4Path.addCurve(to: CGPoint(x: 58.8, y: 40.43), controlPoint1: CGPoint(x: 58.27, y: 44.43), controlPoint2: CGPoint(x: 57.74, y: 41.01))
        bezier4Path.addCurve(to: CGPoint(x: 61.73, y: 37.36), controlPoint1: CGPoint(x: 58.54, y: 39.72), controlPoint2: CGPoint(x: 60.8, y: 37.36))
        bezier4Path.addCurve(to: CGPoint(x: 65.45, y: 35.95), controlPoint1: CGPoint(x: 61.99, y: 36.66), controlPoint2: CGPoint(x: 64.65, y: 35.71))
        bezier4Path.addCurve(to: CGPoint(x: 70.23, y: 35.48), controlPoint1: CGPoint(x: 65.98, y: 35.13), controlPoint2: CGPoint(x: 69.43, y: 35.01))
        bezier4Path.addCurve(to: CGPoint(x: 74.75, y: 35.95), controlPoint1: CGPoint(x: 71.03, y: 34.77), controlPoint2: CGPoint(x: 74.48, y: 35.48))
        bezier4Path.addCurve(to: CGPoint(x: 77.94, y: 37.36), controlPoint1: CGPoint(x: 75.55, y: 35.6), controlPoint2: CGPoint(x: 78.2, y: 36.66))
        bezier4Path.addCurve(to: CGPoint(x: 80.06, y: 38.78), controlPoint1: CGPoint(x: 78.74, y: 37.36), controlPoint2: CGPoint(x: 80.06, y: 38.07))
        bezier4Path.addCurve(to: CGPoint(x: 80.86, y: 41.37), controlPoint1: CGPoint(x: 80.73, y: 38.78), controlPoint2: CGPoint(x: 80.99, y: 40.66))
        bezier4Path.addCurve(to: CGPoint(x: 78.74, y: 41.84), controlPoint1: CGPoint(x: 80.33, y: 41.84), controlPoint2: CGPoint(x: 78.74, y: 41.84))
        bezier4Path.addCurve(to: CGPoint(x: 77.14, y: 39.95), controlPoint1: CGPoint(x: 78.74, y: 41.84), controlPoint2: CGPoint(x: 77.41, y: 40.66))
        bezier4Path.addCurve(to: CGPoint(x: 75.02, y: 39.01), controlPoint1: CGPoint(x: 76.48, y: 39.84), controlPoint2: CGPoint(x: 75.02, y: 39.01))
        bezier4Path.addCurve(to: CGPoint(x: 72.09, y: 38.31), controlPoint1: CGPoint(x: 75.02, y: 39.01), controlPoint2: CGPoint(x: 73.15, y: 38.78))
        bezier4Path.addCurve(to: CGPoint(x: 68.9, y: 38.31), controlPoint1: CGPoint(x: 71.16, y: 38.42), controlPoint2: CGPoint(x: 70.23, y: 38.54))
        bezier4Path.addCurve(to: CGPoint(x: 64.92, y: 39.25), controlPoint1: CGPoint(x: 67.44, y: 38.89), controlPoint2: CGPoint(x: 66.51, y: 39.01))
        bezier4Path.addCurve(to: CGPoint(x: 62.26, y: 41.37), controlPoint1: CGPoint(x: 64.12, y: 40.31), controlPoint2: CGPoint(x: 63.06, y: 40.9))
        bezier4Path.addCurve(to: CGPoint(x: 61.73, y: 44.43), controlPoint1: CGPoint(x: 62.39, y: 42.78), controlPoint2: CGPoint(x: 61.73, y: 44.43))
        color.setFill()
        bezier4Path.fill()
        color5.setStroke()
        bezier4Path.lineWidth = 1
        bezier4Path.stroke()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 58.8, y: 40.43))
        bezier5Path.addLine(to: CGPoint(x: 64.92, y: 39.25))
        color5.setStroke()
        bezier5Path.lineWidth = 1
        bezier5Path.stroke()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 58.27, y: 44.43))
        bezier6Path.addLine(to: CGPoint(x: 62.26, y: 41.37))
        color5.setStroke()
        bezier6Path.lineWidth = 1
        bezier6Path.stroke()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: 39.27, y: 50.95, width: 39, height: 36))
        color.setFill()
        oval3Path.fill()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 54.42, y: 52.79))
        bezier7Path.addLine(to: CGPoint(x: 54.42, y: 46.67))
        bezier7Path.addCurve(to: CGPoint(x: 59.73, y: 44.08), controlPoint1: CGPoint(x: 54.42, y: 46.67), controlPoint2: CGPoint(x: 54.68, y: 44.08))
        bezier7Path.addCurve(to: CGPoint(x: 65.58, y: 46.67), controlPoint1: CGPoint(x: 64.78, y: 44.08), controlPoint2: CGPoint(x: 65.58, y: 46.67))
        bezier7Path.addLine(to: CGPoint(x: 65.58, y: 52.79))
        color.setFill()
        bezier7Path.fill()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 61.73, y: 37.36))
        bezier8Path.addLine(to: CGPoint(x: 68.9, y: 38.31))
        color5.setStroke()
        bezier8Path.lineWidth = 1
        bezier8Path.stroke()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: 65.45, y: 35.95))
        bezier9Path.addLine(to: CGPoint(x: 72.09, y: 38.31))
        color5.setStroke()
        bezier9Path.lineWidth = 1
        bezier9Path.stroke()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: 70.23, y: 35.48))
        bezier10Path.addLine(to: CGPoint(x: 75.02, y: 39.01))
        color5.setStroke()
        bezier10Path.lineWidth = 1
        bezier10Path.stroke()
        
        
        //// Bezier 11 Drawing
        let bezier11Path = UIBezierPath()
        bezier11Path.move(to: CGPoint(x: 74.75, y: 35.95))
        bezier11Path.addLine(to: CGPoint(x: 77.14, y: 39.95))
        color5.setStroke()
        bezier11Path.lineWidth = 1
        bezier11Path.stroke()
        
        
        //// Bezier 12 Drawing
        let bezier12Path = UIBezierPath()
        bezier12Path.move(to: CGPoint(x: 80.06, y: 38.78))
        bezier12Path.addLine(to: CGPoint(x: 78.74, y: 41.84))
        color5.setStroke()
        bezier12Path.lineWidth = 1
        bezier12Path.stroke()
        
        
        //// Bezier 13 Drawing
        let bezier13Path = UIBezierPath()
        bezier13Path.move(to: CGPoint(x: 77.94, y: 37.36))
        bezier13Path.addLine(to: CGPoint(x: 78.74, y: 41.84))
        color5.setStroke()
        bezier13Path.lineWidth = 1
        bezier13Path.stroke()
        
        
        //// Bezier 14 Drawing
        context.saveGState()
        context.translateBy(x: 47.1, y: 21.15)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier14Path = UIBezierPath()
        bezier14Path.move(to: CGPoint(x: 34.14, y: -2.69))
        bezier14Path.addCurve(to: CGPoint(x: 34.74, y: -6.79), controlPoint1: CGPoint(x: 30.22, y: -8.4), controlPoint2: CGPoint(x: 29.57, y: -12.08))
        bezier14Path.addCurve(to: CGPoint(x: 36.42, y: -0.33), controlPoint1: CGPoint(x: 41.47, y: 0.09), controlPoint2: CGPoint(x: 36.42, y: -0.33))
        bezier14Path.addCurve(to: CGPoint(x: 34.14, y: -2.69), controlPoint1: CGPoint(x: 36.42, y: -0.33), controlPoint2: CGPoint(x: 35.31, y: -0.97))
        bezier14Path.close()
        context.saveGState()
        bezier14Path.addClip()
        context.drawLinearGradient(gradient, start: CGPoint(x: 35.53, y: -6), end: CGPoint(x: 33.05, y: -3.51), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(PieceResizingBehavior)
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
