//
//  InAppPurchaseButton.swift
//  Demineur
//
//  Created by Marin on 15/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class InAppPurchaseButton: UIButton {

    var text: String = "$0.99"
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        InAppPurchaseButtonDraw.drawInAppPurchaseDraw(frame: rect, resizing: .aspectFill, text: text)
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

public class InAppPurchaseButtonDraw : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawInAppPurchaseDraw(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 100), resizing: ResizingBehavior = .aspectFit, text: String = "$0.99") {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 200, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 200, y: resizedFrame.height / 100)
        
        
        //// Color Declarations
        let backgroundColor = UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1.000)
        let textColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 10, y: 10, width: 180, height: 80), cornerRadius: 15)
        backgroundColor.setFill()
        rectanglePath.fill()
        
        
        //// TextLabel Drawing
        let textLabelRect = CGRect(x: 25, y: 25, width: 150, height: 50)
        let textLabelStyle = NSMutableParagraphStyle()
        textLabelStyle.alignment = .center
        let textLabelFontAttributes = [
            .font: UIFont(name: "PingFangSC-Regular", size: 45)!,
            .foregroundColor: textColor,
            .paragraphStyle: textLabelStyle,
            ] as [NSAttributedStringKey: Any]
        
        let textLabelTextHeight: CGFloat = text.boundingRect(with: CGSize(width: textLabelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textLabelFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textLabelRect)
        text.draw(in: CGRect(x: textLabelRect.minX, y: textLabelRect.minY + (textLabelRect.height - textLabelTextHeight) / 2, width: textLabelRect.width, height: textLabelTextHeight), withAttributes: textLabelFontAttributes)
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(InAppPurchaseButtonDrawResizingBehavior)
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
