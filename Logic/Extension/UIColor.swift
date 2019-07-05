//
//  UIColor.swift
//  Demineur
//
//  Created by Marin on 05/07/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Return true if the brightness of the color is inferior to 0.5
    func isDark() -> Bool {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            if brightness >= 0.5 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
}
