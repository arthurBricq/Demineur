//
//  Variables.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 03/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Definition des parties

struct ColorSetForOneGame {
    var openColor = UIColor.white // color for open-case's background
    var emptyColor = UIColor.white // color for empty-case's background
    var strokeColor = UIColor.white
    var textColor = UIColor.black
}



// MARK: - Mode Histoire

let historyLevels: [OneGame] = [OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 7, m: 7, z: 5, totalTime: 90),
                                OneGame(gameTypeWithOption3WithoutNoneCases: .square, n: 10, m: 10, z: 15, totalTime: 90, option3Time: 5, option3Frequency: 0.7),
                                //OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 10, m: 10, z: 12, totalTime: 90),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 10, m: 10, z: 15, totalTime: 90),
                                
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 8, m: 11, z: 2, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 10, m: 11, z: 3, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 10, m: 13, z: 4, totalTime: 60),
                                
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 10, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 20, m: 15, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 15, m: 10, z: 4, totalTime: 60),
                                
                                
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 4, totalTime: 60),
                                
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases:.hexagonal , n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 13, m: 10, z: 4, totalTime: 60),
                                
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 13, m: 10, z: 4, totalTime: 60),
                                
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 15, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 17, m: 10, z: 4, totalTime: 60),
                                 
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases:.hexagonal , n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 15, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 17, m: 10, z: 4, totalTime: 60),
                                 
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 15, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 17, m: 10, z: 4, totalTime: 60)
                                
    
    
    
    /* OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 16, m: 10, z: 10, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 10, m: 11, z: 10, totalTime: 60),
                                OneGame(gameTypeWithOption1WithoutNoneCases: .hexagonal, n: 15, m: 10, z: 10, totalTime: 60, option1Time: 10),
                                OneGame(gameTypeWithOption2WithoutNoneCases: .square, n: 15, m: 10, z: 10, totalTime: 60, option2Frequency: 0.2),
                                OneGame(gameTypeWithOption3WithoutNoneCases: .square, n: 12, m: 11, z: 16, totalTime: 90, option3Time: 5, option3Frequency: 0.7),
                                OneGame(hexagonalPyramid7x7GameTime: 60, z: 5),
                                OneGame(squareHeart12x13GameTime: 60, z: 8),
                                OneGame(triangularButterfly4x7GameTime: 60, z: 4),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 20, totalTime: 90),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 13, m: 10, z: 20, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 16, m: 10, z: 10, totalTime: 60),
                                OneGame(gameTypeWithOption1WithoutNoneCases: .hexagonal, n: 15, m: 10, z: 20, totalTime: 60, option1Time: 10),
                                OneGame(gameTypeWithOption2WithoutNoneCases: .square, n: 15, m: 10, z: 20, totalTime: 60, option2Frequency: 0.2),
                                OneGame(gameTypeWithOption3WithoutNoneCases: .square, n: 12, m: 11, z: 25, totalTime: 90, option3Time: 5, option3Frequency: 0.7),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 16, m: 10, z: 10, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 10, m: 11, z: 10, totalTime: 60),
                                OneGame(gameTypeWithOption1WithoutNoneCases: .hexagonal, n: 15, m: 10, z: 10, totalTime: 60, option1Time: 10),
                                OneGame(gameTypeWithOption2WithoutNoneCases: .square, n: 15, m: 10, z: 10, totalTime: 60, option2Frequency: 0.2),
                                OneGame(gameTypeWithOption3WithoutNoneCases: .square, n: 12, m: 11, z: 16, totalTime: 90, option3Time: 5, option3Frequency: 0.7),
                                OneGame(hexagonalPyramid7x7GameTime: 60, z: 5),
                                OneGame(squareHeart12x13GameTime: 60, z: 8),
                                OneGame(triangularButterfly4x7GameTime: 60, z: 4),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 20, totalTime: 90),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 13, m: 10, z: 20, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 16, m: 10, z: 10, totalTime: 60),
                                OneGame(gameTypeWithOption1WithoutNoneCases: .hexagonal, n: 15, m: 10, z: 20, totalTime: 60, option1Time: 10),
                                OneGame(gameTypeWithOption2WithoutNoneCases: .square, n: 15, m: 10, z: 20, totalTime: 60, option2Frequency: 0.2),
                                OneGame(gameTypeWithOption3WithoutNoneCases: .square, n: 12, m: 11, z: 25, totalTime: 90, option3Time: 5, option3Frequency: 0.7),
                                 OneGame(gameTypeWithOption3WithoutNoneCases: .square, n: 12, m: 11, z: 25, totalTime: 90, option3Time: 5, option3Frequency: 0.7) */
]





var isTheGameStarted = IsTheGameStarted(value: false)

let k: CGFloat = 0.86603 // variable such that w = k*h.
let maximumDifficulty: Int = 5 // Indice de la difficulté la plus élevée.



// MARK: - Modèle de données pour les tablesView de la boutique



// Thèmes de couleurs pour le jeu
/* Ordre des couleurs :
        1) Fond d'écran
        2) Lignes principales
        3) Textes et lignes secondaires
 */
struct ColorTheme {
    let name: String
    let price: Int
    let colors: [UIColor]
//     var isUnlocked: Bool
}

var allThemes: [ColorTheme] = [
    ColorTheme(name: "Classic", price: 0, colors: [colorForRGB(r: 255, g: 255, b: 255), colorForRGB(r: 184, g: 120, b: 0), colorForRGB(r: 66, g: 66, b: 66)]/*, isUnlocked: true*/),
    ColorTheme(name: "Cartoon", price: 2500, colors: [colorForRGB(r: 204, g: 255, b: 153), colorForRGB(r: 0, g: 102, b: 255), colorForRGB(r: 204, g: 51, b: 153)]/*, isUnlocked: true*/),
    ColorTheme(name: "Dark", price: 3000, colors: [colorForRGB(r: 55, g: 22, b: 55), colorForRGB(r: 153, g: 102, b: 0), colorForRGB(r: 179, g: 179, b: 179)]/*, isUnlocked: true*/)
]
// var selectedTheme: Int = 0
