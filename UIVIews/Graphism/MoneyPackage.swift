//
//  MoneyPackage.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class MoneyPackage: UIView {
    
    enum PackageSize: Int {
        case small = 0
        case medium = 1
        case large = 2
    }
    
    // La taille du pack, change son visuel et la quantité d'argent
    var size: PackageSize = .small
    
    override func draw(_ rect: CGRect) {
        
        switch size {
        case .small:
            MoneyPacks.drawSmallPack(frame: rect, resizing: .aspectFill)
            
        case .medium:
            MoneyPacks.drawMediumPack(frame: rect, resizing: .aspectFill)
            
        case .large:
            MoneyPacks.drawLargePack(frame: rect, resizing: .aspectFill)
            
        }
        
    }
    
}

public class MoneyPacks : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawSmallPack(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 140, height: 140), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 140, height: 140), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 140, y: resizedFrame.height / 140)
        
        
        //// Color Declarations
        let gradientColor = UIColor(red: 0.546, green: 0.541, blue: 0.541, alpha: 1.000)
        let color10 = UIColor(red: 1.000, green: 0.848, blue: 0.000, alpha: 1.000)
        let gradientColor2 = UIColor(red: 0.874, green: 0.829, blue: 0.688, alpha: 1.000)
        let color11 = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        let gradientColor3 = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        let color12 = UIColor(red: 1.000, green: 0.746, blue: 0.000, alpha: 1.000)
        let color13 = UIColor(red: 0.533, green: 0.368, blue: 0.000, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient4 = CGGradient(colorsSpace: nil, colors: [gradientColor3.cgColor, gradientColor3.blended(withFraction: 0.5, of: gradientColor2).cgColor, gradientColor2.cgColor] as CFArray, locations: [0, 0.72, 1])!
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 2.26, y: 1.71, width: 136, height: 136), cornerRadius: 4)
        gradientColor.setStroke()
        rectanglePath.lineWidth = 3
        rectanglePath.stroke()
        
        
        //// Coin
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 30, y: 30, width: 80, height: 80))
        color12.setFill()
        ovalPath.fill()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 48.45, y: 50.68))
        bezier3Path.addCurve(to: CGPoint(x: 53.27, y: 36.46), controlPoint1: CGPoint(x: 57.9, y: 37.2), controlPoint2: CGPoint(x: 66.45, y: 31.03))
        bezier3Path.addCurve(to: CGPoint(x: 38.62, y: 49.6), controlPoint1: CGPoint(x: 47.59, y: 38.81), controlPoint2: CGPoint(x: 40.68, y: 45.91))
        bezier3Path.addCurve(to: CGPoint(x: 34.36, y: 75.15), controlPoint1: CGPoint(x: 30.4, y: 64.38), controlPoint2: CGPoint(x: 30.11, y: 78.54))
        bezier3Path.addCurve(to: CGPoint(x: 48.45, y: 50.68), controlPoint1: CGPoint(x: 36.15, y: 73.73), controlPoint2: CGPoint(x: 41.6, y: 60.46))
        bezier3Path.close()
        color10.setFill()
        bezier3Path.fill()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 68.27, y: 54.43))
        bezier4Path.addCurve(to: CGPoint(x: 68.8, y: 50.43), controlPoint1: CGPoint(x: 68.27, y: 54.43), controlPoint2: CGPoint(x: 67.74, y: 51.01))
        bezier4Path.addCurve(to: CGPoint(x: 71.73, y: 47.36), controlPoint1: CGPoint(x: 68.54, y: 49.72), controlPoint2: CGPoint(x: 70.8, y: 47.36))
        bezier4Path.addCurve(to: CGPoint(x: 75.45, y: 45.95), controlPoint1: CGPoint(x: 71.99, y: 46.66), controlPoint2: CGPoint(x: 74.65, y: 45.71))
        bezier4Path.addCurve(to: CGPoint(x: 80.23, y: 45.48), controlPoint1: CGPoint(x: 75.98, y: 45.13), controlPoint2: CGPoint(x: 79.43, y: 45.01))
        bezier4Path.addCurve(to: CGPoint(x: 84.75, y: 45.95), controlPoint1: CGPoint(x: 81.03, y: 44.77), controlPoint2: CGPoint(x: 84.48, y: 45.48))
        bezier4Path.addCurve(to: CGPoint(x: 87.94, y: 47.36), controlPoint1: CGPoint(x: 85.55, y: 45.6), controlPoint2: CGPoint(x: 88.2, y: 46.66))
        bezier4Path.addCurve(to: CGPoint(x: 90.06, y: 48.78), controlPoint1: CGPoint(x: 88.74, y: 47.36), controlPoint2: CGPoint(x: 90.06, y: 48.07))
        bezier4Path.addCurve(to: CGPoint(x: 90.86, y: 51.37), controlPoint1: CGPoint(x: 90.73, y: 48.78), controlPoint2: CGPoint(x: 90.99, y: 50.66))
        bezier4Path.addCurve(to: CGPoint(x: 88.74, y: 51.84), controlPoint1: CGPoint(x: 90.33, y: 51.84), controlPoint2: CGPoint(x: 88.74, y: 51.84))
        bezier4Path.addCurve(to: CGPoint(x: 87.14, y: 49.95), controlPoint1: CGPoint(x: 88.74, y: 51.84), controlPoint2: CGPoint(x: 87.41, y: 50.66))
        bezier4Path.addCurve(to: CGPoint(x: 85.02, y: 49.01), controlPoint1: CGPoint(x: 86.48, y: 49.84), controlPoint2: CGPoint(x: 85.02, y: 49.01))
        bezier4Path.addCurve(to: CGPoint(x: 82.09, y: 48.31), controlPoint1: CGPoint(x: 85.02, y: 49.01), controlPoint2: CGPoint(x: 83.15, y: 48.78))
        bezier4Path.addCurve(to: CGPoint(x: 78.9, y: 48.31), controlPoint1: CGPoint(x: 81.16, y: 48.42), controlPoint2: CGPoint(x: 80.23, y: 48.54))
        bezier4Path.addCurve(to: CGPoint(x: 74.92, y: 49.25), controlPoint1: CGPoint(x: 77.44, y: 48.89), controlPoint2: CGPoint(x: 76.51, y: 49.01))
        bezier4Path.addCurve(to: CGPoint(x: 72.26, y: 51.37), controlPoint1: CGPoint(x: 74.12, y: 50.31), controlPoint2: CGPoint(x: 73.06, y: 50.9))
        bezier4Path.addCurve(to: CGPoint(x: 71.73, y: 54.43), controlPoint1: CGPoint(x: 72.39, y: 52.78), controlPoint2: CGPoint(x: 71.73, y: 54.43))
        color11.setFill()
        bezier4Path.fill()
        color13.setStroke()
        bezier4Path.lineWidth = 1
        bezier4Path.stroke()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 68.8, y: 50.43))
        bezier5Path.addLine(to: CGPoint(x: 74.92, y: 49.25))
        color13.setStroke()
        bezier5Path.lineWidth = 1
        bezier5Path.stroke()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 68.27, y: 54.43))
        bezier6Path.addLine(to: CGPoint(x: 72.26, y: 51.37))
        color13.setStroke()
        bezier6Path.lineWidth = 1
        bezier6Path.stroke()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: 49.27, y: 60.95, width: 39, height: 36))
        color11.setFill()
        oval3Path.fill()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 64.42, y: 62.79))
        bezier7Path.addLine(to: CGPoint(x: 64.42, y: 56.67))
        bezier7Path.addCurve(to: CGPoint(x: 69.73, y: 54.08), controlPoint1: CGPoint(x: 64.42, y: 56.67), controlPoint2: CGPoint(x: 64.68, y: 54.08))
        bezier7Path.addCurve(to: CGPoint(x: 75.58, y: 56.67), controlPoint1: CGPoint(x: 74.78, y: 54.08), controlPoint2: CGPoint(x: 75.58, y: 56.67))
        bezier7Path.addLine(to: CGPoint(x: 75.58, y: 62.79))
        color11.setFill()
        bezier7Path.fill()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 71.73, y: 47.36))
        bezier8Path.addLine(to: CGPoint(x: 78.9, y: 48.31))
        color13.setStroke()
        bezier8Path.lineWidth = 1
        bezier8Path.stroke()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: 75.45, y: 45.95))
        bezier9Path.addLine(to: CGPoint(x: 82.09, y: 48.31))
        color13.setStroke()
        bezier9Path.lineWidth = 1
        bezier9Path.stroke()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: 80.23, y: 45.48))
        bezier10Path.addLine(to: CGPoint(x: 85.02, y: 49.01))
        color13.setStroke()
        bezier10Path.lineWidth = 1
        bezier10Path.stroke()
        
        
        //// Bezier 11 Drawing
        let bezier11Path = UIBezierPath()
        bezier11Path.move(to: CGPoint(x: 84.75, y: 45.95))
        bezier11Path.addLine(to: CGPoint(x: 87.14, y: 49.95))
        color13.setStroke()
        bezier11Path.lineWidth = 1
        bezier11Path.stroke()
        
        
        //// Bezier 12 Drawing
        let bezier12Path = UIBezierPath()
        bezier12Path.move(to: CGPoint(x: 90.06, y: 48.78))
        bezier12Path.addLine(to: CGPoint(x: 88.74, y: 51.84))
        color13.setStroke()
        bezier12Path.lineWidth = 1
        bezier12Path.stroke()
        
        
        //// Bezier 13 Drawing
        let bezier13Path = UIBezierPath()
        bezier13Path.move(to: CGPoint(x: 87.94, y: 47.36))
        bezier13Path.addLine(to: CGPoint(x: 88.74, y: 51.84))
        color13.setStroke()
        bezier13Path.lineWidth = 1
        bezier13Path.stroke()
        
        
        //// Bezier 14 Drawing
        context.saveGState()
        context.translateBy(x: 57.1, y: 31.15)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier14Path = UIBezierPath()
        bezier14Path.move(to: CGPoint(x: 34.14, y: -2.69))
        bezier14Path.addCurve(to: CGPoint(x: 34.74, y: -6.79), controlPoint1: CGPoint(x: 30.22, y: -8.4), controlPoint2: CGPoint(x: 29.57, y: -12.08))
        bezier14Path.addCurve(to: CGPoint(x: 36.42, y: -0.33), controlPoint1: CGPoint(x: 41.47, y: 0.09), controlPoint2: CGPoint(x: 36.42, y: -0.33))
        bezier14Path.addCurve(to: CGPoint(x: 34.14, y: -2.69), controlPoint1: CGPoint(x: 36.42, y: -0.33), controlPoint2: CGPoint(x: 35.31, y: -0.97))
        bezier14Path.close()
        context.saveGState()
        bezier14Path.addClip()
        context.drawLinearGradient(gradient4, start: CGPoint(x: 35.53, y: -6), end: CGPoint(x: 33.05, y: -3.51), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    @objc dynamic public class func drawMediumPack(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 140, height: 140), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 140, height: 140), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 140, y: resizedFrame.height / 140)
        
        
        //// Color Declarations
        let gradientColor = UIColor(red: 0.546, green: 0.541, blue: 0.541, alpha: 1.000)
        let color10 = UIColor(red: 1.000, green: 0.848, blue: 0.000, alpha: 1.000)
        let gradientColor2 = UIColor(red: 0.874, green: 0.829, blue: 0.688, alpha: 1.000)
        let color11 = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        let gradientColor3 = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        let color12 = UIColor(red: 1.000, green: 0.746, blue: 0.000, alpha: 1.000)
        let color13 = UIColor(red: 0.533, green: 0.368, blue: 0.000, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient4 = CGGradient(colorsSpace: nil, colors: [gradientColor3.cgColor, gradientColor3.blended(withFraction: 0.5, of: gradientColor2).cgColor, gradientColor2.cgColor] as CFArray, locations: [0, 0.72, 1])!
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 2.13, y: 1.7, width: 136, height: 136), cornerRadius: 4)
        gradientColor.setStroke()
        rectanglePath.lineWidth = 3
        rectanglePath.stroke()
        
        
        //// Coin
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 12, y: 69, width: 54, height: 54))
        color12.setFill()
        ovalPath.fill()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 24.46, y: 82.96))
        bezier3Path.addCurve(to: CGPoint(x: 27.71, y: 73.36), controlPoint1: CGPoint(x: 30.83, y: 73.86), controlPoint2: CGPoint(x: 36.6, y: 69.7))
        bezier3Path.addCurve(to: CGPoint(x: 17.82, y: 82.23), controlPoint1: CGPoint(x: 23.87, y: 74.94), controlPoint2: CGPoint(x: 19.21, y: 79.74))
        bezier3Path.addCurve(to: CGPoint(x: 14.94, y: 99.48), controlPoint1: CGPoint(x: 12.27, y: 92.21), controlPoint2: CGPoint(x: 12.07, y: 101.77))
        bezier3Path.addCurve(to: CGPoint(x: 24.46, y: 82.96), controlPoint1: CGPoint(x: 16.15, y: 98.52), controlPoint2: CGPoint(x: 19.83, y: 89.56))
        bezier3Path.close()
        color10.setFill()
        bezier3Path.fill()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 37.83, y: 85.49))
        bezier4Path.addCurve(to: CGPoint(x: 38.19, y: 82.79), controlPoint1: CGPoint(x: 37.83, y: 85.49), controlPoint2: CGPoint(x: 37.47, y: 83.18))
        bezier4Path.addCurve(to: CGPoint(x: 40.17, y: 80.72), controlPoint1: CGPoint(x: 38.01, y: 82.31), controlPoint2: CGPoint(x: 39.54, y: 80.72))
        bezier4Path.addCurve(to: CGPoint(x: 42.68, y: 79.77), controlPoint1: CGPoint(x: 40.35, y: 80.24), controlPoint2: CGPoint(x: 42.14, y: 79.61))
        bezier4Path.addCurve(to: CGPoint(x: 45.91, y: 79.45), controlPoint1: CGPoint(x: 43.04, y: 79.21), controlPoint2: CGPoint(x: 45.37, y: 79.13))
        bezier4Path.addCurve(to: CGPoint(x: 48.96, y: 79.77), controlPoint1: CGPoint(x: 46.44, y: 78.97), controlPoint2: CGPoint(x: 48.78, y: 79.45))
        bezier4Path.addCurve(to: CGPoint(x: 51.11, y: 80.72), controlPoint1: CGPoint(x: 49.49, y: 79.53), controlPoint2: CGPoint(x: 51.29, y: 80.24))
        bezier4Path.addCurve(to: CGPoint(x: 52.54, y: 81.67), controlPoint1: CGPoint(x: 51.65, y: 80.72), controlPoint2: CGPoint(x: 52.54, y: 81.2))
        bezier4Path.addCurve(to: CGPoint(x: 53.08, y: 83.42), controlPoint1: CGPoint(x: 52.99, y: 81.67), controlPoint2: CGPoint(x: 53.17, y: 82.95))
        bezier4Path.addCurve(to: CGPoint(x: 51.65, y: 83.74), controlPoint1: CGPoint(x: 52.72, y: 83.74), controlPoint2: CGPoint(x: 51.65, y: 83.74))
        bezier4Path.addCurve(to: CGPoint(x: 50.57, y: 82.47), controlPoint1: CGPoint(x: 51.65, y: 83.74), controlPoint2: CGPoint(x: 50.75, y: 82.95))
        bezier4Path.addCurve(to: CGPoint(x: 49.14, y: 81.83), controlPoint1: CGPoint(x: 50.12, y: 82.39), controlPoint2: CGPoint(x: 49.14, y: 81.83))
        bezier4Path.addCurve(to: CGPoint(x: 47.16, y: 81.36), controlPoint1: CGPoint(x: 49.14, y: 81.83), controlPoint2: CGPoint(x: 47.88, y: 81.67))
        bezier4Path.addCurve(to: CGPoint(x: 45.01, y: 81.36), controlPoint1: CGPoint(x: 46.53, y: 81.44), controlPoint2: CGPoint(x: 45.91, y: 81.51))
        bezier4Path.addCurve(to: CGPoint(x: 42.32, y: 81.99), controlPoint1: CGPoint(x: 44.02, y: 81.75), controlPoint2: CGPoint(x: 43.39, y: 81.83))
        bezier4Path.addCurve(to: CGPoint(x: 40.52, y: 83.42), controlPoint1: CGPoint(x: 41.78, y: 82.71), controlPoint2: CGPoint(x: 41.06, y: 83.1))
        bezier4Path.addCurve(to: CGPoint(x: 40.17, y: 85.49), controlPoint1: CGPoint(x: 40.61, y: 84.38), controlPoint2: CGPoint(x: 40.17, y: 85.49))
        color11.setFill()
        bezier4Path.fill()
        color13.setStroke()
        bezier4Path.lineWidth = 1
        bezier4Path.stroke()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 38.19, y: 82.79))
        bezier5Path.addLine(to: CGPoint(x: 42.32, y: 81.99))
        color13.setStroke()
        bezier5Path.lineWidth = 1
        bezier5Path.stroke()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 37.83, y: 85.49))
        bezier6Path.addLine(to: CGPoint(x: 40.52, y: 83.42))
        color13.setStroke()
        bezier6Path.lineWidth = 1
        bezier6Path.stroke()
        
        
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: 25.27, y: 89.95, width: 26, height: 24))
        color11.setFill()
        oval3Path.fill()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 35.23, y: 91.13))
        bezier7Path.addLine(to: CGPoint(x: 35.23, y: 87))
        bezier7Path.addCurve(to: CGPoint(x: 38.82, y: 85.25), controlPoint1: CGPoint(x: 35.23, y: 87), controlPoint2: CGPoint(x: 35.41, y: 85.25))
        bezier7Path.addCurve(to: CGPoint(x: 42.77, y: 87), controlPoint1: CGPoint(x: 42.23, y: 85.25), controlPoint2: CGPoint(x: 42.77, y: 87))
        bezier7Path.addLine(to: CGPoint(x: 42.77, y: 91.13))
        color11.setFill()
        bezier7Path.fill()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 40.17, y: 80.72))
        bezier8Path.addLine(to: CGPoint(x: 45.01, y: 81.36))
        color13.setStroke()
        bezier8Path.lineWidth = 1
        bezier8Path.stroke()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: 42.68, y: 79.77))
        bezier9Path.addLine(to: CGPoint(x: 47.16, y: 81.36))
        color13.setStroke()
        bezier9Path.lineWidth = 1
        bezier9Path.stroke()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: 45.91, y: 79.45))
        bezier10Path.addLine(to: CGPoint(x: 49.14, y: 81.83))
        color13.setStroke()
        bezier10Path.lineWidth = 1
        bezier10Path.stroke()
        
        
        //// Bezier 11 Drawing
        let bezier11Path = UIBezierPath()
        bezier11Path.move(to: CGPoint(x: 48.96, y: 79.77))
        bezier11Path.addLine(to: CGPoint(x: 50.57, y: 82.47))
        color13.setStroke()
        bezier11Path.lineWidth = 1
        bezier11Path.stroke()
        
        
        //// Bezier 12 Drawing
        let bezier12Path = UIBezierPath()
        bezier12Path.move(to: CGPoint(x: 52.54, y: 81.67))
        bezier12Path.addLine(to: CGPoint(x: 51.65, y: 83.74))
        color13.setStroke()
        bezier12Path.lineWidth = 1
        bezier12Path.stroke()
        
        
        //// Bezier 13 Drawing
        let bezier13Path = UIBezierPath()
        bezier13Path.move(to: CGPoint(x: 51.11, y: 80.72))
        bezier13Path.addLine(to: CGPoint(x: 51.65, y: 83.74))
        color13.setStroke()
        bezier13Path.lineWidth = 1
        bezier13Path.stroke()
        
        
        //// Bezier 14 Drawing
        context.saveGState()
        context.translateBy(x: 30.85, y: 59.71)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier14Path = UIBezierPath()
        bezier14Path.move(to: CGPoint(x: 33.13, y: -1.92))
        bezier14Path.addCurve(to: CGPoint(x: 33.54, y: -4.69), controlPoint1: CGPoint(x: 30.49, y: -5.78), controlPoint2: CGPoint(x: 30.05, y: -8.26))
        bezier14Path.addCurve(to: CGPoint(x: 34.67, y: -0.33), controlPoint1: CGPoint(x: 38.08, y: -0.04), controlPoint2: CGPoint(x: 34.67, y: -0.33))
        bezier14Path.addCurve(to: CGPoint(x: 33.13, y: -1.92), controlPoint1: CGPoint(x: 34.67, y: -0.33), controlPoint2: CGPoint(x: 33.92, y: -0.76))
        bezier14Path.close()
        context.saveGState()
        bezier14Path.addClip()
        context.drawLinearGradient(gradient4, start: CGPoint(x: 34.07, y: -4.15), end: CGPoint(x: 32.39, y: -2.48), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        
        
        
        //// Coin 3
        //// Oval 5 Drawing
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: 74, y: 69, width: 54, height: 54))
        color12.setFill()
        oval5Path.fill()
        
        
        //// Bezier 25 Drawing
        let bezier25Path = UIBezierPath()
        bezier25Path.move(to: CGPoint(x: 86.46, y: 82.96))
        bezier25Path.addCurve(to: CGPoint(x: 89.71, y: 73.36), controlPoint1: CGPoint(x: 92.83, y: 73.86), controlPoint2: CGPoint(x: 98.6, y: 69.7))
        bezier25Path.addCurve(to: CGPoint(x: 79.82, y: 82.23), controlPoint1: CGPoint(x: 85.87, y: 74.94), controlPoint2: CGPoint(x: 81.21, y: 79.74))
        bezier25Path.addCurve(to: CGPoint(x: 76.94, y: 99.48), controlPoint1: CGPoint(x: 74.27, y: 92.21), controlPoint2: CGPoint(x: 74.07, y: 101.77))
        bezier25Path.addCurve(to: CGPoint(x: 86.46, y: 82.96), controlPoint1: CGPoint(x: 78.15, y: 98.52), controlPoint2: CGPoint(x: 81.83, y: 89.56))
        bezier25Path.close()
        color10.setFill()
        bezier25Path.fill()
        
        
        //// Bezier 26 Drawing
        let bezier26Path = UIBezierPath()
        bezier26Path.move(to: CGPoint(x: 99.83, y: 85.49))
        bezier26Path.addCurve(to: CGPoint(x: 100.19, y: 82.79), controlPoint1: CGPoint(x: 99.83, y: 85.49), controlPoint2: CGPoint(x: 99.47, y: 83.18))
        bezier26Path.addCurve(to: CGPoint(x: 102.17, y: 80.72), controlPoint1: CGPoint(x: 100.01, y: 82.31), controlPoint2: CGPoint(x: 101.54, y: 80.72))
        bezier26Path.addCurve(to: CGPoint(x: 104.68, y: 79.77), controlPoint1: CGPoint(x: 102.35, y: 80.24), controlPoint2: CGPoint(x: 104.14, y: 79.61))
        bezier26Path.addCurve(to: CGPoint(x: 107.91, y: 79.45), controlPoint1: CGPoint(x: 105.04, y: 79.21), controlPoint2: CGPoint(x: 107.37, y: 79.13))
        bezier26Path.addCurve(to: CGPoint(x: 110.96, y: 79.77), controlPoint1: CGPoint(x: 108.44, y: 78.97), controlPoint2: CGPoint(x: 110.78, y: 79.45))
        bezier26Path.addCurve(to: CGPoint(x: 113.11, y: 80.72), controlPoint1: CGPoint(x: 111.49, y: 79.53), controlPoint2: CGPoint(x: 113.29, y: 80.24))
        bezier26Path.addCurve(to: CGPoint(x: 114.54, y: 81.67), controlPoint1: CGPoint(x: 113.65, y: 80.72), controlPoint2: CGPoint(x: 114.54, y: 81.2))
        bezier26Path.addCurve(to: CGPoint(x: 115.08, y: 83.42), controlPoint1: CGPoint(x: 114.99, y: 81.67), controlPoint2: CGPoint(x: 115.17, y: 82.95))
        bezier26Path.addCurve(to: CGPoint(x: 113.65, y: 83.74), controlPoint1: CGPoint(x: 114.72, y: 83.74), controlPoint2: CGPoint(x: 113.65, y: 83.74))
        bezier26Path.addCurve(to: CGPoint(x: 112.57, y: 82.47), controlPoint1: CGPoint(x: 113.65, y: 83.74), controlPoint2: CGPoint(x: 112.75, y: 82.95))
        bezier26Path.addCurve(to: CGPoint(x: 111.14, y: 81.83), controlPoint1: CGPoint(x: 112.12, y: 82.39), controlPoint2: CGPoint(x: 111.14, y: 81.83))
        bezier26Path.addCurve(to: CGPoint(x: 109.16, y: 81.36), controlPoint1: CGPoint(x: 111.14, y: 81.83), controlPoint2: CGPoint(x: 109.88, y: 81.67))
        bezier26Path.addCurve(to: CGPoint(x: 107.01, y: 81.36), controlPoint1: CGPoint(x: 108.53, y: 81.44), controlPoint2: CGPoint(x: 107.91, y: 81.51))
        bezier26Path.addCurve(to: CGPoint(x: 104.32, y: 81.99), controlPoint1: CGPoint(x: 106.02, y: 81.75), controlPoint2: CGPoint(x: 105.39, y: 81.83))
        bezier26Path.addCurve(to: CGPoint(x: 102.52, y: 83.42), controlPoint1: CGPoint(x: 103.78, y: 82.71), controlPoint2: CGPoint(x: 103.06, y: 83.1))
        bezier26Path.addCurve(to: CGPoint(x: 102.17, y: 85.49), controlPoint1: CGPoint(x: 102.61, y: 84.38), controlPoint2: CGPoint(x: 102.17, y: 85.49))
        color11.setFill()
        bezier26Path.fill()
        color13.setStroke()
        bezier26Path.lineWidth = 1
        bezier26Path.stroke()
        
        
        //// Bezier 27 Drawing
        let bezier27Path = UIBezierPath()
        bezier27Path.move(to: CGPoint(x: 100.19, y: 82.79))
        bezier27Path.addLine(to: CGPoint(x: 104.32, y: 81.99))
        color13.setStroke()
        bezier27Path.lineWidth = 1
        bezier27Path.stroke()
        
        
        //// Bezier 28 Drawing
        let bezier28Path = UIBezierPath()
        bezier28Path.move(to: CGPoint(x: 99.83, y: 85.49))
        bezier28Path.addLine(to: CGPoint(x: 102.52, y: 83.42))
        color13.setStroke()
        bezier28Path.lineWidth = 1
        bezier28Path.stroke()
        
        
        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: 87.27, y: 89.95, width: 26, height: 24))
        color11.setFill()
        oval6Path.fill()
        
        
        //// Bezier 29 Drawing
        let bezier29Path = UIBezierPath()
        bezier29Path.move(to: CGPoint(x: 97.23, y: 91.13))
        bezier29Path.addLine(to: CGPoint(x: 97.23, y: 87))
        bezier29Path.addCurve(to: CGPoint(x: 100.82, y: 85.25), controlPoint1: CGPoint(x: 97.23, y: 87), controlPoint2: CGPoint(x: 97.41, y: 85.25))
        bezier29Path.addCurve(to: CGPoint(x: 104.77, y: 87), controlPoint1: CGPoint(x: 104.23, y: 85.25), controlPoint2: CGPoint(x: 104.77, y: 87))
        bezier29Path.addLine(to: CGPoint(x: 104.77, y: 91.13))
        color11.setFill()
        bezier29Path.fill()
        
        
        //// Bezier 30 Drawing
        let bezier30Path = UIBezierPath()
        bezier30Path.move(to: CGPoint(x: 102.17, y: 80.72))
        bezier30Path.addLine(to: CGPoint(x: 107.01, y: 81.36))
        color13.setStroke()
        bezier30Path.lineWidth = 1
        bezier30Path.stroke()
        
        
        //// Bezier 31 Drawing
        let bezier31Path = UIBezierPath()
        bezier31Path.move(to: CGPoint(x: 104.68, y: 79.77))
        bezier31Path.addLine(to: CGPoint(x: 109.16, y: 81.36))
        color13.setStroke()
        bezier31Path.lineWidth = 1
        bezier31Path.stroke()
        
        
        //// Bezier 32 Drawing
        let bezier32Path = UIBezierPath()
        bezier32Path.move(to: CGPoint(x: 107.91, y: 79.45))
        bezier32Path.addLine(to: CGPoint(x: 111.14, y: 81.83))
        color13.setStroke()
        bezier32Path.lineWidth = 1
        bezier32Path.stroke()
        
        
        //// Bezier 33 Drawing
        let bezier33Path = UIBezierPath()
        bezier33Path.move(to: CGPoint(x: 110.96, y: 79.77))
        bezier33Path.addLine(to: CGPoint(x: 112.57, y: 82.47))
        color13.setStroke()
        bezier33Path.lineWidth = 1
        bezier33Path.stroke()
        
        
        //// Bezier 34 Drawing
        let bezier34Path = UIBezierPath()
        bezier34Path.move(to: CGPoint(x: 114.54, y: 81.67))
        bezier34Path.addLine(to: CGPoint(x: 113.65, y: 83.74))
        color13.setStroke()
        bezier34Path.lineWidth = 1
        bezier34Path.stroke()
        
        
        //// Bezier 35 Drawing
        let bezier35Path = UIBezierPath()
        bezier35Path.move(to: CGPoint(x: 113.11, y: 80.72))
        bezier35Path.addLine(to: CGPoint(x: 113.65, y: 83.74))
        color13.setStroke()
        bezier35Path.lineWidth = 1
        bezier35Path.stroke()
        
        
        //// Bezier 36 Drawing
        context.saveGState()
        context.translateBy(x: 92.85, y: 59.71)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier36Path = UIBezierPath()
        bezier36Path.move(to: CGPoint(x: 33.13, y: -1.92))
        bezier36Path.addCurve(to: CGPoint(x: 33.54, y: -4.69), controlPoint1: CGPoint(x: 30.49, y: -5.78), controlPoint2: CGPoint(x: 30.05, y: -8.26))
        bezier36Path.addCurve(to: CGPoint(x: 34.67, y: -0.33), controlPoint1: CGPoint(x: 38.08, y: -0.04), controlPoint2: CGPoint(x: 34.67, y: -0.33))
        bezier36Path.addCurve(to: CGPoint(x: 33.13, y: -1.92), controlPoint1: CGPoint(x: 34.67, y: -0.33), controlPoint2: CGPoint(x: 33.92, y: -0.76))
        bezier36Path.close()
        context.saveGState()
        bezier36Path.addClip()
        context.drawLinearGradient(gradient4, start: CGPoint(x: 34.07, y: -4.15), end: CGPoint(x: 32.39, y: -2.48), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        
        
        
        //// Coin 2
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 43, y: 15, width: 54, height: 54))
        color12.setFill()
        oval2Path.fill()
        
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 55.46, y: 28.96))
        bezierPath.addCurve(to: CGPoint(x: 58.71, y: 19.36), controlPoint1: CGPoint(x: 61.83, y: 19.86), controlPoint2: CGPoint(x: 67.6, y: 15.7))
        bezierPath.addCurve(to: CGPoint(x: 48.82, y: 28.23), controlPoint1: CGPoint(x: 54.87, y: 20.94), controlPoint2: CGPoint(x: 50.21, y: 25.74))
        bezierPath.addCurve(to: CGPoint(x: 45.94, y: 45.48), controlPoint1: CGPoint(x: 43.27, y: 38.21), controlPoint2: CGPoint(x: 43.07, y: 47.77))
        bezierPath.addCurve(to: CGPoint(x: 55.46, y: 28.96), controlPoint1: CGPoint(x: 47.15, y: 44.52), controlPoint2: CGPoint(x: 50.83, y: 35.56))
        bezierPath.close()
        color10.setFill()
        bezierPath.fill()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 68.83, y: 31.49))
        bezier2Path.addCurve(to: CGPoint(x: 69.19, y: 28.79), controlPoint1: CGPoint(x: 68.83, y: 31.49), controlPoint2: CGPoint(x: 68.47, y: 29.18))
        bezier2Path.addCurve(to: CGPoint(x: 71.17, y: 26.72), controlPoint1: CGPoint(x: 69.01, y: 28.31), controlPoint2: CGPoint(x: 70.54, y: 26.72))
        bezier2Path.addCurve(to: CGPoint(x: 73.68, y: 25.77), controlPoint1: CGPoint(x: 71.35, y: 26.24), controlPoint2: CGPoint(x: 73.14, y: 25.61))
        bezier2Path.addCurve(to: CGPoint(x: 76.91, y: 25.45), controlPoint1: CGPoint(x: 74.04, y: 25.21), controlPoint2: CGPoint(x: 76.37, y: 25.13))
        bezier2Path.addCurve(to: CGPoint(x: 79.96, y: 25.77), controlPoint1: CGPoint(x: 77.44, y: 24.97), controlPoint2: CGPoint(x: 79.78, y: 25.45))
        bezier2Path.addCurve(to: CGPoint(x: 82.11, y: 26.72), controlPoint1: CGPoint(x: 80.49, y: 25.53), controlPoint2: CGPoint(x: 82.29, y: 26.24))
        bezier2Path.addCurve(to: CGPoint(x: 83.54, y: 27.67), controlPoint1: CGPoint(x: 82.65, y: 26.72), controlPoint2: CGPoint(x: 83.54, y: 27.2))
        bezier2Path.addCurve(to: CGPoint(x: 84.08, y: 29.42), controlPoint1: CGPoint(x: 83.99, y: 27.67), controlPoint2: CGPoint(x: 84.17, y: 28.95))
        bezier2Path.addCurve(to: CGPoint(x: 82.65, y: 29.74), controlPoint1: CGPoint(x: 83.72, y: 29.74), controlPoint2: CGPoint(x: 82.65, y: 29.74))
        bezier2Path.addCurve(to: CGPoint(x: 81.57, y: 28.47), controlPoint1: CGPoint(x: 82.65, y: 29.74), controlPoint2: CGPoint(x: 81.75, y: 28.95))
        bezier2Path.addCurve(to: CGPoint(x: 80.14, y: 27.83), controlPoint1: CGPoint(x: 81.12, y: 28.39), controlPoint2: CGPoint(x: 80.14, y: 27.83))
        bezier2Path.addCurve(to: CGPoint(x: 78.16, y: 27.36), controlPoint1: CGPoint(x: 80.14, y: 27.83), controlPoint2: CGPoint(x: 78.88, y: 27.67))
        bezier2Path.addCurve(to: CGPoint(x: 76.01, y: 27.36), controlPoint1: CGPoint(x: 77.53, y: 27.44), controlPoint2: CGPoint(x: 76.91, y: 27.51))
        bezier2Path.addCurve(to: CGPoint(x: 73.32, y: 27.99), controlPoint1: CGPoint(x: 75.02, y: 27.75), controlPoint2: CGPoint(x: 74.39, y: 27.83))
        bezier2Path.addCurve(to: CGPoint(x: 71.52, y: 29.42), controlPoint1: CGPoint(x: 72.78, y: 28.71), controlPoint2: CGPoint(x: 72.06, y: 29.1))
        bezier2Path.addCurve(to: CGPoint(x: 71.17, y: 31.49), controlPoint1: CGPoint(x: 71.61, y: 30.38), controlPoint2: CGPoint(x: 71.17, y: 31.49))
        color11.setFill()
        bezier2Path.fill()
        color13.setStroke()
        bezier2Path.lineWidth = 1
        bezier2Path.stroke()
        
        
        //// Bezier 15 Drawing
        let bezier15Path = UIBezierPath()
        bezier15Path.move(to: CGPoint(x: 69.19, y: 28.79))
        bezier15Path.addLine(to: CGPoint(x: 73.32, y: 27.99))
        color13.setStroke()
        bezier15Path.lineWidth = 1
        bezier15Path.stroke()
        
        
        //// Bezier 16 Drawing
        let bezier16Path = UIBezierPath()
        bezier16Path.move(to: CGPoint(x: 68.83, y: 31.49))
        bezier16Path.addLine(to: CGPoint(x: 71.52, y: 29.42))
        color13.setStroke()
        bezier16Path.lineWidth = 1
        bezier16Path.stroke()
        
        
        //// Oval 4 Drawing
        let oval4Path = UIBezierPath(ovalIn: CGRect(x: 56.27, y: 35.95, width: 26, height: 24))
        color11.setFill()
        oval4Path.fill()
        
        
        //// Bezier 17 Drawing
        let bezier17Path = UIBezierPath()
        bezier17Path.move(to: CGPoint(x: 66.23, y: 37.13))
        bezier17Path.addLine(to: CGPoint(x: 66.23, y: 33))
        bezier17Path.addCurve(to: CGPoint(x: 69.82, y: 31.25), controlPoint1: CGPoint(x: 66.23, y: 33), controlPoint2: CGPoint(x: 66.41, y: 31.25))
        bezier17Path.addCurve(to: CGPoint(x: 73.77, y: 33), controlPoint1: CGPoint(x: 73.23, y: 31.25), controlPoint2: CGPoint(x: 73.77, y: 33))
        bezier17Path.addLine(to: CGPoint(x: 73.77, y: 37.13))
        color11.setFill()
        bezier17Path.fill()
        
        
        //// Bezier 18 Drawing
        let bezier18Path = UIBezierPath()
        bezier18Path.move(to: CGPoint(x: 71.17, y: 26.72))
        bezier18Path.addLine(to: CGPoint(x: 76.01, y: 27.36))
        color13.setStroke()
        bezier18Path.lineWidth = 1
        bezier18Path.stroke()
        
        
        //// Bezier 19 Drawing
        let bezier19Path = UIBezierPath()
        bezier19Path.move(to: CGPoint(x: 73.68, y: 25.77))
        bezier19Path.addLine(to: CGPoint(x: 78.16, y: 27.36))
        color13.setStroke()
        bezier19Path.lineWidth = 1
        bezier19Path.stroke()
        
        
        //// Bezier 20 Drawing
        let bezier20Path = UIBezierPath()
        bezier20Path.move(to: CGPoint(x: 76.91, y: 25.45))
        bezier20Path.addLine(to: CGPoint(x: 80.14, y: 27.83))
        color13.setStroke()
        bezier20Path.lineWidth = 1
        bezier20Path.stroke()
        
        
        //// Bezier 21 Drawing
        let bezier21Path = UIBezierPath()
        bezier21Path.move(to: CGPoint(x: 79.96, y: 25.77))
        bezier21Path.addLine(to: CGPoint(x: 81.57, y: 28.47))
        color13.setStroke()
        bezier21Path.lineWidth = 1
        bezier21Path.stroke()
        
        
        //// Bezier 22 Drawing
        let bezier22Path = UIBezierPath()
        bezier22Path.move(to: CGPoint(x: 83.54, y: 27.67))
        bezier22Path.addLine(to: CGPoint(x: 82.65, y: 29.74))
        color13.setStroke()
        bezier22Path.lineWidth = 1
        bezier22Path.stroke()
        
        
        //// Bezier 23 Drawing
        let bezier23Path = UIBezierPath()
        bezier23Path.move(to: CGPoint(x: 82.11, y: 26.72))
        bezier23Path.addLine(to: CGPoint(x: 82.65, y: 29.74))
        color13.setStroke()
        bezier23Path.lineWidth = 1
        bezier23Path.stroke()
        
        
        //// Bezier 24 Drawing
        context.saveGState()
        context.translateBy(x: 61.85, y: 5.71)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier24Path = UIBezierPath()
        bezier24Path.move(to: CGPoint(x: 33.13, y: -1.92))
        bezier24Path.addCurve(to: CGPoint(x: 33.54, y: -4.69), controlPoint1: CGPoint(x: 30.49, y: -5.78), controlPoint2: CGPoint(x: 30.05, y: -8.26))
        bezier24Path.addCurve(to: CGPoint(x: 34.67, y: -0.33), controlPoint1: CGPoint(x: 38.08, y: -0.04), controlPoint2: CGPoint(x: 34.67, y: -0.33))
        bezier24Path.addCurve(to: CGPoint(x: 33.13, y: -1.92), controlPoint1: CGPoint(x: 34.67, y: -0.33), controlPoint2: CGPoint(x: 33.92, y: -0.76))
        bezier24Path.close()
        context.saveGState()
        bezier24Path.addClip()
        context.drawLinearGradient(gradient4, start: CGPoint(x: 34.07, y: -4.15), end: CGPoint(x: 32.39, y: -2.48), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    @objc dynamic public class func drawLargePack(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 140, height: 140), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 140, height: 140), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 140, y: resizedFrame.height / 140)
        
        
        //// Color Declarations
        let gradientColor = UIColor(red: 0.546, green: 0.541, blue: 0.541, alpha: 1.000)
        let color10 = UIColor(red: 1.000, green: 0.848, blue: 0.000, alpha: 1.000)
        let gradientColor2 = UIColor(red: 0.874, green: 0.829, blue: 0.688, alpha: 1.000)
        let color11 = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        let gradientColor3 = UIColor(red: 0.698, green: 0.529, blue: 0.000, alpha: 1.000)
        let color12 = UIColor(red: 1.000, green: 0.746, blue: 0.000, alpha: 1.000)
        let color13 = UIColor(red: 0.533, green: 0.368, blue: 0.000, alpha: 1.000)
        let color = UIColor(red: 0.360, green: 0.243, blue: 0.125, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient4 = CGGradient(colorsSpace: nil, colors: [gradientColor3.cgColor, gradientColor3.blended(withFraction: 0.5, of: gradientColor2).cgColor, gradientColor2.cgColor] as CFArray, locations: [0, 0.72, 1])!
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 2.97, y: 1.73, width: 136, height: 136), cornerRadius: 4)
        gradientColor.setStroke()
        rectanglePath.lineWidth = 3
        rectanglePath.stroke()
        
        
        //// Group 2
        //// Group
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 48.51, y: 24.65))
        bezierPath.addCurve(to: CGPoint(x: 68.69, y: 27.88), controlPoint1: CGPoint(x: 58.39, y: 19.67), controlPoint2: CGPoint(x: 51.23, y: 31.2))
        bezierPath.addCurve(to: CGPoint(x: 86.15, y: 24.55), controlPoint1: CGPoint(x: 86.15, y: 24.55), controlPoint2: CGPoint(x: 84.82, y: 23.53))
        bezierPath.addCurve(to: CGPoint(x: 76.82, y: 33.02), controlPoint1: CGPoint(x: 87.48, y: 25.58), controlPoint2: CGPoint(x: 84.13, y: 26.18))
        bezierPath.addCurve(to: CGPoint(x: 66.6, y: 49.69), controlPoint1: CGPoint(x: 69.51, y: 39.86), controlPoint2: CGPoint(x: 66.6, y: 49.69))
        bezierPath.addCurve(to: CGPoint(x: 82.54, y: 53.71), controlPoint1: CGPoint(x: 66.6, y: 49.69), controlPoint2: CGPoint(x: 74.04, y: 48.6))
        bezierPath.addCurve(to: CGPoint(x: 99.6, y: 74.21), controlPoint1: CGPoint(x: 91.04, y: 58.81), controlPoint2: CGPoint(x: 93.95, y: 63.43))
        bezierPath.addCurve(to: CGPoint(x: 105.31, y: 104.71), controlPoint1: CGPoint(x: 105.26, y: 85), controlPoint2: CGPoint(x: 111.86, y: 100.46))
        bezierPath.addCurve(to: CGPoint(x: 52.58, y: 109.25), controlPoint1: CGPoint(x: 98.75, y: 108.96), controlPoint2: CGPoint(x: 67.37, y: 110.96))
        bezierPath.addCurve(to: CGPoint(x: 27.55, y: 90.61), controlPoint1: CGPoint(x: 37.79, y: 107.55), controlPoint2: CGPoint(x: 26.02, y: 101.4))
        bezierPath.addCurve(to: CGPoint(x: 47.9, y: 59.69), controlPoint1: CGPoint(x: 29.08, y: 79.82), controlPoint2: CGPoint(x: 36.9, y: 69.06))
        bezierPath.addCurve(to: CGPoint(x: 59.81, y: 51.76), controlPoint1: CGPoint(x: 58.9, y: 50.31), controlPoint2: CGPoint(x: 59.81, y: 51.76))
        bezierPath.addCurve(to: CGPoint(x: 55.34, y: 45.8), controlPoint1: CGPoint(x: 59.81, y: 51.76), controlPoint2: CGPoint(x: 61.63, y: 51.7))
        bezierPath.addCurve(to: CGPoint(x: 37.17, y: 33.08), controlPoint1: CGPoint(x: 49.05, y: 39.91), controlPoint2: CGPoint(x: 34.86, y: 35.37))
        bezierPath.addCurve(to: CGPoint(x: 48.51, y: 24.65), controlPoint1: CGPoint(x: 39.47, y: 30.78), controlPoint2: CGPoint(x: 38.62, y: 29.64))
        bezierPath.close()
        UIColor.gray.setFill()
        bezierPath.fill()
        UIColor.gray.setStroke()
        bezierPath.lineWidth = 3
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 57.36, y: 52.65))
        bezier2Path.addCurve(to: CGPoint(x: 67.08, y: 50.02), controlPoint1: CGPoint(x: 57.36, y: 52.65), controlPoint2: CGPoint(x: 63.08, y: 50.63))
        bezier2Path.addCurve(to: CGPoint(x: 73.81, y: 49.4), controlPoint1: CGPoint(x: 71.07, y: 49.4), controlPoint2: CGPoint(x: 73.81, y: 49.4))
        bezier2Path.addCurve(to: CGPoint(x: 65.51, y: 46.1), controlPoint1: CGPoint(x: 73.81, y: 49.4), controlPoint2: CGPoint(x: 76.41, y: 44.87))
        bezier2Path.addCurve(to: CGPoint(x: 54.04, y: 49.65), controlPoint1: CGPoint(x: 54.62, y: 47.32), controlPoint2: CGPoint(x: 54.04, y: 49.65))
        bezier2Path.addCurve(to: CGPoint(x: 53.7, y: 52.69), controlPoint1: CGPoint(x: 54.04, y: 49.65), controlPoint2: CGPoint(x: 51.86, y: 51.23))
        bezier2Path.addCurve(to: CGPoint(x: 57.36, y: 52.65), controlPoint1: CGPoint(x: 55.55, y: 54.15), controlPoint2: CGPoint(x: 57.36, y: 52.65))
        bezier2Path.close()
        color.setFill()
        bezier2Path.fill()
        color.setStroke()
        bezier2Path.lineWidth = 1
        bezier2Path.stroke()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 71.95, y: 47.59))
        bezier3Path.addCurve(to: CGPoint(x: 83.48, y: 38.33), controlPoint1: CGPoint(x: 71.95, y: 47.59), controlPoint2: CGPoint(x: 72.78, y: 35.47))
        bezier3Path.addCurve(to: CGPoint(x: 95.92, y: 44.9), controlPoint1: CGPoint(x: 94.18, y: 41.19), controlPoint2: CGPoint(x: 95.92, y: 44.9))
        bezier3Path.addCurve(to: CGPoint(x: 78.04, y: 43.4), controlPoint1: CGPoint(x: 95.92, y: 44.9), controlPoint2: CGPoint(x: 82.49, y: 41.41))
        bezier3Path.addCurve(to: CGPoint(x: 71.95, y: 47.59), controlPoint1: CGPoint(x: 73.59, y: 45.39), controlPoint2: CGPoint(x: 71.95, y: 47.59))
        bezier3Path.close()
        color.setFill()
        bezier3Path.fill()
        
        
        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 96.47, y: 56.53))
        bezier4Path.addCurve(to: CGPoint(x: 77.72, y: 48.48), controlPoint1: CGPoint(x: 96.47, y: 56.53), controlPoint2: CGPoint(x: 84.41, y: 48.85))
        bezier4Path.addCurve(to: CGPoint(x: 71.25, y: 46.9), controlPoint1: CGPoint(x: 71.03, y: 48.1), controlPoint2: CGPoint(x: 71.25, y: 46.9))
        bezier4Path.addCurve(to: CGPoint(x: 90.87, y: 48.3), controlPoint1: CGPoint(x: 71.25, y: 46.9), controlPoint2: CGPoint(x: 85.54, y: 41.89))
        bezier4Path.addCurve(to: CGPoint(x: 96.47, y: 56.53), controlPoint1: CGPoint(x: 96.21, y: 54.72), controlPoint2: CGPoint(x: 96.47, y: 56.53))
        bezier4Path.close()
        color.setFill()
        bezier4Path.fill()
        
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 70.99, y: 45.41, width: 4.69, height: 3.16))
        color.setFill()
        ovalPath.fill()
        color.setStroke()
        ovalPath.lineWidth = 3
        ovalPath.stroke()
        
        
        
        
        //// Coin
        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: 37.33, y: 90.63, width: 21, height: 20))
        color12.setFill()
        oval3Path.fill()
        
        
        //// Bezier 7 Drawing
        let bezier7Path = UIBezierPath()
        bezier7Path.move(to: CGPoint(x: 42.17, y: 95.8))
        bezier7Path.addCurve(to: CGPoint(x: 43.44, y: 92.25), controlPoint1: CGPoint(x: 44.65, y: 92.43), controlPoint2: CGPoint(x: 46.9, y: 90.89))
        bezier7Path.addCurve(to: CGPoint(x: 39.59, y: 95.53), controlPoint1: CGPoint(x: 41.94, y: 92.83), controlPoint2: CGPoint(x: 40.13, y: 94.61))
        bezier7Path.addCurve(to: CGPoint(x: 38.47, y: 101.92), controlPoint1: CGPoint(x: 37.43, y: 99.23), controlPoint2: CGPoint(x: 37.36, y: 102.77))
        bezier7Path.addCurve(to: CGPoint(x: 42.17, y: 95.8), controlPoint1: CGPoint(x: 38.94, y: 101.57), controlPoint2: CGPoint(x: 40.37, y: 98.25))
        bezier7Path.close()
        color10.setFill()
        bezier7Path.fill()
        
        
        //// Bezier 8 Drawing
        let bezier8Path = UIBezierPath()
        bezier8Path.move(to: CGPoint(x: 47.38, y: 96.74))
        bezier8Path.addCurve(to: CGPoint(x: 47.51, y: 95.74), controlPoint1: CGPoint(x: 47.38, y: 96.74), controlPoint2: CGPoint(x: 47.24, y: 95.89))
        bezier8Path.addCurve(to: CGPoint(x: 48.28, y: 94.97), controlPoint1: CGPoint(x: 47.44, y: 95.56), controlPoint2: CGPoint(x: 48.04, y: 94.97))
        bezier8Path.addCurve(to: CGPoint(x: 49.26, y: 94.62), controlPoint1: CGPoint(x: 48.35, y: 94.8), controlPoint2: CGPoint(x: 49.05, y: 94.56))
        bezier8Path.addCurve(to: CGPoint(x: 50.51, y: 94.5), controlPoint1: CGPoint(x: 49.4, y: 94.41), controlPoint2: CGPoint(x: 50.31, y: 94.39))
        bezier8Path.addCurve(to: CGPoint(x: 51.7, y: 94.62), controlPoint1: CGPoint(x: 50.72, y: 94.33), controlPoint2: CGPoint(x: 51.63, y: 94.5))
        bezier8Path.addCurve(to: CGPoint(x: 52.54, y: 94.97), controlPoint1: CGPoint(x: 51.91, y: 94.53), controlPoint2: CGPoint(x: 52.61, y: 94.8))
        bezier8Path.addCurve(to: CGPoint(x: 53.1, y: 95.33), controlPoint1: CGPoint(x: 52.75, y: 94.97), controlPoint2: CGPoint(x: 53.1, y: 95.15))
        bezier8Path.addCurve(to: CGPoint(x: 53.31, y: 95.98), controlPoint1: CGPoint(x: 53.27, y: 95.33), controlPoint2: CGPoint(x: 53.34, y: 95.8))
        bezier8Path.addCurve(to: CGPoint(x: 52.75, y: 96.09), controlPoint1: CGPoint(x: 53.17, y: 96.09), controlPoint2: CGPoint(x: 52.75, y: 96.09))
        bezier8Path.addCurve(to: CGPoint(x: 52.33, y: 95.62), controlPoint1: CGPoint(x: 52.75, y: 96.09), controlPoint2: CGPoint(x: 52.4, y: 95.8))
        bezier8Path.addCurve(to: CGPoint(x: 51.77, y: 95.39), controlPoint1: CGPoint(x: 52.15, y: 95.59), controlPoint2: CGPoint(x: 51.77, y: 95.39))
        bezier8Path.addCurve(to: CGPoint(x: 51, y: 95.21), controlPoint1: CGPoint(x: 51.77, y: 95.39), controlPoint2: CGPoint(x: 51.28, y: 95.33))
        bezier8Path.addCurve(to: CGPoint(x: 50.17, y: 95.21), controlPoint1: CGPoint(x: 50.76, y: 95.24), controlPoint2: CGPoint(x: 50.51, y: 95.27))
        bezier8Path.addCurve(to: CGPoint(x: 49.12, y: 95.45), controlPoint1: CGPoint(x: 49.78, y: 95.36), controlPoint2: CGPoint(x: 49.54, y: 95.39))
        bezier8Path.addCurve(to: CGPoint(x: 48.42, y: 95.98), controlPoint1: CGPoint(x: 48.91, y: 95.71), controlPoint2: CGPoint(x: 48.63, y: 95.86))
        bezier8Path.addCurve(to: CGPoint(x: 48.28, y: 96.74), controlPoint1: CGPoint(x: 48.46, y: 96.33), controlPoint2: CGPoint(x: 48.28, y: 96.74))
        color11.setFill()
        bezier8Path.fill()
        color13.setStroke()
        bezier8Path.lineWidth = 1
        bezier8Path.stroke()
        
        
        //// Bezier 9 Drawing
        let bezier9Path = UIBezierPath()
        bezier9Path.move(to: CGPoint(x: 47.51, y: 95.74))
        bezier9Path.addLine(to: CGPoint(x: 49.12, y: 95.45))
        color13.setStroke()
        bezier9Path.lineWidth = 1
        bezier9Path.stroke()
        
        
        //// Bezier 10 Drawing
        let bezier10Path = UIBezierPath()
        bezier10Path.move(to: CGPoint(x: 47.38, y: 96.74))
        bezier10Path.addLine(to: CGPoint(x: 48.42, y: 95.98))
        color13.setStroke()
        bezier10Path.lineWidth = 1
        bezier10Path.stroke()
        
        
        //// Oval 5 Drawing
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: 42.6, y: 98.58, width: 10, height: 9))
        color11.setFill()
        oval5Path.fill()
        
        
        //// Bezier 11 Drawing
        let bezier11Path = UIBezierPath()
        bezier11Path.move(to: CGPoint(x: 46.36, y: 98.83))
        bezier11Path.addLine(to: CGPoint(x: 46.36, y: 97.3))
        bezier11Path.addCurve(to: CGPoint(x: 47.76, y: 96.65), controlPoint1: CGPoint(x: 46.36, y: 97.3), controlPoint2: CGPoint(x: 46.43, y: 96.65))
        bezier11Path.addCurve(to: CGPoint(x: 49.29, y: 97.3), controlPoint1: CGPoint(x: 49.08, y: 96.65), controlPoint2: CGPoint(x: 49.29, y: 97.3))
        bezier11Path.addLine(to: CGPoint(x: 49.29, y: 98.83))
        color11.setFill()
        bezier11Path.fill()
        
        
        //// Bezier 12 Drawing
        let bezier12Path = UIBezierPath()
        bezier12Path.move(to: CGPoint(x: 48.28, y: 94.97))
        bezier12Path.addLine(to: CGPoint(x: 50.17, y: 95.21))
        color13.setStroke()
        bezier12Path.lineWidth = 1
        bezier12Path.stroke()
        
        
        //// Bezier 13 Drawing
        let bezier13Path = UIBezierPath()
        bezier13Path.move(to: CGPoint(x: 49.26, y: 94.62))
        bezier13Path.addLine(to: CGPoint(x: 51, y: 95.21))
        color13.setStroke()
        bezier13Path.lineWidth = 1
        bezier13Path.stroke()
        
        
        //// Bezier 14 Drawing
        let bezier14Path = UIBezierPath()
        bezier14Path.move(to: CGPoint(x: 50.51, y: 94.5))
        bezier14Path.addLine(to: CGPoint(x: 51.77, y: 95.39))
        color13.setStroke()
        bezier14Path.lineWidth = 1
        bezier14Path.stroke()
        
        
        //// Bezier 25 Drawing
        let bezier25Path = UIBezierPath()
        bezier25Path.move(to: CGPoint(x: 51.7, y: 94.62))
        bezier25Path.addLine(to: CGPoint(x: 52.33, y: 95.62))
        color13.setStroke()
        bezier25Path.lineWidth = 1
        bezier25Path.stroke()
        
        
        //// Bezier 26 Drawing
        let bezier26Path = UIBezierPath()
        bezier26Path.move(to: CGPoint(x: 53.1, y: 95.33))
        bezier26Path.addLine(to: CGPoint(x: 52.75, y: 96.09))
        color13.setStroke()
        bezier26Path.lineWidth = 1
        bezier26Path.stroke()
        
        
        //// Bezier 27 Drawing
        let bezier27Path = UIBezierPath()
        bezier27Path.move(to: CGPoint(x: 52.54, y: 94.97))
        bezier27Path.addLine(to: CGPoint(x: 52.75, y: 96.09))
        color13.setStroke()
        bezier27Path.lineWidth = 1
        bezier27Path.stroke()
        
        
        //// Bezier 28 Drawing
        context.saveGState()
        context.translateBy(x: 45.71, y: 67.68)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier28Path = UIBezierPath()
        bezier28Path.move(to: CGPoint(x: 31.81, y: -0.94))
        bezier28Path.addCurve(to: CGPoint(x: 31.96, y: -2.02), controlPoint1: CGPoint(x: 30.83, y: -2.44), controlPoint2: CGPoint(x: 30.67, y: -3.4))
        bezier28Path.addCurve(to: CGPoint(x: 32.37, y: -0.32), controlPoint1: CGPoint(x: 33.63, y: -0.21), controlPoint2: CGPoint(x: 32.37, y: -0.32))
        bezier28Path.addCurve(to: CGPoint(x: 31.81, y: -0.94), controlPoint1: CGPoint(x: 32.37, y: -0.32), controlPoint2: CGPoint(x: 32.1, y: -0.49))
        bezier28Path.close()
        context.saveGState()
        bezier28Path.addClip()
        context.drawLinearGradient(gradient4, start: CGPoint(x: 32.17, y: -1.81), end: CGPoint(x: 31.51, y: -1.15), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        
        
        
        //// Coin 2
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 25.91, y: 95.63, width: 21, height: 20))
        color12.setFill()
        oval2Path.fill()
        
        
        //// Bezier 5 Drawing
        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 30.75, y: 100.8))
        bezier5Path.addCurve(to: CGPoint(x: 32.02, y: 97.25), controlPoint1: CGPoint(x: 33.23, y: 97.43), controlPoint2: CGPoint(x: 35.47, y: 95.89))
        bezier5Path.addCurve(to: CGPoint(x: 28.17, y: 100.53), controlPoint1: CGPoint(x: 30.52, y: 97.83), controlPoint2: CGPoint(x: 28.71, y: 99.61))
        bezier5Path.addCurve(to: CGPoint(x: 27.05, y: 106.92), controlPoint1: CGPoint(x: 26.01, y: 104.23), controlPoint2: CGPoint(x: 25.94, y: 107.77))
        bezier5Path.addCurve(to: CGPoint(x: 30.75, y: 100.8), controlPoint1: CGPoint(x: 27.52, y: 106.57), controlPoint2: CGPoint(x: 28.95, y: 103.25))
        bezier5Path.close()
        color10.setFill()
        bezier5Path.fill()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 35.95, y: 101.74))
        bezier6Path.addCurve(to: CGPoint(x: 36.09, y: 100.74), controlPoint1: CGPoint(x: 35.95, y: 101.74), controlPoint2: CGPoint(x: 35.81, y: 100.89))
        bezier6Path.addCurve(to: CGPoint(x: 36.86, y: 99.97), controlPoint1: CGPoint(x: 36.02, y: 100.56), controlPoint2: CGPoint(x: 36.62, y: 99.97))
        bezier6Path.addCurve(to: CGPoint(x: 37.84, y: 99.62), controlPoint1: CGPoint(x: 36.93, y: 99.8), controlPoint2: CGPoint(x: 37.63, y: 99.56))
        bezier6Path.addCurve(to: CGPoint(x: 39.09, y: 99.5), controlPoint1: CGPoint(x: 37.98, y: 99.41), controlPoint2: CGPoint(x: 38.88, y: 99.38))
        bezier6Path.addCurve(to: CGPoint(x: 40.28, y: 99.62), controlPoint1: CGPoint(x: 39.3, y: 99.33), controlPoint2: CGPoint(x: 40.21, y: 99.5))
        bezier6Path.addCurve(to: CGPoint(x: 41.12, y: 99.97), controlPoint1: CGPoint(x: 40.49, y: 99.53), controlPoint2: CGPoint(x: 41.19, y: 99.8))
        bezier6Path.addCurve(to: CGPoint(x: 41.67, y: 100.33), controlPoint1: CGPoint(x: 41.33, y: 99.97), controlPoint2: CGPoint(x: 41.67, y: 100.15))
        bezier6Path.addCurve(to: CGPoint(x: 41.88, y: 100.97), controlPoint1: CGPoint(x: 41.85, y: 100.33), controlPoint2: CGPoint(x: 41.92, y: 100.8))
        bezier6Path.addCurve(to: CGPoint(x: 41.33, y: 101.09), controlPoint1: CGPoint(x: 41.74, y: 101.09), controlPoint2: CGPoint(x: 41.33, y: 101.09))
        bezier6Path.addCurve(to: CGPoint(x: 40.91, y: 100.62), controlPoint1: CGPoint(x: 41.33, y: 101.09), controlPoint2: CGPoint(x: 40.98, y: 100.8))
        bezier6Path.addCurve(to: CGPoint(x: 40.35, y: 100.39), controlPoint1: CGPoint(x: 40.73, y: 100.59), controlPoint2: CGPoint(x: 40.35, y: 100.39))
        bezier6Path.addCurve(to: CGPoint(x: 39.58, y: 100.21), controlPoint1: CGPoint(x: 40.35, y: 100.39), controlPoint2: CGPoint(x: 39.86, y: 100.33))
        bezier6Path.addCurve(to: CGPoint(x: 38.74, y: 100.21), controlPoint1: CGPoint(x: 39.34, y: 100.24), controlPoint2: CGPoint(x: 39.09, y: 100.27))
        bezier6Path.addCurve(to: CGPoint(x: 37.7, y: 100.44), controlPoint1: CGPoint(x: 38.36, y: 100.36), controlPoint2: CGPoint(x: 38.12, y: 100.39))
        bezier6Path.addCurve(to: CGPoint(x: 37, y: 100.97), controlPoint1: CGPoint(x: 37.49, y: 100.71), controlPoint2: CGPoint(x: 37.21, y: 100.86))
        bezier6Path.addCurve(to: CGPoint(x: 36.86, y: 101.74), controlPoint1: CGPoint(x: 37.04, y: 101.33), controlPoint2: CGPoint(x: 36.86, y: 101.74))
        color11.setFill()
        bezier6Path.fill()
        color13.setStroke()
        bezier6Path.lineWidth = 1
        bezier6Path.stroke()
        
        
        //// Bezier 15 Drawing
        let bezier15Path = UIBezierPath()
        bezier15Path.move(to: CGPoint(x: 36.09, y: 100.74))
        bezier15Path.addLine(to: CGPoint(x: 37.7, y: 100.44))
        color13.setStroke()
        bezier15Path.lineWidth = 1
        bezier15Path.stroke()
        
        
        //// Bezier 16 Drawing
        let bezier16Path = UIBezierPath()
        bezier16Path.move(to: CGPoint(x: 35.95, y: 101.74))
        bezier16Path.addLine(to: CGPoint(x: 37, y: 100.97))
        color13.setStroke()
        bezier16Path.lineWidth = 1
        bezier16Path.stroke()
        
        
        //// Oval 4 Drawing
        let oval4Path = UIBezierPath(ovalIn: CGRect(x: 31.18, y: 103.58, width: 10, height: 9))
        color11.setFill()
        oval4Path.fill()
        
        
        //// Bezier 17 Drawing
        let bezier17Path = UIBezierPath()
        bezier17Path.move(to: CGPoint(x: 34.94, y: 103.83))
        bezier17Path.addLine(to: CGPoint(x: 34.94, y: 102.3))
        bezier17Path.addCurve(to: CGPoint(x: 36.34, y: 101.65), controlPoint1: CGPoint(x: 34.94, y: 102.3), controlPoint2: CGPoint(x: 35.01, y: 101.65))
        bezier17Path.addCurve(to: CGPoint(x: 37.87, y: 102.3), controlPoint1: CGPoint(x: 37.66, y: 101.65), controlPoint2: CGPoint(x: 37.87, y: 102.3))
        bezier17Path.addLine(to: CGPoint(x: 37.87, y: 103.83))
        color11.setFill()
        bezier17Path.fill()
        
        
        //// Bezier 18 Drawing
        let bezier18Path = UIBezierPath()
        bezier18Path.move(to: CGPoint(x: 36.86, y: 99.97))
        bezier18Path.addLine(to: CGPoint(x: 38.74, y: 100.21))
        color13.setStroke()
        bezier18Path.lineWidth = 1
        bezier18Path.stroke()
        
        
        //// Bezier 19 Drawing
        let bezier19Path = UIBezierPath()
        bezier19Path.move(to: CGPoint(x: 37.84, y: 99.62))
        bezier19Path.addLine(to: CGPoint(x: 39.58, y: 100.21))
        color13.setStroke()
        bezier19Path.lineWidth = 1
        bezier19Path.stroke()
        
        
        //// Bezier 20 Drawing
        let bezier20Path = UIBezierPath()
        bezier20Path.move(to: CGPoint(x: 39.09, y: 99.5))
        bezier20Path.addLine(to: CGPoint(x: 40.35, y: 100.39))
        color13.setStroke()
        bezier20Path.lineWidth = 1
        bezier20Path.stroke()
        
        
        //// Bezier 21 Drawing
        let bezier21Path = UIBezierPath()
        bezier21Path.move(to: CGPoint(x: 40.28, y: 99.62))
        bezier21Path.addLine(to: CGPoint(x: 40.91, y: 100.62))
        color13.setStroke()
        bezier21Path.lineWidth = 1
        bezier21Path.stroke()
        
        
        //// Bezier 22 Drawing
        let bezier22Path = UIBezierPath()
        bezier22Path.move(to: CGPoint(x: 41.67, y: 100.33))
        bezier22Path.addLine(to: CGPoint(x: 41.33, y: 101.09))
        color13.setStroke()
        bezier22Path.lineWidth = 1
        bezier22Path.stroke()
        
        
        //// Bezier 23 Drawing
        let bezier23Path = UIBezierPath()
        bezier23Path.move(to: CGPoint(x: 41.12, y: 99.97))
        bezier23Path.addLine(to: CGPoint(x: 41.33, y: 101.09))
        color13.setStroke()
        bezier23Path.lineWidth = 1
        bezier23Path.stroke()
        
        
        //// Bezier 24 Drawing
        context.saveGState()
        context.translateBy(x: 34.28, y: 72.68)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier24Path = UIBezierPath()
        bezier24Path.move(to: CGPoint(x: 31.81, y: -0.94))
        bezier24Path.addCurve(to: CGPoint(x: 31.96, y: -2.02), controlPoint1: CGPoint(x: 30.83, y: -2.44), controlPoint2: CGPoint(x: 30.67, y: -3.4))
        bezier24Path.addCurve(to: CGPoint(x: 32.37, y: -0.32), controlPoint1: CGPoint(x: 33.63, y: -0.21), controlPoint2: CGPoint(x: 32.37, y: -0.32))
        bezier24Path.addCurve(to: CGPoint(x: 31.81, y: -0.94), controlPoint1: CGPoint(x: 32.37, y: -0.32), controlPoint2: CGPoint(x: 32.1, y: -0.49))
        bezier24Path.close()
        context.saveGState()
        bezier24Path.addClip()
        context.drawLinearGradient(gradient4, start: CGPoint(x: 32.17, y: -1.81), end: CGPoint(x: 31.51, y: -1.15), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        
        
        
        //// Coin 3
        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: 43.64, y: 97.75, width: 21, height: 20))
        color12.setFill()
        oval6Path.fill()
        
        
        //// Bezier 29 Drawing
        let bezier29Path = UIBezierPath()
        bezier29Path.move(to: CGPoint(x: 48.49, y: 102.92))
        bezier29Path.addCurve(to: CGPoint(x: 49.75, y: 99.36), controlPoint1: CGPoint(x: 50.97, y: 99.55), controlPoint2: CGPoint(x: 53.21, y: 98.01))
        bezier29Path.addCurve(to: CGPoint(x: 45.91, y: 102.65), controlPoint1: CGPoint(x: 48.26, y: 99.95), controlPoint2: CGPoint(x: 46.45, y: 101.72))
        bezier29Path.addCurve(to: CGPoint(x: 44.79, y: 109.04), controlPoint1: CGPoint(x: 43.75, y: 106.34), controlPoint2: CGPoint(x: 43.67, y: 109.88))
        bezier29Path.addCurve(to: CGPoint(x: 48.49, y: 102.92), controlPoint1: CGPoint(x: 45.26, y: 108.68), controlPoint2: CGPoint(x: 46.69, y: 105.36))
        bezier29Path.close()
        color10.setFill()
        bezier29Path.fill()
        
        
        //// Bezier 30 Drawing
        let bezier30Path = UIBezierPath()
        bezier30Path.move(to: CGPoint(x: 53.69, y: 103.86))
        bezier30Path.addCurve(to: CGPoint(x: 53.83, y: 102.85), controlPoint1: CGPoint(x: 53.69, y: 103.86), controlPoint2: CGPoint(x: 53.55, y: 103))
        bezier30Path.addCurve(to: CGPoint(x: 54.6, y: 102.09), controlPoint1: CGPoint(x: 53.76, y: 102.68), controlPoint2: CGPoint(x: 54.35, y: 102.09))
        bezier30Path.addCurve(to: CGPoint(x: 55.57, y: 101.74), controlPoint1: CGPoint(x: 54.67, y: 101.91), controlPoint2: CGPoint(x: 55.36, y: 101.68))
        bezier30Path.addCurve(to: CGPoint(x: 56.83, y: 101.62), controlPoint1: CGPoint(x: 55.71, y: 101.53), controlPoint2: CGPoint(x: 56.62, y: 101.5))
        bezier30Path.addCurve(to: CGPoint(x: 58.02, y: 101.74), controlPoint1: CGPoint(x: 57.04, y: 101.44), controlPoint2: CGPoint(x: 57.95, y: 101.62))
        bezier30Path.addCurve(to: CGPoint(x: 58.85, y: 102.09), controlPoint1: CGPoint(x: 58.22, y: 101.65), controlPoint2: CGPoint(x: 58.92, y: 101.91))
        bezier30Path.addCurve(to: CGPoint(x: 59.41, y: 102.44), controlPoint1: CGPoint(x: 59.06, y: 102.09), controlPoint2: CGPoint(x: 59.41, y: 102.27))
        bezier30Path.addCurve(to: CGPoint(x: 59.62, y: 103.09), controlPoint1: CGPoint(x: 59.59, y: 102.44), controlPoint2: CGPoint(x: 59.66, y: 102.91))
        bezier30Path.addCurve(to: CGPoint(x: 59.06, y: 103.21), controlPoint1: CGPoint(x: 59.48, y: 103.21), controlPoint2: CGPoint(x: 59.06, y: 103.21))
        bezier30Path.addCurve(to: CGPoint(x: 58.64, y: 102.74), controlPoint1: CGPoint(x: 59.06, y: 103.21), controlPoint2: CGPoint(x: 58.71, y: 102.91))
        bezier30Path.addCurve(to: CGPoint(x: 58.09, y: 102.5), controlPoint1: CGPoint(x: 58.47, y: 102.71), controlPoint2: CGPoint(x: 58.09, y: 102.5))
        bezier30Path.addCurve(to: CGPoint(x: 57.32, y: 102.32), controlPoint1: CGPoint(x: 58.09, y: 102.5), controlPoint2: CGPoint(x: 57.6, y: 102.44))
        bezier30Path.addCurve(to: CGPoint(x: 56.48, y: 102.32), controlPoint1: CGPoint(x: 57.07, y: 102.35), controlPoint2: CGPoint(x: 56.83, y: 102.38))
        bezier30Path.addCurve(to: CGPoint(x: 55.43, y: 102.56), controlPoint1: CGPoint(x: 56.1, y: 102.47), controlPoint2: CGPoint(x: 55.85, y: 102.5))
        bezier30Path.addCurve(to: CGPoint(x: 54.74, y: 103.09), controlPoint1: CGPoint(x: 55.23, y: 102.82), controlPoint2: CGPoint(x: 54.95, y: 102.97))
        bezier30Path.addCurve(to: CGPoint(x: 54.6, y: 103.86), controlPoint1: CGPoint(x: 54.77, y: 103.44), controlPoint2: CGPoint(x: 54.6, y: 103.86))
        color11.setFill()
        bezier30Path.fill()
        color13.setStroke()
        bezier30Path.lineWidth = 1
        bezier30Path.stroke()
        
        
        //// Bezier 31 Drawing
        let bezier31Path = UIBezierPath()
        bezier31Path.move(to: CGPoint(x: 53.83, y: 102.85))
        bezier31Path.addLine(to: CGPoint(x: 55.43, y: 102.56))
        color13.setStroke()
        bezier31Path.lineWidth = 1
        bezier31Path.stroke()
        
        
        //// Bezier 32 Drawing
        let bezier32Path = UIBezierPath()
        bezier32Path.move(to: CGPoint(x: 53.69, y: 103.86))
        bezier32Path.addLine(to: CGPoint(x: 54.74, y: 103.09))
        color13.setStroke()
        bezier32Path.lineWidth = 1
        bezier32Path.stroke()
        
        
        //// Oval 7 Drawing
        let oval7Path = UIBezierPath(ovalIn: CGRect(x: 48.91, y: 105.7, width: 10, height: 9))
        color11.setFill()
        oval7Path.fill()
        
        
        //// Bezier 33 Drawing
        let bezier33Path = UIBezierPath()
        bezier33Path.move(to: CGPoint(x: 52.68, y: 105.95))
        bezier33Path.addLine(to: CGPoint(x: 52.68, y: 104.41))
        bezier33Path.addCurve(to: CGPoint(x: 54.07, y: 103.77), controlPoint1: CGPoint(x: 52.68, y: 104.41), controlPoint2: CGPoint(x: 52.75, y: 103.77))
        bezier33Path.addCurve(to: CGPoint(x: 55.61, y: 104.41), controlPoint1: CGPoint(x: 55.4, y: 103.77), controlPoint2: CGPoint(x: 55.61, y: 104.41))
        bezier33Path.addLine(to: CGPoint(x: 55.61, y: 105.95))
        color11.setFill()
        bezier33Path.fill()
        
        
        //// Bezier 34 Drawing
        let bezier34Path = UIBezierPath()
        bezier34Path.move(to: CGPoint(x: 54.6, y: 102.09))
        bezier34Path.addLine(to: CGPoint(x: 56.48, y: 102.32))
        color13.setStroke()
        bezier34Path.lineWidth = 1
        bezier34Path.stroke()
        
        
        //// Bezier 35 Drawing
        let bezier35Path = UIBezierPath()
        bezier35Path.move(to: CGPoint(x: 55.57, y: 101.74))
        bezier35Path.addLine(to: CGPoint(x: 57.32, y: 102.32))
        color13.setStroke()
        bezier35Path.lineWidth = 1
        bezier35Path.stroke()
        
        
        //// Bezier 36 Drawing
        let bezier36Path = UIBezierPath()
        bezier36Path.move(to: CGPoint(x: 56.83, y: 101.62))
        bezier36Path.addLine(to: CGPoint(x: 58.09, y: 102.5))
        color13.setStroke()
        bezier36Path.lineWidth = 1
        bezier36Path.stroke()
        
        
        //// Bezier 37 Drawing
        let bezier37Path = UIBezierPath()
        bezier37Path.move(to: CGPoint(x: 58.02, y: 101.74))
        bezier37Path.addLine(to: CGPoint(x: 58.64, y: 102.74))
        color13.setStroke()
        bezier37Path.lineWidth = 1
        bezier37Path.stroke()
        
        
        //// Bezier 38 Drawing
        let bezier38Path = UIBezierPath()
        bezier38Path.move(to: CGPoint(x: 59.41, y: 102.44))
        bezier38Path.addLine(to: CGPoint(x: 59.06, y: 103.21))
        color13.setStroke()
        bezier38Path.lineWidth = 1
        bezier38Path.stroke()
        
        
        //// Bezier 39 Drawing
        let bezier39Path = UIBezierPath()
        bezier39Path.move(to: CGPoint(x: 58.85, y: 102.09))
        bezier39Path.addLine(to: CGPoint(x: 59.06, y: 103.21))
        color13.setStroke()
        bezier39Path.lineWidth = 1
        bezier39Path.stroke()
        
        
        //// Bezier 40 Drawing
        context.saveGState()
        context.translateBy(x: 52.02, y: 74.8)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier40Path = UIBezierPath()
        bezier40Path.move(to: CGPoint(x: 31.81, y: -0.94))
        bezier40Path.addCurve(to: CGPoint(x: 31.96, y: -2.02), controlPoint1: CGPoint(x: 30.83, y: -2.44), controlPoint2: CGPoint(x: 30.67, y: -3.4))
        bezier40Path.addCurve(to: CGPoint(x: 32.37, y: -0.32), controlPoint1: CGPoint(x: 33.63, y: -0.21), controlPoint2: CGPoint(x: 32.37, y: -0.32))
        bezier40Path.addCurve(to: CGPoint(x: 31.81, y: -0.94), controlPoint1: CGPoint(x: 32.37, y: -0.32), controlPoint2: CGPoint(x: 32.1, y: -0.49))
        bezier40Path.close()
        context.saveGState()
        bezier40Path.addClip()
        context.drawLinearGradient(gradient4, start: CGPoint(x: 32.17, y: -1.81), end: CGPoint(x: 31.51, y: -1.15), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        
        
        
        //// Coin 4
        //// Oval 8 Drawing
        let oval8Path = UIBezierPath(ovalIn: CGRect(x: 99.19, y: 93.15, width: 21, height: 20))
        color12.setFill()
        oval8Path.fill()
        
        
        //// Bezier 41 Drawing
        let bezier41Path = UIBezierPath()
        bezier41Path.move(to: CGPoint(x: 104.03, y: 98.32))
        bezier41Path.addCurve(to: CGPoint(x: 105.3, y: 94.77), controlPoint1: CGPoint(x: 106.51, y: 94.95), controlPoint2: CGPoint(x: 108.75, y: 93.41))
        bezier41Path.addCurve(to: CGPoint(x: 101.45, y: 98.05), controlPoint1: CGPoint(x: 103.8, y: 95.36), controlPoint2: CGPoint(x: 101.99, y: 97.13))
        bezier41Path.addCurve(to: CGPoint(x: 100.33, y: 104.44), controlPoint1: CGPoint(x: 99.29, y: 101.75), controlPoint2: CGPoint(x: 99.22, y: 105.29))
        bezier41Path.addCurve(to: CGPoint(x: 104.03, y: 98.32), controlPoint1: CGPoint(x: 100.8, y: 104.09), controlPoint2: CGPoint(x: 102.23, y: 100.77))
        bezier41Path.close()
        color10.setFill()
        bezier41Path.fill()
        
        
        //// Bezier 42 Drawing
        let bezier42Path = UIBezierPath()
        bezier42Path.move(to: CGPoint(x: 109.23, y: 99.26))
        bezier42Path.addCurve(to: CGPoint(x: 109.37, y: 98.26), controlPoint1: CGPoint(x: 109.23, y: 99.26), controlPoint2: CGPoint(x: 109.09, y: 98.41))
        bezier42Path.addCurve(to: CGPoint(x: 110.14, y: 97.49), controlPoint1: CGPoint(x: 109.3, y: 98.08), controlPoint2: CGPoint(x: 109.9, y: 97.49))
        bezier42Path.addCurve(to: CGPoint(x: 111.12, y: 97.14), controlPoint1: CGPoint(x: 110.21, y: 97.32), controlPoint2: CGPoint(x: 110.91, y: 97.08))
        bezier42Path.addCurve(to: CGPoint(x: 112.37, y: 97.02), controlPoint1: CGPoint(x: 111.26, y: 96.93), controlPoint2: CGPoint(x: 112.16, y: 96.91))
        bezier42Path.addCurve(to: CGPoint(x: 113.56, y: 97.14), controlPoint1: CGPoint(x: 112.58, y: 96.85), controlPoint2: CGPoint(x: 113.49, y: 97.02))
        bezier42Path.addCurve(to: CGPoint(x: 114.4, y: 97.49), controlPoint1: CGPoint(x: 113.77, y: 97.05), controlPoint2: CGPoint(x: 114.47, y: 97.32))
        bezier42Path.addCurve(to: CGPoint(x: 114.95, y: 97.85), controlPoint1: CGPoint(x: 114.61, y: 97.49), controlPoint2: CGPoint(x: 114.95, y: 97.67))
        bezier42Path.addCurve(to: CGPoint(x: 115.16, y: 98.5), controlPoint1: CGPoint(x: 115.13, y: 97.85), controlPoint2: CGPoint(x: 115.2, y: 98.32))
        bezier42Path.addCurve(to: CGPoint(x: 114.61, y: 98.61), controlPoint1: CGPoint(x: 115.02, y: 98.61), controlPoint2: CGPoint(x: 114.61, y: 98.61))
        bezier42Path.addCurve(to: CGPoint(x: 114.19, y: 98.14), controlPoint1: CGPoint(x: 114.61, y: 98.61), controlPoint2: CGPoint(x: 114.26, y: 98.32))
        bezier42Path.addCurve(to: CGPoint(x: 113.63, y: 97.91), controlPoint1: CGPoint(x: 114.01, y: 98.11), controlPoint2: CGPoint(x: 113.63, y: 97.91))
        bezier42Path.addCurve(to: CGPoint(x: 112.86, y: 97.73), controlPoint1: CGPoint(x: 113.63, y: 97.91), controlPoint2: CGPoint(x: 113.14, y: 97.85))
        bezier42Path.addCurve(to: CGPoint(x: 112.02, y: 97.73), controlPoint1: CGPoint(x: 112.62, y: 97.76), controlPoint2: CGPoint(x: 112.37, y: 97.79))
        bezier42Path.addCurve(to: CGPoint(x: 110.98, y: 97.97), controlPoint1: CGPoint(x: 111.64, y: 97.88), controlPoint2: CGPoint(x: 111.4, y: 97.91))
        bezier42Path.addCurve(to: CGPoint(x: 110.28, y: 98.5), controlPoint1: CGPoint(x: 110.77, y: 98.23), controlPoint2: CGPoint(x: 110.49, y: 98.38))
        bezier42Path.addCurve(to: CGPoint(x: 110.14, y: 99.26), controlPoint1: CGPoint(x: 110.31, y: 98.85), controlPoint2: CGPoint(x: 110.14, y: 99.26))
        color11.setFill()
        bezier42Path.fill()
        color13.setStroke()
        bezier42Path.lineWidth = 1
        bezier42Path.stroke()
        
        
        //// Bezier 43 Drawing
        let bezier43Path = UIBezierPath()
        bezier43Path.move(to: CGPoint(x: 109.37, y: 98.26))
        bezier43Path.addLine(to: CGPoint(x: 110.98, y: 97.97))
        color13.setStroke()
        bezier43Path.lineWidth = 1
        bezier43Path.stroke()
        
        
        //// Bezier 44 Drawing
        let bezier44Path = UIBezierPath()
        bezier44Path.move(to: CGPoint(x: 109.23, y: 99.26))
        bezier44Path.addLine(to: CGPoint(x: 110.28, y: 98.5))
        color13.setStroke()
        bezier44Path.lineWidth = 1
        bezier44Path.stroke()
        
        
        //// Oval 9 Drawing
        let oval9Path = UIBezierPath(ovalIn: CGRect(x: 104.46, y: 101.1, width: 10, height: 9))
        color11.setFill()
        oval9Path.fill()
        
        
        //// Bezier 45 Drawing
        let bezier45Path = UIBezierPath()
        bezier45Path.move(to: CGPoint(x: 108.22, y: 101.35))
        bezier45Path.addLine(to: CGPoint(x: 108.22, y: 99.82))
        bezier45Path.addCurve(to: CGPoint(x: 109.62, y: 99.17), controlPoint1: CGPoint(x: 108.22, y: 99.82), controlPoint2: CGPoint(x: 108.29, y: 99.17))
        bezier45Path.addCurve(to: CGPoint(x: 111.15, y: 99.82), controlPoint1: CGPoint(x: 110.94, y: 99.17), controlPoint2: CGPoint(x: 111.15, y: 99.82))
        bezier45Path.addLine(to: CGPoint(x: 111.15, y: 101.35))
        color11.setFill()
        bezier45Path.fill()
        
        
        //// Bezier 46 Drawing
        let bezier46Path = UIBezierPath()
        bezier46Path.move(to: CGPoint(x: 110.14, y: 97.49))
        bezier46Path.addLine(to: CGPoint(x: 112.02, y: 97.73))
        color13.setStroke()
        bezier46Path.lineWidth = 1
        bezier46Path.stroke()
        
        
        //// Bezier 47 Drawing
        let bezier47Path = UIBezierPath()
        bezier47Path.move(to: CGPoint(x: 111.12, y: 97.14))
        bezier47Path.addLine(to: CGPoint(x: 112.86, y: 97.73))
        color13.setStroke()
        bezier47Path.lineWidth = 1
        bezier47Path.stroke()
        
        
        //// Bezier 48 Drawing
        let bezier48Path = UIBezierPath()
        bezier48Path.move(to: CGPoint(x: 112.37, y: 97.02))
        bezier48Path.addLine(to: CGPoint(x: 113.63, y: 97.91))
        color13.setStroke()
        bezier48Path.lineWidth = 1
        bezier48Path.stroke()
        
        
        //// Bezier 49 Drawing
        let bezier49Path = UIBezierPath()
        bezier49Path.move(to: CGPoint(x: 113.56, y: 97.14))
        bezier49Path.addLine(to: CGPoint(x: 114.19, y: 98.14))
        color13.setStroke()
        bezier49Path.lineWidth = 1
        bezier49Path.stroke()
        
        
        //// Bezier 50 Drawing
        let bezier50Path = UIBezierPath()
        bezier50Path.move(to: CGPoint(x: 114.95, y: 97.85))
        bezier50Path.addLine(to: CGPoint(x: 114.61, y: 98.61))
        color13.setStroke()
        bezier50Path.lineWidth = 1
        bezier50Path.stroke()
        
        
        //// Bezier 51 Drawing
        let bezier51Path = UIBezierPath()
        bezier51Path.move(to: CGPoint(x: 114.4, y: 97.49))
        bezier51Path.addLine(to: CGPoint(x: 114.61, y: 98.61))
        color13.setStroke()
        bezier51Path.lineWidth = 1
        bezier51Path.stroke()
        
        
        //// Bezier 52 Drawing
        context.saveGState()
        context.translateBy(x: 107.56, y: 70.2)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier52Path = UIBezierPath()
        bezier52Path.move(to: CGPoint(x: 31.81, y: -0.94))
        bezier52Path.addCurve(to: CGPoint(x: 31.96, y: -2.02), controlPoint1: CGPoint(x: 30.83, y: -2.44), controlPoint2: CGPoint(x: 30.67, y: -3.4))
        bezier52Path.addCurve(to: CGPoint(x: 32.37, y: -0.32), controlPoint1: CGPoint(x: 33.63, y: -0.21), controlPoint2: CGPoint(x: 32.37, y: -0.32))
        bezier52Path.addCurve(to: CGPoint(x: 31.81, y: -0.94), controlPoint1: CGPoint(x: 32.37, y: -0.32), controlPoint2: CGPoint(x: 32.1, y: -0.49))
        bezier52Path.close()
        context.saveGState()
        bezier52Path.addClip()
        context.drawLinearGradient(gradient4, start: CGPoint(x: 32.17, y: -1.81), end: CGPoint(x: 31.51, y: -1.15), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        
        
        
        //// Coin 5
        //// Oval 10 Drawing
        let oval10Path = UIBezierPath(ovalIn: CGRect(x: 88.26, y: 96.72, width: 21, height: 20))
        color12.setFill()
        oval10Path.fill()
        
        
        //// Bezier 53 Drawing
        let bezier53Path = UIBezierPath()
        bezier53Path.move(to: CGPoint(x: 93.1, y: 101.89))
        bezier53Path.addCurve(to: CGPoint(x: 94.37, y: 98.33), controlPoint1: CGPoint(x: 95.58, y: 98.52), controlPoint2: CGPoint(x: 97.83, y: 96.98))
        bezier53Path.addCurve(to: CGPoint(x: 90.52, y: 101.62), controlPoint1: CGPoint(x: 92.88, y: 98.92), controlPoint2: CGPoint(x: 91.06, y: 100.7))
        bezier53Path.addCurve(to: CGPoint(x: 89.4, y: 108.01), controlPoint1: CGPoint(x: 88.37, y: 105.31), controlPoint2: CGPoint(x: 88.29, y: 108.85))
        bezier53Path.addCurve(to: CGPoint(x: 93.1, y: 101.89), controlPoint1: CGPoint(x: 89.87, y: 107.65), controlPoint2: CGPoint(x: 91.31, y: 104.33))
        bezier53Path.close()
        color10.setFill()
        bezier53Path.fill()
        
        
        //// Bezier 54 Drawing
        let bezier54Path = UIBezierPath()
        bezier54Path.move(to: CGPoint(x: 98.31, y: 102.83))
        bezier54Path.addCurve(to: CGPoint(x: 98.45, y: 101.83), controlPoint1: CGPoint(x: 98.31, y: 102.83), controlPoint2: CGPoint(x: 98.17, y: 101.97))
        bezier54Path.addCurve(to: CGPoint(x: 99.21, y: 101.06), controlPoint1: CGPoint(x: 98.38, y: 101.65), controlPoint2: CGPoint(x: 98.97, y: 101.06))
        bezier54Path.addCurve(to: CGPoint(x: 100.19, y: 100.71), controlPoint1: CGPoint(x: 99.28, y: 100.88), controlPoint2: CGPoint(x: 99.98, y: 100.65))
        bezier54Path.addCurve(to: CGPoint(x: 101.45, y: 100.59), controlPoint1: CGPoint(x: 100.33, y: 100.5), controlPoint2: CGPoint(x: 101.24, y: 100.47))
        bezier54Path.addCurve(to: CGPoint(x: 102.63, y: 100.71), controlPoint1: CGPoint(x: 101.66, y: 100.41), controlPoint2: CGPoint(x: 102.56, y: 100.59))
        bezier54Path.addCurve(to: CGPoint(x: 103.47, y: 101.06), controlPoint1: CGPoint(x: 102.84, y: 100.62), controlPoint2: CGPoint(x: 103.54, y: 100.88))
        bezier54Path.addCurve(to: CGPoint(x: 104.03, y: 101.41), controlPoint1: CGPoint(x: 103.68, y: 101.06), controlPoint2: CGPoint(x: 104.03, y: 101.24))
        bezier54Path.addCurve(to: CGPoint(x: 104.24, y: 102.06), controlPoint1: CGPoint(x: 104.2, y: 101.41), controlPoint2: CGPoint(x: 104.27, y: 101.88))
        bezier54Path.addCurve(to: CGPoint(x: 103.68, y: 102.18), controlPoint1: CGPoint(x: 104.1, y: 102.18), controlPoint2: CGPoint(x: 103.68, y: 102.18))
        bezier54Path.addCurve(to: CGPoint(x: 103.26, y: 101.71), controlPoint1: CGPoint(x: 103.68, y: 102.18), controlPoint2: CGPoint(x: 103.33, y: 101.88))
        bezier54Path.addCurve(to: CGPoint(x: 102.7, y: 101.47), controlPoint1: CGPoint(x: 103.09, y: 101.68), controlPoint2: CGPoint(x: 102.7, y: 101.47))
        bezier54Path.addCurve(to: CGPoint(x: 101.93, y: 101.3), controlPoint1: CGPoint(x: 102.7, y: 101.47), controlPoint2: CGPoint(x: 102.21, y: 101.41))
        bezier54Path.addCurve(to: CGPoint(x: 101.1, y: 101.3), controlPoint1: CGPoint(x: 101.69, y: 101.32), controlPoint2: CGPoint(x: 101.45, y: 101.35))
        bezier54Path.addCurve(to: CGPoint(x: 100.05, y: 101.53), controlPoint1: CGPoint(x: 100.71, y: 101.44), controlPoint2: CGPoint(x: 100.47, y: 101.47))
        bezier54Path.addCurve(to: CGPoint(x: 99.35, y: 102.06), controlPoint1: CGPoint(x: 99.84, y: 101.8), controlPoint2: CGPoint(x: 99.56, y: 101.94))
        bezier54Path.addCurve(to: CGPoint(x: 99.21, y: 102.83), controlPoint1: CGPoint(x: 99.39, y: 102.41), controlPoint2: CGPoint(x: 99.21, y: 102.83))
        color11.setFill()
        bezier54Path.fill()
        color13.setStroke()
        bezier54Path.lineWidth = 1
        bezier54Path.stroke()
        
        
        //// Bezier 55 Drawing
        let bezier55Path = UIBezierPath()
        bezier55Path.move(to: CGPoint(x: 98.45, y: 101.83))
        bezier55Path.addLine(to: CGPoint(x: 100.05, y: 101.53))
        color13.setStroke()
        bezier55Path.lineWidth = 1
        bezier55Path.stroke()
        
        
        //// Bezier 56 Drawing
        let bezier56Path = UIBezierPath()
        bezier56Path.move(to: CGPoint(x: 98.31, y: 102.83))
        bezier56Path.addLine(to: CGPoint(x: 99.35, y: 102.06))
        color13.setStroke()
        bezier56Path.lineWidth = 1
        bezier56Path.stroke()
        
        
        //// Oval 11 Drawing
        let oval11Path = UIBezierPath(ovalIn: CGRect(x: 93.53, y: 104.67, width: 10, height: 9))
        color11.setFill()
        oval11Path.fill()
        
        
        //// Bezier 57 Drawing
        let bezier57Path = UIBezierPath()
        bezier57Path.move(to: CGPoint(x: 97.3, y: 104.92))
        bezier57Path.addLine(to: CGPoint(x: 97.3, y: 103.39))
        bezier57Path.addCurve(to: CGPoint(x: 98.69, y: 102.74), controlPoint1: CGPoint(x: 97.3, y: 103.39), controlPoint2: CGPoint(x: 97.37, y: 102.74))
        bezier57Path.addCurve(to: CGPoint(x: 100.23, y: 103.39), controlPoint1: CGPoint(x: 100.02, y: 102.74), controlPoint2: CGPoint(x: 100.23, y: 103.39))
        bezier57Path.addLine(to: CGPoint(x: 100.23, y: 104.92))
        color11.setFill()
        bezier57Path.fill()
        
        
        //// Bezier 58 Drawing
        let bezier58Path = UIBezierPath()
        bezier58Path.move(to: CGPoint(x: 99.21, y: 101.06))
        bezier58Path.addLine(to: CGPoint(x: 101.1, y: 101.3))
        color13.setStroke()
        bezier58Path.lineWidth = 1
        bezier58Path.stroke()
        
        
        //// Bezier 59 Drawing
        let bezier59Path = UIBezierPath()
        bezier59Path.move(to: CGPoint(x: 100.19, y: 100.71))
        bezier59Path.addLine(to: CGPoint(x: 101.93, y: 101.3))
        color13.setStroke()
        bezier59Path.lineWidth = 1
        bezier59Path.stroke()
        
        
        //// Bezier 60 Drawing
        let bezier60Path = UIBezierPath()
        bezier60Path.move(to: CGPoint(x: 101.45, y: 100.59))
        bezier60Path.addLine(to: CGPoint(x: 102.7, y: 101.47))
        color13.setStroke()
        bezier60Path.lineWidth = 1
        bezier60Path.stroke()
        
        
        //// Bezier 61 Drawing
        let bezier61Path = UIBezierPath()
        bezier61Path.move(to: CGPoint(x: 102.63, y: 100.71))
        bezier61Path.addLine(to: CGPoint(x: 103.26, y: 101.71))
        color13.setStroke()
        bezier61Path.lineWidth = 1
        bezier61Path.stroke()
        
        
        //// Bezier 62 Drawing
        let bezier62Path = UIBezierPath()
        bezier62Path.move(to: CGPoint(x: 104.03, y: 101.41))
        bezier62Path.addLine(to: CGPoint(x: 103.68, y: 102.18))
        color13.setStroke()
        bezier62Path.lineWidth = 1
        bezier62Path.stroke()
        
        
        //// Bezier 63 Drawing
        let bezier63Path = UIBezierPath()
        bezier63Path.move(to: CGPoint(x: 103.47, y: 101.06))
        bezier63Path.addLine(to: CGPoint(x: 103.68, y: 102.18))
        color13.setStroke()
        bezier63Path.lineWidth = 1
        bezier63Path.stroke()
        
        
        //// Bezier 64 Drawing
        context.saveGState()
        context.translateBy(x: 96.64, y: 73.77)
        context.rotate(by: 93.76 * CGFloat.pi/180)
        
        let bezier64Path = UIBezierPath()
        bezier64Path.move(to: CGPoint(x: 31.81, y: -0.94))
        bezier64Path.addCurve(to: CGPoint(x: 31.96, y: -2.02), controlPoint1: CGPoint(x: 30.83, y: -2.44), controlPoint2: CGPoint(x: 30.67, y: -3.4))
        bezier64Path.addCurve(to: CGPoint(x: 32.37, y: -0.32), controlPoint1: CGPoint(x: 33.63, y: -0.21), controlPoint2: CGPoint(x: 32.37, y: -0.32))
        bezier64Path.addCurve(to: CGPoint(x: 31.81, y: -0.94), controlPoint1: CGPoint(x: 32.37, y: -0.32), controlPoint2: CGPoint(x: 32.1, y: -0.49))
        bezier64Path.close()
        context.saveGState()
        bezier64Path.addClip()
        context.drawLinearGradient(gradient4, start: CGPoint(x: 32.17, y: -1.81), end: CGPoint(x: 31.51, y: -1.15), options: [])
        context.restoreGState()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    @objc(MoneyPacksDrawResizingBehavior)
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

