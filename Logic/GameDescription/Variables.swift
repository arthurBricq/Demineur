//
//  Variables.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 03/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit

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

