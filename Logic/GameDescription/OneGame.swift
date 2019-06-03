//
//  OneGame.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class OneGame  {
    
    var gameType: GameType = .square
    var n: Int = 4
    var m: Int = 4
    var z: Int = 4
    var numberOfFlag: Int = 4
    var noneCasesPosition = [(i: Int,j: Int)].init()
    var colors = ColorSetForOneGame(openColor: .white, emptyColor: .white, strokeColor: .black, textColor: .black)
    
    var isTimerAllowed: Bool = true
    var totalTime: CGFloat = 60
    
    var option1: Bool = false // faire disparaitre les cases
    var option1Time: CGFloat
    
    var option2: Bool = false // les points d'interrogations
    var option2Frequency: CGFloat
    
    var option3: Bool = false // les cases à ne pas toucher
    var option3Frequency: CGFloat
    var option3Time: CGFloat
    
    var areNumbersShowed: Bool = true
    
    
    
    func describeThisGame() {
        print("Type de partie: \(gameType)")
        print("Présence du timer: \(isTimerAllowed)")
        print("Option 1: \(option1)")
        print("Option 2: \(option1)")
        print("Option 3: \(option1)")
        print("Affichage des indications: \(areNumbersShowed)")
    }
    
    
    // No need to init, since all value have defaut values.
    // But i put some of them here
    // Especially, we must instantiate the color without the init function.
    
    
    init(gameTypeWithNoneCases gameType: GameType,n: Int,m: Int,z: Int,numberOfFlag:Int, isTimerAllowed:Bool, totalTime: CGFloat, option1: Bool, option2: Bool, option1Time: CGFloat, option2Frequency: CGFloat, option3:Bool, option3Frequency: CGFloat, option3Time: CGFloat, noneCases: [(i: Int,j: Int)], areNumbersShowed: Bool )
    {
        self.gameType = gameType
        self.n = n
        self.m = m
        self.z = z
        self.totalTime = totalTime
        self.option1 = option1
        self.option2 = option2
        self.option1Time = option1Time
        self.option2Frequency = option2Frequency
        self.noneCasesPosition = noneCases
        self.areNumbersShowed = areNumbersShowed
        self.option3 = option3
        self.option3Time = option3Time
        self.option3Frequency = option3Frequency
        self.numberOfFlag = numberOfFlag
        self.isTimerAllowed = isTimerAllowed
    }
    
    convenience init() {
        self.init(gameTypeWithNoneCases: .square, n: 10, m: 8, z: 10, numberOfFlag: 12, isTimerAllowed: true , totalTime: 90, option1: false, option2: false , option1Time: 0, option2Frequency: 0, option3: false , option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
    }
    
    convenience init(gameTypeWithNoOptionsWithoutNoneCases gameType: GameType,n: Int,m: Int,z: Int, totalTime: CGFloat) {
        self.init(gameTypeWithNoneCases: gameType, n: n, m: m, z: z, numberOfFlag: z+2, isTimerAllowed: true , totalTime: totalTime, option1: false, option2: false , option1Time: 0, option2Frequency: 0, option3: false , option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
    }
    
    convenience init(gameTypeWithOption1WithoutNoneCases gameType: GameType,n: Int,m: Int,z: Int, totalTime: CGFloat, option1Time: CGFloat) {
        self.init(gameTypeWithNoneCases: gameType, n: n, m: m, z: z, numberOfFlag: z+2,isTimerAllowed: true , totalTime: totalTime, option1: true, option2: false, option1Time: option1Time, option2Frequency: 0, option3: false , option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
    }
    
    convenience init(gameTypeWithOption2WithoutNoneCases gameType: GameType,n: Int,m: Int,z: Int, totalTime: CGFloat, option2Frequency: CGFloat) {
        self.init(gameTypeWithNoneCases: gameType, n: n, m: m, z: z, numberOfFlag: z+2,isTimerAllowed: true , totalTime: totalTime, option1: false, option2: true, option1Time: 0, option2Frequency: option2Frequency, option3: false , option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
    }
    
    convenience init(gameTypeWithOption3WithoutNoneCases gameType: GameType,n: Int,m: Int,z: Int, totalTime: CGFloat, option3Time: CGFloat, option3Frequency: CGFloat) {
        self.init(gameTypeWithNoneCases: gameType, n: n, m: m, z: z, numberOfFlag: z,isTimerAllowed: true , totalTime: totalTime, option1: false, option2: false, option1Time: 0, option2Frequency: 0.0, option3: true , option3Frequency: option3Frequency, option3Time: option3Time, noneCases: [], areNumbersShowed: true)
    }
    
    convenience init(squareHeart12x13GameTime totalTime: CGFloat, z: Int) {
        self.init(gameTypeWithNoneCases: .square, n: 12, m: 13, z: z,numberOfFlag: z, isTimerAllowed: true, totalTime: totalTime, option1: false, option2: false, option1Time: 0, option2Frequency: 0,option3: false , option3Frequency: 0, option3Time: 0, noneCases: [(i: 11, j: 0), (i: 11, j: 1), (i: 11, j: 2), (i: 11, j: 3), (i: 11, j: 4), (i: 11, j: 5), (i: 11, j: 7), (i: 11, j: 8), (i: 11, j: 9), (i: 11, j: 10), (i: 11, j: 11), (i: 11, j: 12), (i: 10, j: 0), (i: 10, j: 1), (i: 10, j: 2), (i: 10, j: 3), (i: 10, j: 4), (i: 10, j: 8), (i: 10, j: 9), (i: 10, j: 10), (i: 10, j: 11), (i: 10, j: 12), (i: 9, j: 0), (i: 9, j: 1), (i: 9, j: 2), (i: 9, j: 3), (i: 9, j: 9), (i: 9, j: 10), (i: 9, j: 11), (i: 9, j: 12), (i: 8, j: 0), (i: 8, j: 1), (i: 8, j: 2), (i: 8, j: 11), (i: 8, j: 12), (i: 7, j: 0), (i: 7, j: 1), (i: 7, j: 11), (i: 7, j: 12), (i: 6, j: 0), (i: 6, j: 12), (i: 1, j: 0), (i: 1, j: 6), (i: 1, j: 12), (i: 0, j: 0), (i: 0, j: 1), (i: 0, j: 5), (i: 0, j: 6), (i: 0, j: 7), (i: 0, j: 11), (i: 0, j: 12)], areNumbersShowed: true)
    }
    
    convenience init(squareYingYang15x15GameTime totalTime: CGFloat, z: Int) {
        self.init(gameTypeWithNoneCases: .square, n: 15, m: 15, z: z, numberOfFlag: z,isTimerAllowed: true , totalTime: totalTime, option1: false, option2: false, option1Time: 0, option2Frequency: 0,option3: false , option3Frequency: 0, option3Time: 0, noneCases: [(i: 14, j: 0), (i: 14, j: 1), (i: 14, j: 2), (i: 14, j: 3), (i: 14, j: 4), (i: 14, j: 10), (i: 14, j: 11), (i: 14, j: 12), (i: 14, j: 13), (i: 14, j: 14), (i: 13, j: 0), (i: 13, j: 1), (i: 13, j: 2), (i: 13, j: 6), (i: 13, j: 7), (i: 13, j: 8), (i: 13, j: 9), (i: 13, j: 12), (i: 13, j: 13), (i: 13, j: 14), (i: 12, j: 0), (i: 12, j: 1), (i: 12, j: 4), (i: 12, j: 5), (i: 12, j: 6), (i: 12, j: 7), (i: 12, j: 8), (i: 12, j: 9), (i: 12, j: 10), (i: 12, j: 13), (i: 12, j: 14), (i: 11, j: 0), (i: 11, j: 3), (i: 11, j: 4), (i: 11, j: 5), (i: 11, j: 6), (i: 11, j: 9), (i: 11, j: 10), (i: 11, j: 11), (i: 11, j: 14), (i: 10, j: 0), (i: 10, j: 3), (i: 10, j: 4), (i: 10, j: 5), (i: 10, j: 6), (i: 10, j: 9), (i: 10, j: 10), (i: 10, j: 11), (i: 10, j: 12), (i: 10, j: 14), (i: 9, j: 3), (i: 9, j: 4), (i: 9, j: 5), (i: 9, j: 6), (i: 9, j: 7), (i: 9, j: 8), (i: 9, j: 9), (i: 9, j: 10), (i: 9, j: 11), (i: 9, j: 12), (i: 9, j: 13), (i: 8, j: 4), (i: 8, j: 5), (i: 8, j: 6), (i: 8, j: 7), (i: 8, j: 8), (i: 8, j: 9), (i: 8, j: 10), (i: 8, j: 11), (i: 8, j: 12), (i: 8, j: 13), (i: 7, j: 8), (i: 7, j: 9), (i: 7, j: 10), (i: 7, j: 11), (i: 7, j: 12), (i: 7, j: 13), (i: 6, j: 9), (i: 6, j: 10), (i: 6, j: 11), (i: 6, j: 12), (i: 6, j: 13), (i: 5, j: 10), (i: 5, j: 11), (i: 5, j: 12), (i: 5, j: 13), (i: 4, j: 0), (i: 4, j: 6), (i: 4, j: 7), (i: 4, j: 12), (i: 4, j: 14), (i: 3, j: 0), (i: 3, j: 6), (i: 3, j: 7), (i: 3, j: 12), (i: 3, j: 14), (i: 2, j: 0), (i: 2, j: 1), (i: 2, j: 13), (i: 2, j: 14), (i: 1, j: 0), (i: 1, j: 1), (i: 1, j: 2), (i: 1, j: 12), (i: 1, j: 13), (i: 1, j: 14), (i: 0, j: 0), (i: 0, j: 1), (i: 0, j: 2), (i: 0, j: 3), (i: 0, j: 4), (i: 0, j: 10), (i: 0, j: 11), (i: 0, j: 12), (i: 0, j: 13), (i: 0, j: 14)], areNumbersShowed: true)
    }
    
    convenience init(hexagonalPyramid7x7GameTime totalTime: CGFloat, z: Int) {
        self.init(gameTypeWithNoneCases: .hexagonal, n: 7, m: 7, z: z, numberOfFlag: z,isTimerAllowed: true , totalTime: totalTime, option1: false, option2: false, option1Time: 0, option2Frequency: 0,option3: false , option3Frequency: 0, option3Time: 0, noneCases: [(i: 4, j: 0), (i: 4, j: 6), (i: 3, j: 0), (i: 3, j: 5), (i: 2, j: 0), (i: 2, j: 1), (i: 2, j: 5), (i: 2, j: 6), (i: 1, j: 0), (i: 1, j: 1), (i: 1, j: 4), (i: 1, j: 5), (i: 0, j: 0), (i: 0, j: 1), (i: 0, j: 2), (i: 0, j: 4), (i: 0, j: 5), (i: 0, j: 6)], areNumbersShowed: true)
    }
    
    convenience init(triangularButterfly4x7GameTime totalTime: CGFloat, z: Int) {
        self.init(gameTypeWithNoneCases: .triangular, n: 4, m: 7, z: z, numberOfFlag: z,isTimerAllowed: true , totalTime: totalTime, option1: false, option2: false, option1Time: 0, option2Frequency: 0,option3: false , option3Frequency: 0, option3Time: 0, noneCases: [(i: 3, j: 2), (i: 3, j: 3), (i: 3, j: 4), (i: 2, j: 3), (i: 1, j: 3), (i: 0, j: 2), (i: 0, j: 3), (i: 0, j: 4)], areNumbersShowed: true)
    }
    
}
