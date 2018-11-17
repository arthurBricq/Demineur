//
//  Animator.swift
//  Demineur
//
//  Created by Marin on 15/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class Animator: NSObject {

    func fadeIn(duration: Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        return animation
    }
    
    func fadeOut(duration: Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = duration
        return animation
    }
    
}
