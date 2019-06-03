//
//  UIView.swift
//  Demineur
//
//  Created by Arthur BRICQ on 28/05/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

extension UIView {
    
    public func makeDarkBorderDisplay() {
        self.layer.borderColor = colorForRGB(r: 94, g: 94, b: 94).cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 15.0
    }
    
    public func makeGrayBorderDisplay() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 15.0
    }
    
    public func makeGreenBorderDisplay() {
        self.layer.borderColor = colorForRGB(r: 79, g: 143, b: 0).cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 15.0
    }
    
    public func makeRedBorderDisplay() {
        self.layer.borderColor = colorForHexString(hex: "FF9273").cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 15.0
    }
}

