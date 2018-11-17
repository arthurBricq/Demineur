//
//  BonusView.swift
//  Demineur
//
//  Created by Arthur BRICQ on 18/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class BonusView: UIView {

    var index: Int = 1
    var tempsAngleParameter: CGFloat = 45
    var writenNumber: Int {
        get {
            if index == 0 {
                
                switch dataManager.levelOfBonus(atIndex:  0) {
                case 0:
                    return 15
                case 1:
                    return 30
                case 2:
                    return 45
                case 3:
                    return 60
                default:
                    return 15
                }
                
            } else if index == 1 {
                
                switch dataManager.levelOfBonus(atIndex:  1) {
                case 0:
                    return 1
                case 1:
                    return 2
                case 2:
                    return 3
                default:
                    return 1
                }
                
            } else if index == 4 {
                
                switch dataManager.levelOfBonus(atIndex:  4) {
                case 0:
                    return 1
                case 1:
                    return 2
                case 2:
                    return 3
                default:
                    return 1
                }
                
            } else {
                return 1
            }
        }
    }
    var delegate: BonusButtonsCanCallVC?
    
    override func draw(_ rect: CGRect) {
        if index == 0 {
            BonusDraw.drawBonusTemps(frame: rect, resizing: .aspectFill, angle: tempsAngleParameter, amountToAdd: writenNumber )
        } else if index == 1 {
            BonusDraw.drawBonusDrapeau(frame: rect, resizing: .aspectFill, amountToAdd: writenNumber)
        } else if index == 2 {
            BonusDraw.drawBonusBombe(frame: rect, resizing: .aspectFill)
        }  else if index == 3 {
            BonusDraw.drawBonusVerification(frame: rect, resizing: .aspectFill, width: 2)
        }  else if index == 4 {
            BonusDraw.drawBonusVie(frame: rect, resizing: .aspectFill, amountToAdd: writenNumber)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.alpha = 0.4
    }
 
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1.0
        }
        
        if index == 0 {
            delegate!.tempsTapped()
        } else if index == 1 {
            delegate!.drapeauTapped()
        } else if index == 2 {
            delegate!.bombeTapped()
        } else if index == 3 {
            delegate!.verificationTapped()
        } else {
            delegate!.vieTapped()
        }
        
        
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
        }
    }
    
    
}


public class BonusDraw : NSObject {
    
    //// Cache
    
    private struct Cache {
        static let color2: UIColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1.000)
    }
    
    //// Colors
    
    @objc dynamic public class var color2: UIColor { return Cache.color2 }
    
    //// Drawing Methods
    
    @objc dynamic public class func drawBonusVerification(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 140, height: 140), resizing: ResizingBehavior = .aspectFit, width: CGFloat = 5) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 140, height: 140), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 140, y: resizedFrame.height / 140)
        
        
        //// Color Declarations
        let color = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1.000)
        let gradientColor = UIColor(red: 0.546, green: 0.541, blue: 0.541, alpha: 1.000)
        let color6 = UIColor(red: 0.320, green: 0.623, blue: 0.355, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient = CGGradient(colorsSpace: nil, colors: [gradientColor.cgColor, gradientColor.blended(withFraction: 0.5, of: UIColor.white).cgColor, UIColor.white.cgColor] as CFArray, locations: [0.33, 0.8, 1])!
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 2.26, y: 1.71, width: 136, height: 136), cornerRadius: 4)
        gradientColor.setStroke()
        rectanglePath.lineWidth = 3
        rectanglePath.stroke()
        
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 47.23, y: 12.55, width: 72, height: 71))
        UIColor.gray.setFill()
        ovalPath.fill()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 67.9, y: 60.01))
        bezierPath.addCurve(to: CGPoint(x: 23.46, y: 113.27), controlPoint1: CGPoint(x: 67.9, y: 60.01), controlPoint2: CGPoint(x: 27.38, y: 108.53))
        bezierPath.addCurve(to: CGPoint(x: 19.54, y: 126.28), controlPoint1: CGPoint(x: 19.54, y: 118), controlPoint2: CGPoint(x: 16.27, y: 122.73))
        bezierPath.addCurve(to: CGPoint(x: 32.61, y: 122.73), controlPoint1: CGPoint(x: 22.81, y: 129.84), controlPoint2: CGPoint(x: 28.69, y: 127.47))
        bezierPath.addCurve(to: CGPoint(x: 77.05, y: 67.11), controlPoint1: CGPoint(x: 36.53, y: 118), controlPoint2: CGPoint(x: 77.05, y: 67.11))
        UIColor.gray.setFill()
        bezierPath.fill()
        
        
        //// Bezier 2 Drawing
        context.saveGState()
        context.translateBy(x: 51.9, y: 17.02)
        context.rotate(by: -3.91 * CGFloat.pi/180)
        
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 17.55, y: 0.8))
        bezier2Path.addCurve(to: CGPoint(x: 0, y: 15.62), controlPoint1: CGPoint(x: 5.85, y: 3.49), controlPoint2: CGPoint(x: 0, y: 15.62))
        bezier2Path.addCurve(to: CGPoint(x: 17.55, y: 6.19), controlPoint1: CGPoint(x: 0, y: 15.62), controlPoint2: CGPoint(x: 10.51, y: 9.58))
        bezier2Path.addCurve(to: CGPoint(x: 17.55, y: 0.8), controlPoint1: CGPoint(x: 24.59, y: 2.8), controlPoint2: CGPoint(x: 29.25, y: -1.89))
        bezier2Path.close()
        context.saveGState()
        bezier2Path.addClip()
        context.drawLinearGradient(gradient, start: CGPoint(x: 13.56, y: 9.79), end: CGPoint(x: 9.65, y: 4.41), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 55.23, y: 20.55, width: 56, height: 56))
        color.setFill()
        oval2Path.fill()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 70.44, y: 48.5))
        bezier3Path.addCurve(to: CGPoint(x: 74.38, y: 53.19), controlPoint1: CGPoint(x: 70.44, y: 48.5), controlPoint2: CGPoint(x: 72.5, y: 50.39))
        bezier3Path.addCurve(to: CGPoint(x: 77.93, y: 59.72), controlPoint1: CGPoint(x: 76.25, y: 55.99), controlPoint2: CGPoint(x: 77.93, y: 59.72))
        bezier3Path.addCurve(to: CGPoint(x: 86.34, y: 44.99), controlPoint1: CGPoint(x: 77.93, y: 59.72), controlPoint2: CGPoint(x: 81.75, y: 51.35))
        bezier3Path.addCurve(to: CGPoint(x: 95.2, y: 34.28), controlPoint1: CGPoint(x: 90.93, y: 38.63), controlPoint2: CGPoint(x: 95.2, y: 34.28))
        color6.setStroke()
        bezier3Path.lineWidth = width
        bezier3Path.lineCapStyle = .round
        bezier3Path.stroke()
        
        context.restoreGState()
        
    }
    
    @objc dynamic public class func drawBonusVie(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 140, height: 140), resizing: ResizingBehavior = .aspectFit, amountToAdd: Int) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 140, height: 140), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 140, y: resizedFrame.height / 140)
        
        
        //// Color Declarations
        let gradientColor = UIColor(red: 0.546, green: 0.541, blue: 0.541, alpha: 1.000)
        let color5 = UIColor(red: 0.751, green: 0.751, blue: 0.751, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient2 = CGGradient(colorsSpace: nil, colors: [BonusDraw.color2.cgColor, BonusDraw.color2.blended(withFraction: 0.5, of: UIColor.white).cgColor, UIColor.white.cgColor] as CFArray, locations: [0, 0.64, 1])!
        
        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: 2.13, y: 1.7, width: 136, height: 136), cornerRadius: 4)
        gradientColor.setStroke()
        rectangle2Path.lineWidth = 3
        rectangle2Path.stroke()
        
        
        //// Group 4
        
        
        //// Group
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 70.59, y: 48.72))
        bezierPath.addCurve(to: CGPoint(x: 55.72, y: 34.2), controlPoint1: CGPoint(x: 70.59, y: 48.72), controlPoint2: CGPoint(x: 69.45, y: 37.62))
        bezierPath.addCurve(to: CGPoint(x: 28.95, y: 44.07), controlPoint1: CGPoint(x: 41.99, y: 30.78), controlPoint2: CGPoint(x: 32.56, y: 37.19))
        bezierPath.addCurve(to: CGPoint(x: 37.35, y: 78.58), controlPoint1: CGPoint(x: 25.33, y: 50.94), controlPoint2: CGPoint(x: 25.45, y: 67.65))
        bezierPath.addCurve(to: CGPoint(x: 70.56, y: 109.01), controlPoint1: CGPoint(x: 49.26, y: 89.51), controlPoint2: CGPoint(x: 55.74, y: 95))
        BonusDraw.color2.setFill()
        bezierPath.fill()
        
        
        //// Bezier 2 Drawing
        context.saveGState()
        context.translateBy(x: 113.72, y: 33.32)
        context.scaleBy(x: -1, y: 1)
        
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 43.72, y: 15.46))
        bezier2Path.addCurve(to: CGPoint(x: 28.85, y: 0.95), controlPoint1: CGPoint(x: 43.72, y: 15.46), controlPoint2: CGPoint(x: 42.58, y: 4.36))
        bezier2Path.addCurve(to: CGPoint(x: 2.08, y: 10.82), controlPoint1: CGPoint(x: 15.12, y: -2.47), controlPoint2: CGPoint(x: 5.7, y: 3.94))
        bezier2Path.addCurve(to: CGPoint(x: 10.49, y: 45.33), controlPoint1: CGPoint(x: -1.54, y: 17.69), controlPoint2: CGPoint(x: -1.42, y: 34.4))
        bezier2Path.addCurve(to: CGPoint(x: 43.7, y: 75.75), controlPoint1: CGPoint(x: 22.4, y: 56.26), controlPoint2: CGPoint(x: 28.87, y: 61.75))
        BonusDraw.color2.setFill()
        bezier2Path.fill()
        
        context.restoreGState()
        
        
        
        
        //// Group 2
        
        
        //// Bezier 4 Drawing
        context.saveGState()
        context.translateBy(x: 29.4, y: 37.56)
        context.rotate(by: -3.91 * CGFloat.pi/180)
        
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 9.31, y: 2.03))
        bezier4Path.addCurve(to: CGPoint(x: 1.18, y: 29.16), controlPoint1: CGPoint(x: -4.57, y: 6.25), controlPoint2: CGPoint(x: 1.18, y: 29.16))
        bezier4Path.addCurve(to: CGPoint(x: 25.67, y: 4.85), controlPoint1: CGPoint(x: 1.18, y: 29.16), controlPoint2: CGPoint(x: 12.02, y: 8.29))
        bezier4Path.addCurve(to: CGPoint(x: 9.31, y: 2.03), controlPoint1: CGPoint(x: 28.59, y: 2.96), controlPoint2: CGPoint(x: 23.18, y: -2.19))
        bezier4Path.close()
        context.saveGState()
        bezier4Path.addClip()
        context.drawRadialGradient(gradient2,
                                   startCenter: CGPoint(x: 26.19, y: 25.26), startRadius: 12.04,
                                   endCenter: CGPoint(x: 13.71, y: 20.05), endRadius: 33.22,
                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()
        
        context.restoreGState()
        
        
        //// Group 3
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 8.93, y: 6.91, width: 42, height: 42))
        color5.setFill()
        oval2Path.fill()
        
        
        //// Text Drawing
        let textRect = CGRect(x: 10.62, y: 4.26, width: 34.57, height: 46)
        let textTextContent = "+\(amountToAdd)"
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            .font: UIFont(name: "PingFangSC-Semibold", size: 28)!,
            .foregroundColor: UIColor.white,
            .paragraphStyle: textStyle,
            ] as [NSAttributedStringKey: Any]
        
        let textTextHeight: CGFloat = textTextContent.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        textTextContent.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    @objc dynamic public class func drawBonusDrapeau(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 140, height: 140), resizing: ResizingBehavior = .aspectFit, amountToAdd: Int) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 140, height: 140), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 140, y: resizedFrame.height / 140)
        
        
        //// Color Declarations
        let gradientColor = UIColor(red: 0.546, green: 0.541, blue: 0.541, alpha: 1.000)
        let color3 = UIColor.orange//UIColor(red: 0.176, green: 0.523, blue: 0.035, alpha: 1.000)
        let color4 = UIColor(red: 0.350, green: 0.274, blue: 0.000, alpha: 1.000)
        let color5 = UIColor(red: 0.751, green: 0.751, blue: 0.751, alpha: 1.000)
        
        //// Group
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 2.36, y: 1.67, width: 136, height: 136), cornerRadius: 4)
        gradientColor.setStroke()
        rectanglePath.lineWidth = 3
        rectanglePath.stroke()
        
        
        
        
        //// Group 2
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 54.99, y: 22.02))
        bezier4Path.addLine(to: CGPoint(x: 54.99, y: 58.99))
        bezier4Path.addLine(to: CGPoint(x: 106.23, y: 42.61))
        bezier4Path.addLine(to: CGPoint(x: 54.99, y: 22.02))
        bezier4Path.close()
        color3.setFill()
        bezier4Path.fill()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 54.73, y: 22.26))
        bezier2Path.addCurve(to: CGPoint(x: 54.73, y: 120.52), controlPoint1: CGPoint(x: 54.73, y: 24.54), controlPoint2: CGPoint(x: 54.73, y: 120.52))
        color4.setStroke()
        bezier2Path.lineWidth = 5
        bezier2Path.stroke()
        
        
        //// Group 5
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 8.93, y: 6.91, width: 42, height: 42))
        color5.setFill()
        ovalPath.fill()
        
        
        //// Text Drawing
        let textRect = CGRect(x: 10.62, y: 4.26, width: 34.57, height: 46)
        let textTextContent = "+\(amountToAdd)"
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let textFontAttributes = [
            .font: UIFont(name: "PingFangSC-Semibold", size: 28)!,
            .foregroundColor: UIColor.white,
            .paragraphStyle: textStyle,
            ] as [NSAttributedStringKey: Any]
        
        let textTextHeight: CGFloat = textTextContent.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        textTextContent.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    @objc dynamic public class func drawBonusTemps(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 140, height: 140), resizing: ResizingBehavior = .aspectFit, angle: CGFloat = 0, amountToAdd: Int) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 140, height: 140), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 140, y: resizedFrame.height / 140)
        
        
        //// Color Declarations
        let gradientColor = UIColor(red: 0.546, green: 0.541, blue: 0.541, alpha: 1.000)
        let color5 = UIColor(red: 0.751, green: 0.751, blue: 0.751, alpha: 1.000)
        let color8 = UIColor(red: 0.791, green: 0.047, blue: 0.047, alpha: 1.000)
        
        //// Group
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 1.87, y: 1.64, width: 136, height: 136), cornerRadius: 4)
        gradientColor.setStroke()
        rectanglePath.lineWidth = 3
        rectanglePath.stroke()
        
        
        
        
        //// Oval Drawing
        context.saveGState()
        context.translateBy(x: 71.11, y: 70.39)
        
        let ovalRect = CGRect(x: -50, y: -50, width: 100, height: 100)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.midY), radius: ovalRect.width / 2, startAngle: -90 * CGFloat.pi/180, endAngle: -angle * CGFloat.pi/180, clockwise: true)
        
        UIColor.gray.setStroke()
        ovalPath.lineWidth = 3
        ovalPath.lineCapStyle = .round
        ovalPath.stroke()
        
        context.restoreGState()
        
        
        //// Bezier Drawing
        context.saveGState()
        context.translateBy(x: 71.11, y: 70.39)
        context.scaleBy(x: 1, y: -1)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 36))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        UIColor.gray.setStroke()
        bezierPath.lineWidth = 5
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
        
        context.restoreGState()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 71.11, y: 70.39))
        bezier2Path.addLine(to: CGPoint(x: 91.11, y: 70.39))
        UIColor.gray.setStroke()
        bezier2Path.lineWidth = 5
        bezier2Path.lineCapStyle = .round
        bezier2Path.stroke()
        
        
        //// Oval 2 Drawing
        context.saveGState()
        context.translateBy(x: 70.11, y: 71.39)
        context.rotate(by: -angle * CGFloat.pi/180)
        
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 48, y: -3.39, width: 5.89, height: 5.39))
        color8.setFill()
        oval2Path.fill()
        
        context.restoreGState()
        
        
        //// Group 5
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: 9.38, y: 8.11, width: 55, height: 55))
        color5.setFill()
        oval3Path.fill()
        
        
        //// Text Drawing
        let textRect = CGRect(x: 14.93, y: 12.16, width: 69.39, height: 46)
        let textTextContent = "\(amountToAdd)s"
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        let textFontAttributes = [
            .font: UIFont(name: "PingFangSC-Semibold", size: 30)!,
            .foregroundColor: UIColor.white,
            .paragraphStyle: textStyle,
            ] as [NSAttributedStringKey: Any]
        
        let textTextHeight: CGFloat = textTextContent.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        textTextContent.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    @objc dynamic public class func drawBonusBombe(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 140, height: 140), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 140, height: 140), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 140, y: resizedFrame.height / 140)
        
        
        //// Color Declarations
        let gradientColor = UIColor(red: 0.546, green: 0.541, blue: 0.541, alpha: 1.000)
        let color7 = UIColor(red: 0.171, green: 0.107, blue: 0.000, alpha: 0.899)
        let color9 = UIColor(red: 0.194, green: 0.134, blue: 0.000, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient3 = CGGradient(colorsSpace: nil, colors: [UIColor.gray.cgColor, UIColor.gray.blended(withFraction: 0.5, of: UIColor.lightGray).cgColor, UIColor.lightGray.cgColor] as CFArray, locations: [0.13, 0.48, 0.75])!
        
        //// Group
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 2.36, y: 1.67, width: 136, height: 136), cornerRadius: 4)
        gradientColor.setStroke()
        rectanglePath.lineWidth = 3
        rectanglePath.stroke()
        
        
        
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 20.5, y: 19.5, width: 100, height: 100))
        UIColor.gray.setStroke()
        ovalPath.lineWidth = 5
        ovalPath.stroke()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        UIColor.gray.setStroke()
        bezierPath.lineWidth = 5
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 70.5, y: 9.5))
        bezier2Path.addLine(to: CGPoint(x: 70.5, y: 31.5))
        UIColor.gray.setStroke()
        bezier2Path.lineWidth = 5
        bezier2Path.lineCapStyle = .round
        bezier2Path.stroke()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 70.5, y: 108.5))
        bezier3Path.addLine(to: CGPoint(x: 70.5, y: 130.5))
        UIColor.gray.setStroke()
        bezier3Path.lineWidth = 5
        bezier3Path.lineCapStyle = .round
        bezier3Path.stroke()
        
        
        //// Bezier 4 Drawing
        context.saveGState()
        context.translateBy(x: 31.5, y: 69.5)
        context.rotate(by: 90 * CGFloat.pi/180)
        
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 0, y: 0))
        bezier4Path.addLine(to: CGPoint(x: 0, y: 22))
        UIColor.gray.setStroke()
        bezier4Path.lineWidth = 5
        bezier4Path.lineCapStyle = .round
        bezier4Path.stroke()
        
        context.restoreGState()
        
        
        //// Bezier 5 Drawing
        context.saveGState()
        context.translateBy(x: 131.5, y: 69.5)
        context.rotate(by: 90 * CGFloat.pi/180)
        
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 0, y: 0))
        bezier5Path.addLine(to: CGPoint(x: 0, y: 22))
        UIColor.gray.setStroke()
        bezier5Path.lineWidth = 5
        bezier5Path.lineCapStyle = .round
        bezier5Path.stroke()
        
        context.restoreGState()
        
        
        //// Group 2
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 69.18, y: 52.66))
        bezier6Path.addCurve(to: CGPoint(x: 69.66, y: 48.58), controlPoint1: CGPoint(x: 69.18, y: 52.66), controlPoint2: CGPoint(x: 68.7, y: 49.18))
        bezier6Path.addCurve(to: CGPoint(x: 72.3, y: 45.46), controlPoint1: CGPoint(x: 69.42, y: 47.86), controlPoint2: CGPoint(x: 71.46, y: 45.46))
        bezier6Path.addCurve(to: CGPoint(x: 75.66, y: 44.02), controlPoint1: CGPoint(x: 72.54, y: 44.74), controlPoint2: CGPoint(x: 74.94, y: 43.78))
        bezier6Path.addCurve(to: CGPoint(x: 79.99, y: 43.54), controlPoint1: CGPoint(x: 76.14, y: 43.18), controlPoint2: CGPoint(x: 79.27, y: 43.06))
        bezier6Path.addCurve(to: CGPoint(x: 84.07, y: 44.02), controlPoint1: CGPoint(x: 80.71, y: 42.82), controlPoint2: CGPoint(x: 83.83, y: 43.54))
        bezier6Path.addCurve(to: CGPoint(x: 86.95, y: 45.46), controlPoint1: CGPoint(x: 84.79, y: 43.66), controlPoint2: CGPoint(x: 87.19, y: 44.74))
        bezier6Path.addCurve(to: CGPoint(x: 88.87, y: 46.9), controlPoint1: CGPoint(x: 87.67, y: 45.46), controlPoint2: CGPoint(x: 88.87, y: 46.18))
        bezier6Path.addCurve(to: CGPoint(x: 89.59, y: 49.54), controlPoint1: CGPoint(x: 89.47, y: 46.9), controlPoint2: CGPoint(x: 89.72, y: 48.82))
        bezier6Path.addCurve(to: CGPoint(x: 87.67, y: 50.02), controlPoint1: CGPoint(x: 89.11, y: 50.02), controlPoint2: CGPoint(x: 87.67, y: 50.02))
        bezier6Path.addCurve(to: CGPoint(x: 86.23, y: 48.1), controlPoint1: CGPoint(x: 87.67, y: 50.02), controlPoint2: CGPoint(x: 86.47, y: 48.82))
        bezier6Path.addCurve(to: CGPoint(x: 84.31, y: 47.14), controlPoint1: CGPoint(x: 85.63, y: 47.98), controlPoint2: CGPoint(x: 84.31, y: 47.14))
        bezier6Path.addCurve(to: CGPoint(x: 81.67, y: 46.42), controlPoint1: CGPoint(x: 84.31, y: 47.14), controlPoint2: CGPoint(x: 82.63, y: 46.9))
        bezier6Path.addCurve(to: CGPoint(x: 78.78, y: 46.42), controlPoint1: CGPoint(x: 80.83, y: 46.54), controlPoint2: CGPoint(x: 79.99, y: 46.66))
        bezier6Path.addCurve(to: CGPoint(x: 75.18, y: 47.38), controlPoint1: CGPoint(x: 77.46, y: 47.02), controlPoint2: CGPoint(x: 76.62, y: 47.14))
        bezier6Path.addCurve(to: CGPoint(x: 72.78, y: 49.54), controlPoint1: CGPoint(x: 74.46, y: 48.46), controlPoint2: CGPoint(x: 73.5, y: 49.06))
        bezier6Path.addCurve(to: CGPoint(x: 72.3, y: 52.66), controlPoint1: CGPoint(x: 72.9, y: 50.98), controlPoint2: CGPoint(x: 72.3, y: 52.66))
        color7.setFill()
        bezier6Path.fill()
        color9.setStroke()
        bezier6Path.lineWidth = 1
        bezier6Path.stroke()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 69.66, y: 48.58))
        bezier7Path.addLine(to: CGPoint(x: 75.18, y: 47.38))
        color9.setStroke()
        bezier7Path.lineWidth = 1
        bezier7Path.stroke()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 69.18, y: 52.66))
        bezier8Path.addLine(to: CGPoint(x: 72.78, y: 49.54))
        color9.setStroke()
        bezier8Path.lineWidth = 1
        bezier8Path.stroke()
        
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 52, y: 60, width: 36, height: 36))
        UIColor.gray.setFill()
        oval2Path.fill()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: 65.69, y: 61.18))
        bezier9Path.addLine(to: CGPoint(x: 65.69, y: 54.94))
        bezier9Path.addCurve(to: CGPoint(x: 70.5, y: 52.3), controlPoint1: CGPoint(x: 65.69, y: 54.94), controlPoint2: CGPoint(x: 65.93, y: 52.3))
        bezier9Path.addCurve(to: CGPoint(x: 75.78, y: 54.94), controlPoint1: CGPoint(x: 75.06, y: 52.3), controlPoint2: CGPoint(x: 75.78, y: 54.94))
        bezier9Path.addLine(to: CGPoint(x: 75.78, y: 61.18))
        UIColor.gray.setFill()
        bezier9Path.fill()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: 72.3, y: 45.46))
        bezier10Path.addLine(to: CGPoint(x: 78.78, y: 46.42))
        color9.setStroke()
        bezier10Path.lineWidth = 1
        bezier10Path.stroke()
        
        
        //// Bezier 11 Drawing
        let bezier11Path = UIBezierPath()
        bezier11Path.move(to: CGPoint(x: 75.66, y: 44.02))
        bezier11Path.addLine(to: CGPoint(x: 81.67, y: 46.42))
        color9.setStroke()
        bezier11Path.lineWidth = 1
        bezier11Path.stroke()
        
        
        //// Bezier 12 Drawing
        let bezier12Path = UIBezierPath()
        bezier12Path.move(to: CGPoint(x: 79.99, y: 43.54))
        bezier12Path.addLine(to: CGPoint(x: 84.31, y: 47.14))
        color9.setStroke()
        bezier12Path.lineWidth = 1
        bezier12Path.stroke()
        
        
        //// Bezier 13 Drawing
        let bezier13Path = UIBezierPath()
        bezier13Path.move(to: CGPoint(x: 84.07, y: 44.02))
        bezier13Path.addLine(to: CGPoint(x: 86.23, y: 48.1))
        color9.setStroke()
        bezier13Path.lineWidth = 1
        bezier13Path.stroke()
        
        
        //// Bezier 14 Drawing
        let bezier14Path = UIBezierPath()
        bezier14Path.move(to: CGPoint(x: 88.87, y: 46.9))
        bezier14Path.addLine(to: CGPoint(x: 87.67, y: 50.02))
        color9.setStroke()
        bezier14Path.lineWidth = 1
        bezier14Path.stroke()
        
        
        //// Bezier 15 Drawing
        let bezier15Path = UIBezierPath()
        bezier15Path.move(to: CGPoint(x: 86.95, y: 45.46))
        bezier15Path.addLine(to: CGPoint(x: 87.67, y: 50.02))
        color9.setStroke()
        bezier15Path.lineWidth = 1
        bezier15Path.stroke()
        
        
        //// Bezier 16 Drawing
        context.saveGState()
        context.translateBy(x: 59.24, y: 29.53)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier16Path = UIBezierPath()
        bezier16Path.move(to: CGPoint(x: 34.22, y: -2.48))
        bezier16Path.addCurve(to: CGPoint(x: 34.85, y: -6.21), controlPoint1: CGPoint(x: 30.2, y: -7.68), controlPoint2: CGPoint(x: 29.53, y: -11.02))
        bezier16Path.addCurve(to: CGPoint(x: 36.57, y: -0.33), controlPoint1: CGPoint(x: 41.76, y: 0.05), controlPoint2: CGPoint(x: 36.57, y: -0.33))
        bezier16Path.addCurve(to: CGPoint(x: 34.22, y: -2.48), controlPoint1: CGPoint(x: 36.57, y: -0.33), controlPoint2: CGPoint(x: 35.43, y: -0.91))
        bezier16Path.close()
        context.saveGState()
        bezier16Path.addClip()
        context.drawLinearGradient(gradient3, start: CGPoint(x: 35.58, y: -5.53), end: CGPoint(x: 33.32, y: -3.26), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(BonusDrawResizingBehavior)
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
