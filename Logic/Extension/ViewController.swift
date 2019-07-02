//
//  ViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 28/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Functions for the round message
    
    /// Display a round box, with a title, a message, and one or two buttons.
    public func displayRoundBox(title: String, withMessage message: String, buttonNames: [String], buttonActions: [(()->Void)], backgroundColor: UIColor = .white, delay: CGFloat = 0.0) {
        
        // 1. Compute the dimensions of the box one need to create
        let width: CGFloat = self.view.frame.width * 0.9
        let textWidth = width - 40
        let font = UIFont(name: "PingFangSC-Thin", size: 17)
        let titleFont = UIFont(name: "PingFangSC-SemiBold", size: 25)
        let heightOfText = message.height(withConstrainedWidth: textWidth, font: font!)
        let heightOfTitle: CGFloat = 30
        let heightOfButtons: CGFloat = 25
        let widthOfTitle = title.width(withConstrainedHeight: heightOfTitle, font: titleFont!)
        let height: CGFloat = heightOfText + heightOfButtons + heightOfTitle + 75
        // And obtain the side of the box
        let side: CGFloat = width > height ? width : height
        
        // 2. Put the subviews in the right places
        let box = UIView(frame: CGRect(x: view.frame.width/2-side/2, y: 150, width: side, height: side))
        let firstY: CGFloat = 40
        let titleLabel = UILabel(frame: CGRect(x: side/2 - widthOfTitle/2, y: firstY, width: widthOfTitle, height: heightOfTitle))
        titleLabel.font = titleFont
        titleLabel.text = title
        titleLabel.textColor = UIColor.darkText
        box.addSubview(titleLabel)
        let yForText: CGFloat = side/2 - (heightOfText+10)/2
        let textLabel = UILabel(frame: CGRect(x: side/2 - textWidth/2, y: yForText, width: textWidth, height: heightOfText))
        textLabel.font = font
        textLabel.text = message
        textLabel.textColor = UIColor.darkText
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .justified
        box.addSubview(textLabel)
        
        // 3. Treat the cases of one or two buttons
        if buttonNames.count == 1 {
            let widthOfButton = buttonNames[0].width(withConstrainedHeight: heightOfButtons, font: font!)
            let button = UIButton(frame: CGRect(x: side/2 - widthOfButton/2, y: side-heightOfButtons-40, width: widthOfButton, height: heightOfButtons))
            button.setTitle(buttonNames[0], for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = font!
            button.addAction(for: .touchUpInside, transformClosureForButton(b: button, box: box, closure: buttonActions[0]))
            box.addSubview(button)
        } else if buttonNames.count == 2 {
            let dec: CGFloat = 40
            let w1 = buttonNames[0].width(withConstrainedHeight: heightOfButtons, font: font!)
            let w2 = buttonNames[1].width(withConstrainedHeight: heightOfButtons, font: font!)
            let b1 = UIButton(frame: CGRect(x: side/2 - w1/2 - dec, y: side-heightOfButtons-40, width: w1, height: heightOfButtons))
            b1.setTitle(buttonNames[0], for: .normal)
            b1.titleLabel?.font = font!
            b1.addAction(for: .touchUpInside, transformClosureForButton(b: b1, box: box, closure: buttonActions[0]))
            let b2 = UIButton(frame: CGRect(x: side/2 - w2/2 + dec, y: side-heightOfButtons-20, width: w1, height: heightOfButtons))
            b2.setTitle(buttonNames[1], for: .normal)
            b2.titleLabel?.font = font!
            b2.addAction(for: .touchUpInside, transformClosureForButton(b: b2, box: box, closure: buttonActions[1]))
            box.addSubview(b1)
            box.addSubview(b2)
        }
        
        // 4. Box's gestion
        box.layer.cornerRadius = side/2
        box.layer.borderColor = UIColor.brown.cgColor
        box.layer.borderWidth = 2.0
        box.backgroundColor = backgroundColor
        
        box.alpha = 0.0
        self.view.addSubview(box)
        
        UIView.animate(withDuration: 0.9, delay: TimeInterval(delay), options: [], animations: {
            box.alpha = 1.0
        }, completion: nil)
      
    }
    
    /// Takes a closure as parameter, and transform it into a new closure that will animate the button when tapped over it.
    fileprivate func transformClosureForButton(b: UIButton, box: UIView,  closure: @escaping ()->Void) -> (()->Void) {
        let newClosure = {
            b.alpha = 0.5
            closure()
            UIView.animate(withDuration: 0.5, delay: 0.0 , options: [], animations: {
                b.alpha = 1.0
                box.alpha = 0.0
            }, completion: { (_) -> Void in
                box.removeFromSuperview()
            })
        }
        return newClosure
    }
    
    // MARK: - Functions for the 'interactive tutorial'

    
    
    
    
    
}
