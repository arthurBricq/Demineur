//
//  BonusChoiceView.swift
//  Demineur
//
//  Created by Marin on 18/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class BonusChoiceColor {
    var backgroundColorRuban: UIColor = UIColor(red: 0.522, green: 0.522, blue: 0.522, alpha: 1.000)
    var starColor: UIColor = UIColor(red: 0.800, green: 0.574, blue: 0.354, alpha: 1.000)
    var backgroundContainer: UIColor = UIColor(red: 0.796, green: 0.796, blue: 0.796, alpha: 1.000)
}
var bonusChoiceColor = BonusChoiceColor()


class BonusChoiceView: UIView {
    
    @objc public dynamic var progress: CGFloat = 0 {
        didSet {
            progressLayer.progress = progress
        }
    }
    
    fileprivate var progressLayer: BonusChoiceLayer {
        return layer as! BonusChoiceLayer
    }

    override public class var layerClass: AnyClass {
        return BonusChoiceLayer.self
    }
    
    override public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == #keyPath(BonusChoiceLayer.progress), let action = action(for: layer, forKey: #keyPath(backgroundColor)) as? CAAnimation {
            
            let animation = CABasicAnimation()
            animation.keyPath = #keyPath(BonusChoiceLayer.progress)
            animation.fromValue = progressLayer.progress
            animation.toValue = progress
            animation.beginTime = action.beginTime
            animation.duration = action.duration
            animation.speed = action.speed
            animation.timeOffset = action.timeOffset
            animation.repeatCount = action.repeatCount
            animation.repeatDuration = action.repeatDuration
            animation.autoreverses = action.autoreverses
            animation.fillMode = action.fillMode
            animation.timingFunction = action.timingFunction
            animation.delegate = action.delegate
            self.layer.add(animation, forKey: #keyPath(BonusChoiceLayer.progress))
            
        }
        return super.action(for: layer, forKey: event)
    }
    
}

class BonusChoiceLayer: CALayer {
    
    @NSManaged var progress: CGFloat
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(progress) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        UIGraphicsPushContext(ctx)
        
        BonusChoiceProgress.drawBonusChoice(frame: frame, resizing: .aspectFill, progress: progress)
        
        UIGraphicsPopContext()
    }
    
}

public class BonusChoiceProgress : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawBonusChoice(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 600, height: 100), resizing: ResizingBehavior = .aspectFit, progress: CGFloat = 0) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 600, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 600, y: resizedFrame.height / 100)
        
        /// Color Declarations
        let backgroundColorRuban: UIColor = bonusChoiceColor.backgroundColorRuban
        let starColor: UIColor = bonusChoiceColor.starColor
        let backgroundContainer: UIColor = bonusChoiceColor.backgroundContainer
        
        //// Variable Declarations
        let widthOfRuban: CGFloat = 100 + progress * 500
        let xPosOfStar: CGFloat = 10 + progress * 495
        let widthOfContainer: CGFloat = progress * 450
        let starRotation: CGFloat = -progress * 144
        let alpha: CGFloat = progress
        
        //// Ruban Drawing
        let rubanPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: widthOfRuban, height: 100), cornerRadius: 50)
        backgroundColorRuban.setFill()
        rubanPath.fill()
        
        
        //// Container Drawing
        context.saveGState()
        context.setAlpha(alpha)
        
        let containerPath = UIBezierPath(roundedRect: CGRect(x: 42, y: 7.5, width: widthOfContainer, height: 85), cornerRadius: 0.5)
        backgroundContainer.setFill()
        containerPath.fill()
        
        context.restoreGState()
        
        
        //// Star Drawing
        context.saveGState()
        context.translateBy(x: (xPosOfStar + 40), y: 50)
        context.rotate(by: -starRotation * CGFloat.pi/180)
        
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 0, y: -40))
        starPath.addLine(to: CGPoint(x: 11.74, y: -16.15))
        starPath.addLine(to: CGPoint(x: 38.04, y: -12.36))
        starPath.addLine(to: CGPoint(x: 18.99, y: 6.17))
        starPath.addLine(to: CGPoint(x: 23.51, y: 32.36))
        starPath.addLine(to: CGPoint(x: 0, y: 19.97))
        starPath.addLine(to: CGPoint(x: -23.51, y: 32.36))
        starPath.addLine(to: CGPoint(x: -18.99, y: 6.17))
        starPath.addLine(to: CGPoint(x: -38.04, y: -12.36))
        starPath.addLine(to: CGPoint(x: -11.74, y: -16.15))
        starPath.close()
        starColor.setFill()
        starPath.fill()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(BonusChoiceProgressResizingBehavior)
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
