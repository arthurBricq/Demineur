//
//  Color.swift
//  Demineur
//
//  Created by Marin on 02/07/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

struct ColorTheme {
    let name: String
    let price: Int
    let colors: [UIColor] // Ordre des couleurs :
    /* colors : [
        background,
        lignes principales,
        lignes secondaires ou titres,
        textes,
        couleur infini game mode 2
        couleur infini game mode 3
        couleur infini game mode 4
        couleur infini game mode 5
        couleur infini game mode 6
        ]
 
    */
}

class Color {
    
    static let allThemes: [ColorTheme] = [
        ColorTheme(name: "Classic", price: 0, colors: [
            Color.rgb(255, 255, 255),
            Color.rgb(184, 120, 0),
            Color.rgb(66, 66, 66),
            Color.rgb(121, 121, 121),
            Color.rgb(255, 255, 153),
            Color.rgb(255, 204, 0),
            Color.rgb(255, 153, 102),
            Color.rgb(255, 102, 102),
            Color.rgb(255, 153, 0)
            ]),
        
        ColorTheme(name: "Cartoon", price: 2500, colors: [
            Color.rgb(204, 255, 153),
            Color.rgb(0, 102, 255),
            Color.rgb(204, 51, 153),
            Color.rgb(250, 100, 200),
            Color.rgb(153, 255, 204),
            Color.rgb(51, 204, 255),
            Color.rgb(204, 153, 255),
            Color.rgb(255, 102, 255),
            Color.rgb(255, 102, 153)
            ]),
        
        ColorTheme(name: "Dark", price: 3000, colors: [
            Color.rgb(55, 22, 55),
            Color.rgb(153, 102, 0),
            Color.rgb(179, 179, 179),
            Color.rgb(230, 230, 230),
            Color.rgb(102, 0, 51),
            Color.rgb(128, 0, 0),
            Color.rgb(102, 0, 102),
            Color.rgb(0, 0, 102),
            Color.rgb(0, 51, 102)
            ])
    ]
    
    static func getColor(index i: Int) -> UIColor {
        return Color.allThemes[dataManager.currentTheme].colors[i]
    }
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    
}


