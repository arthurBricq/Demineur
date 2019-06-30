//
//  LineMessageManager.swift
//  Demineur
//
//  Created by Marin on 30/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

class LineMessageManager: UILabel {
    
    var time: Double
    
    init(viewToAddIn: UIView, yOrigin: CGFloat, text: String, timeOnScreen: Double, textColor: UIColor, font: UIFont = UIFont(name: "PingFangSC-Regular", size: 20)!) {
        self.time = timeOnScreen
        let width = viewToAddIn.frame.width
        let height = text.height(withConstrainedWidth: width, font: font)
        let frame = CGRect (origin: CGPoint(x: 0, y: yOrigin), size: CGSize(width: width, height: height))
        super.init(frame: frame)
        self.font = font
        self.text = text
        self.textColor = textColor
        self.alpha = 0
        self.textAlignment = .center
        viewToAddIn.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    public func showMessage() {
        self.alpha = 0
        
        UIView.animateKeyframes(withDuration: time, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                self.alpha = 1
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.alpha = 0
            })
            
        }) { (_) in
            self.removeFromSuperview()
        }
        
    }
    
}
