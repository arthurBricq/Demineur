//
//  Vibrate.swift
//  DemineIt
//
//  Created by Marin on 06/06/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices

class Vibrate: NSObject {
    
    func vibrate() {
        if hasImpactGenerator {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        } else {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }
    
    func vibrate(style: UIImpactFeedbackStyle) {
        if hasImpactGenerator {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        } else {
            switch style {
            case .light:
                AudioServicesPlaySystemSound(1519)
            case .medium:
                AudioServicesPlayAlertSound(1520)
            case .heavy:
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            }
        }
    }
    
    /// Returns true if it's an iPhone 7 or higher
    private var hasImpactGenerator: Bool {
        return !(["iPhone1,1", "iPhone1,2", "iPhone2,1", "iPhone3,1", "iPhone3,2", "iPhone3,3", "iPhone4,1", "iPhone5,1", "iPhone5,2", "iPhone5,3", "iPhone5,4", "iPhone6,1", "iPhone6,2", "iPhone7,2", "iPhone7,1", "iPhone8,1", "iPhone8,2", "iPhone8,4"].contains(modelIdentifier()))
    }
    
}
