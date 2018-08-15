//
//  MoneyPackages.swift
//  Demineur
//
//  Created by Marin on 15/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class MoneyPackages: UIView {

    enum PackageSize {
        case small
        case medium
        case large
    }
    
    // La taille du pack, change son visuel et la quantité d'argent
    var size: PackageSize = .small
    
    // Computed properties qui retourne la quantité d'argent du pack, il suffit de changer ses trois valeurs pour modifier tous les packs
    var amountOfMoney: Int {
        get {
            switch self.size {
            case .small:
                return 10
                
            case .medium:
                return 100
                
            case .large:
                return 1000
                
            }
        }
    }
    
    //////// A REMPLIR ////////
    override func draw(_ rect: CGRect) {
        
        switch size {
        case .small:
            break
            
        case .medium:
            break
            
        case .large:
            break
        }
        
    }

}
