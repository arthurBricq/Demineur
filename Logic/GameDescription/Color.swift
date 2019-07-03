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
    let colors: [UIColor] // Ordre des couleurs : [background, lignes principales, lignes secondaires ou titres, textes]
}

class Color {
    
    static let allThemes: [ColorTheme] = [
        ColorTheme(name: "Classic", price: 0, colors: [colorForRGB(r: 255, g: 255, b: 255), colorForRGB(r: 184, g: 120, b: 0), colorForRGB(r: 66, g: 66, b: 66), colorForRGB(r: 121, g: 121, b: 121)]),
        ColorTheme(name: "Cartoon", price: 2500, colors: [colorForRGB(r: 204, g: 255, b: 153), colorForRGB(r: 0, g: 102, b: 255), colorForRGB(r: 204, g: 51, b: 153), colorForRGB(r: 250, g: 100, b: 200)]),
        ColorTheme(name: "Dark", price: 3000, colors: [colorForRGB(r: 55, g: 22, b: 55), colorForRGB(r: 153, g: 102, b: 0), colorForRGB(r: 179, g: 179, b: 179), colorForRGB(r: 230, g: 230, b: 230)])
    ]
    
    static func getColor(index i: Int) -> UIColor {
        return Color.allThemes[dataManager.currentTheme].colors[i]
    }
    
}

