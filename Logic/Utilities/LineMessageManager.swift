//
//  LineMessageManager.swift
//  Demineur
//
//  Created by Marin on 30/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

/// This class shows a linear message on the screen which appears on the screen for a given time, it then disappears and the instance of the class is removed.
class LineMessageManager {
    
    // MARK: - Variables
    
    var time: Double
    var viewToAddIn: UIView
    var yOrigin: CGFloat
    var textColor: UIColor
    var font: UIFont
    
    // MARK: - Constants
    
    let tagIndex = 34
    
    // MARK: - Functions
    
    init(viewToAddIn: UIView, yOrigin: CGFloat, timeOnScreen: Double, textColor: UIColor, font: UIFont = UIFont(name: "PingFangSC-Regular", size: 20)!) {
        self.time = timeOnScreen
        self.viewToAddIn = viewToAddIn
        self.yOrigin = yOrigin
        self.textColor = textColor
        self.font = font
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   /// Add one message on the correct position on screen
    public func showMessage(_ text: String) {
    
        getLabelOnScreen()?.removeFromSuperview()
        
        let lbl = UILabel()
        lbl.alpha = 0
        lbl.font = font
        lbl.tag = tagIndex
        lbl.textColor = textColor
        lbl.textAlignment = .center
        let width = viewToAddIn.frame.width
        let height = text.height(withConstrainedWidth: width, font: font)
        let frame = CGRect (origin: CGPoint(x: 0, y: yOrigin), size: CGSize(width: width, height: height))
        lbl.frame = frame
        lbl.text = text
        viewToAddIn.addSubview(lbl)
        
        
        UIView.animateKeyframes(withDuration: time/0.7, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15, animations: {
                lbl.alpha = 1
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.15, animations: {
                lbl.alpha = 0
            })
            
        }) { (_) in
            lbl.removeFromSuperview()
        }
        
    }
    
    private func getLabelOnScreen() -> UILabel? {
        for v in self.viewToAddIn.subviews {
            if v.tag == tagIndex {
                return (v as? UILabel)
            }
        }
        return nil
    }
    
}
