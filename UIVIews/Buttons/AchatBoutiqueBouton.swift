//
//  AchatBoutiqueBouton.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
class AchatBoutiqueBouton: UIButton {
    
    @IBInspectable var textColor: UIColor = UIColor(red: 1.000, green: 0.746, blue: 0.000, alpha: 1.000)
    @IBInspectable var prix: String = "1000"
    @IBInspectable var textsize: CGFloat = 60
    
    override func draw(_ rect: CGRect) {
        BoutonAchat.drawCanvas1(frame: rect, resizing: .aspectFill, textColor: textColor, prix: prix, textsize: textsize)
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



public class BoutonAchat : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 300, height: 100), resizing: ResizingBehavior = .aspectFit, textColor: UIColor = UIColor(red: 1.000, green: 0.746, blue: 0.000, alpha: 1.000), prix: String = "1000", textsize: CGFloat = 60) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 300, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 300, y: resizedFrame.height / 100)
        
        
        //// Color Declarations
        let gradientColor2 = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        let color3 = UIColor(red: 1.000, green: 0.746, blue: 0.000, alpha: 1.000)
        let gradientColor = UIColor(red: 0.874, green: 0.829, blue: 0.688, alpha: 1.000)
        let color5 = UIColor(red: 0.533, green: 0.368, blue: 0.000, alpha: 1.000)
        let color4 = UIColor(red: 1.000, green: 0.848, blue: 0.000, alpha: 1.000)
        let color2 = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        let backgroundColor = UIColor(red: 0.583, green: 0.583, blue: 0.583, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient = CGGradient(colorsSpace: nil, colors: [gradientColor2.cgColor, gradientColor2.blended(withFraction: 0.5, of: gradientColor).cgColor, gradientColor.cgColor] as CFArray, locations: [0, 0.72, 1])!
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 300, height: 100), cornerRadius: 15)
        backgroundColor.setFill()
        rectanglePath.fill()
        
        
        //// Group
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 26, y: 10, width: 80, height: 80))
        color3.setFill()
        ovalPath.fill()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 44.45, y: 30.68))
        bezier3Path.addCurve(to: CGPoint(x: 49.27, y: 16.46), controlPoint1: CGPoint(x: 53.9, y: 17.2), controlPoint2: CGPoint(x: 62.45, y: 11.03))
        bezier3Path.addCurve(to: CGPoint(x: 34.62, y: 29.6), controlPoint1: CGPoint(x: 43.59, y: 18.81), controlPoint2: CGPoint(x: 36.68, y: 25.91))
        bezier3Path.addCurve(to: CGPoint(x: 30.36, y: 55.15), controlPoint1: CGPoint(x: 26.4, y: 44.38), controlPoint2: CGPoint(x: 26.11, y: 58.54))
        bezier3Path.addCurve(to: CGPoint(x: 44.45, y: 30.68), controlPoint1: CGPoint(x: 32.15, y: 53.73), controlPoint2: CGPoint(x: 37.6, y: 40.46))
        bezier3Path.close()
        color4.setFill()
        bezier3Path.fill()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 64.27, y: 34.43))
        bezier4Path.addCurve(to: CGPoint(x: 64.8, y: 30.43), controlPoint1: CGPoint(x: 64.27, y: 34.43), controlPoint2: CGPoint(x: 63.74, y: 31.01))
        bezier4Path.addCurve(to: CGPoint(x: 67.73, y: 27.36), controlPoint1: CGPoint(x: 64.54, y: 29.72), controlPoint2: CGPoint(x: 66.8, y: 27.36))
        bezier4Path.addCurve(to: CGPoint(x: 71.45, y: 25.95), controlPoint1: CGPoint(x: 67.99, y: 26.66), controlPoint2: CGPoint(x: 70.65, y: 25.71))
        bezier4Path.addCurve(to: CGPoint(x: 76.23, y: 25.48), controlPoint1: CGPoint(x: 71.98, y: 25.13), controlPoint2: CGPoint(x: 75.43, y: 25.01))
        bezier4Path.addCurve(to: CGPoint(x: 80.75, y: 25.95), controlPoint1: CGPoint(x: 77.03, y: 24.77), controlPoint2: CGPoint(x: 80.48, y: 25.48))
        bezier4Path.addCurve(to: CGPoint(x: 83.94, y: 27.36), controlPoint1: CGPoint(x: 81.55, y: 25.6), controlPoint2: CGPoint(x: 84.2, y: 26.66))
        bezier4Path.addCurve(to: CGPoint(x: 86.06, y: 28.78), controlPoint1: CGPoint(x: 84.74, y: 27.36), controlPoint2: CGPoint(x: 86.06, y: 28.07))
        bezier4Path.addCurve(to: CGPoint(x: 86.86, y: 31.37), controlPoint1: CGPoint(x: 86.73, y: 28.78), controlPoint2: CGPoint(x: 86.99, y: 30.66))
        bezier4Path.addCurve(to: CGPoint(x: 84.74, y: 31.84), controlPoint1: CGPoint(x: 86.33, y: 31.84), controlPoint2: CGPoint(x: 84.74, y: 31.84))
        bezier4Path.addCurve(to: CGPoint(x: 83.14, y: 29.95), controlPoint1: CGPoint(x: 84.74, y: 31.84), controlPoint2: CGPoint(x: 83.41, y: 30.66))
        bezier4Path.addCurve(to: CGPoint(x: 81.02, y: 29.01), controlPoint1: CGPoint(x: 82.48, y: 29.84), controlPoint2: CGPoint(x: 81.02, y: 29.01))
        bezier4Path.addCurve(to: CGPoint(x: 78.09, y: 28.31), controlPoint1: CGPoint(x: 81.02, y: 29.01), controlPoint2: CGPoint(x: 79.15, y: 28.78))
        bezier4Path.addCurve(to: CGPoint(x: 74.9, y: 28.31), controlPoint1: CGPoint(x: 77.16, y: 28.42), controlPoint2: CGPoint(x: 76.23, y: 28.54))
        bezier4Path.addCurve(to: CGPoint(x: 70.92, y: 29.25), controlPoint1: CGPoint(x: 73.44, y: 28.89), controlPoint2: CGPoint(x: 72.51, y: 29.01))
        bezier4Path.addCurve(to: CGPoint(x: 68.26, y: 31.37), controlPoint1: CGPoint(x: 70.12, y: 30.31), controlPoint2: CGPoint(x: 69.06, y: 30.9))
        bezier4Path.addCurve(to: CGPoint(x: 67.73, y: 34.43), controlPoint1: CGPoint(x: 68.39, y: 32.78), controlPoint2: CGPoint(x: 67.73, y: 34.43))
        color2.setFill()
        bezier4Path.fill()
        color5.setStroke()
        bezier4Path.lineWidth = 1
        bezier4Path.stroke()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 64.8, y: 30.43))
        bezier5Path.addLine(to: CGPoint(x: 70.92, y: 29.25))
        color5.setStroke()
        bezier5Path.lineWidth = 1
        bezier5Path.stroke()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 64.27, y: 34.43))
        bezier6Path.addLine(to: CGPoint(x: 68.26, y: 31.37))
        color5.setStroke()
        bezier6Path.lineWidth = 1
        bezier6Path.stroke()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: 45.27, y: 40.95, width: 39, height: 36))
        color2.setFill()
        oval3Path.fill()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 60.42, y: 42.79))
        bezier7Path.addLine(to: CGPoint(x: 60.42, y: 36.67))
        bezier7Path.addCurve(to: CGPoint(x: 65.73, y: 34.08), controlPoint1: CGPoint(x: 60.42, y: 36.67), controlPoint2: CGPoint(x: 60.68, y: 34.08))
        bezier7Path.addCurve(to: CGPoint(x: 71.58, y: 36.67), controlPoint1: CGPoint(x: 70.78, y: 34.08), controlPoint2: CGPoint(x: 71.58, y: 36.67))
        bezier7Path.addLine(to: CGPoint(x: 71.58, y: 42.79))
        color2.setFill()
        bezier7Path.fill()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 67.73, y: 27.36))
        bezier8Path.addLine(to: CGPoint(x: 74.9, y: 28.31))
        color5.setStroke()
        bezier8Path.lineWidth = 1
        bezier8Path.stroke()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: 71.45, y: 25.95))
        bezier9Path.addLine(to: CGPoint(x: 78.09, y: 28.31))
        color5.setStroke()
        bezier9Path.lineWidth = 1
        bezier9Path.stroke()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: 76.23, y: 25.48))
        bezier10Path.addLine(to: CGPoint(x: 81.02, y: 29.01))
        color5.setStroke()
        bezier10Path.lineWidth = 1
        bezier10Path.stroke()
        
        
        //// Bezier 11 Drawing
        let bezier11Path = UIBezierPath()
        bezier11Path.move(to: CGPoint(x: 80.75, y: 25.95))
        bezier11Path.addLine(to: CGPoint(x: 83.14, y: 29.95))
        color5.setStroke()
        bezier11Path.lineWidth = 1
        bezier11Path.stroke()
        
        
        //// Bezier 12 Drawing
        let bezier12Path = UIBezierPath()
        bezier12Path.move(to: CGPoint(x: 86.06, y: 28.78))
        bezier12Path.addLine(to: CGPoint(x: 84.74, y: 31.84))
        color5.setStroke()
        bezier12Path.lineWidth = 1
        bezier12Path.stroke()
        
        
        //// Bezier 13 Drawing
        let bezier13Path = UIBezierPath()
        bezier13Path.move(to: CGPoint(x: 83.94, y: 27.36))
        bezier13Path.addLine(to: CGPoint(x: 84.74, y: 31.84))
        color5.setStroke()
        bezier13Path.lineWidth = 1
        bezier13Path.stroke()
        
        
        //// Bezier 14 Drawing
        context.saveGState()
        context.translateBy(x: 53.1, y: 11.15)
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
        
        
        
        
        //// Text Drawing
        let textRect = CGRect(x: 106, y: 10, width: 167, height: 80)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            .font: UIFont(name: "PingFangSC-Medium", size: textsize)!,
            .foregroundColor: textColor,
            .paragraphStyle: textStyle,
            ] as [NSAttributedStringKey: Any]
        
        let textTextHeight: CGFloat = prix.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        prix.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(BoutonAchatResizingBehavior)
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
