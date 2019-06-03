//
//  MessageEndOfSection.swift
//  Demineur
//
//  Created by Marin on 14/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class MessageEndOfSection: UIView {

    var circleColor: UIColor = colorForRGB(r: 242, g: 180, b: 37)
    var textColor: UIColor = colorForRGB(r: 255, g: 255, b: 255)
    var fontSizeNumber: CGFloat = 60
    var fontSizeLevel: CGFloat = 14
    var sectionIndex: Int = 1
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        EndOfSectionMessage.drawMessageEndOfSection(frame: rect, resizing: .aspectFill, circleColor: circleColor, textColor: textColor, fontSizeNumber: fontSizeNumber, sectionIndex: String(sectionIndex), fontSizeLevel: fontSizeLevel)
        
    }
    

}

public class EndOfSectionMessage : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawMessageEndOfSection(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), resizing: ResizingBehavior = .aspectFit, circleColor: UIColor = UIColor(red: 0.949, green: 0.706, blue: 0.145, alpha: 1.000), textColor: UIColor = UIColor(red: 0.984, green: 0.984, blue: 0.984, alpha: 1.000), fontSizeNumber: CGFloat = 61, sectionIndex: String = "1", fontSizeLevel: CGFloat = 14) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 100, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 100, y: resizedFrame.height / 100)
        
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100))
        circleColor.setFill()
        ovalPath.fill()
        
        
        //// Text 2 Drawing
        let text2Rect = CGRect(x: 22, y: 11, width: 57, height: 14)
        let text2TextContent = "Niveau"
        let text2Style = NSMutableParagraphStyle()
        text2Style.alignment = .center
        let text2FontAttributes = [
            .font: UIFont.systemFont(ofSize: fontSizeLevel),
            .foregroundColor: textColor,
            .paragraphStyle: text2Style,
            ] as [NSAttributedString.Key: Any]
        
        let text2TextHeight: CGFloat = text2TextContent.boundingRect(with: CGSize(width: text2Rect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: text2FontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: text2Rect)
        text2TextContent.draw(in: CGRect(x: text2Rect.minX, y: text2Rect.minY + (text2Rect.height - text2TextHeight) / 2, width: text2Rect.width, height: text2TextHeight), withAttributes: text2FontAttributes)
        context.restoreGState()
        
        
        //// Text 3 Drawing
        let text3Rect = CGRect(x: 0, y: 29, width: 100, height: 50)
        let text3Style = NSMutableParagraphStyle()
        text3Style.alignment = .center
        let text3FontAttributes = [
            .font: UIFont(name: "PingFangSC-Regular", size: fontSizeNumber)!,
            .foregroundColor: textColor,
            .paragraphStyle: text3Style,
            ] as [NSAttributedString.Key: Any]
        
        let text3TextHeight: CGFloat = sectionIndex.boundingRect(with: CGSize(width: text3Rect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: text3FontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: text3Rect)
        sectionIndex.draw(in: CGRect(x: text3Rect.minX, y: text3Rect.minY + (text3Rect.height - text3TextHeight) / 2, width: text3Rect.width, height: text3TextHeight), withAttributes: text3FontAttributes)
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(EndOfSectionMessageResizingBehavior)
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
