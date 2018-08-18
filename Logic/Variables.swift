//
//  Variables.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 03/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit

enum GameType {
    case square
    case hexagonal
    case triangular
}

enum CaseState {
    case empty // quand il ne s'est rien passé
    case open // quand le joueur a ouvert la case
    case marked // quand le joueur a pose un drapeau
    case markedByComputer // quand l'ordinateur a pose un drapeau
    case none // quand il n'y a pas de cases
    case blocked // quand la case est temporairemetn bloque
}

class Section {
    var n: Int = 8
    var m: Int = 8
    var gameType = GameType.square
    var z0: Int = 10
    var incrementBomb: Int = 1
    var additionalsFlags: [Int] = [2,2,2,2,2]
    
    var game1: OneGame?
    var game2: OneGame?
    var game3: OneGame?
    var game4: OneGame?
    var game5: OneGame?
    
    /// Cette fonction doit-être appelée après que toutes les propriétés principales d'une section ont été mise à jour afin de modifier les jeux créer par les fonctions init.
    /// Pas de input
    func updateGamesOfThisSection() {
        
        
        
        game1!.n = n
        game1!.m = m
        game1!.z = z0 + Int((1-1)*floor(Double(incrementBomb)))
        game1!.gameType = gameType
        game1!.numberOfFlag = game1!.z+additionalsFlags[0]
        
        game2!.n = n
        game2!.m = m
        game2!.z = z0 + Int((2-1)*floor(Double(incrementBomb)))
        game2!.gameType = gameType
        game2!.numberOfFlag = game2!.z+additionalsFlags[1]
        
        game3!.n = n
        game3!.m = m
        game3!.z = z0 + Int((3-1)*floor(Double(incrementBomb)))
        game3!.gameType = gameType
        game3!.numberOfFlag = game3!.z+additionalsFlags[2]

        game4!.n = n
        game4!.m = m
        game4!.z = z0 + Int((4-1)*floor(Double(incrementBomb)))
        game4!.gameType = gameType
        game4!.numberOfFlag = game4!.z+additionalsFlags[3]
        
        game5!.n = n
        game5!.m = m
        game5!.z = z0 + Int((5-1)*floor(Double(incrementBomb)))
        game5!.gameType = gameType
        game5!.numberOfFlag = game5!.z+additionalsFlags[4]
        
    }
    
    
    
    
    init(n: Int, m: Int, z0: Int, gameType: GameType, game1: OneGame, game2: OneGame, game3: OneGame, game4: OneGame, game5: OneGame) {
        self.n = n
        self.m = m
        self.z0 = z0
        self.gameType = gameType
        self.game1 = game1
        self.game2 = game2
        self.game3 = game3
        self.game4 = game4
        self.game5 = game5
    }
    
    convenience init() {
        self.init(simpleSquareGameWith: (10,10))
    }
    
    convenience init(simpleSquareGameWith dimensions: (n: Int,m: Int) ) {
        
        let firstGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 1, numberOfFlag: 4, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: true, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let secondGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 2, numberOfFlag: 4, isTimerAllowed: true, totalTime: 60, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: false)
        let thirdGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 3, numberOfFlag: 8, isTimerAllowed: true, totalTime: 60, option1: true, option2: false, option1Time: 10, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fourthGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 5, numberOfFlag: 14, isTimerAllowed: true, totalTime: 90, option1: false, option2: true, option1Time: 0, option2Frequency: 0.2, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fifthGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 5, numberOfFlag: 10, isTimerAllowed: true, totalTime: 60, option1: false, option2: true, option1Time: 0, option2Frequency: 0.1, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: false)
        
        self.init(n: dimensions.n, m: dimensions.m, z0: 1,  gameType: .square, game1: firstGame, game2: secondGame, game3: thirdGame, game4: fourthGame, game5: fifthGame)
    }
    
    convenience init(simpleHexGameWith dimensions: (n: Int,m: Int) ) {
        
        let firstGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 3, numberOfFlag: 4, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: true, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let secondGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 4, numberOfFlag: 4, isTimerAllowed: true, totalTime: 60, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let thirdGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 6, numberOfFlag: 8, isTimerAllowed: true, totalTime: 60, option1: true, option2: false, option1Time: 6, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fourthGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 10, numberOfFlag: 14, isTimerAllowed: true, totalTime: 90, option1: false, option2: true, option1Time: 0, option2Frequency: 0.2, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fifthGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 10, numberOfFlag: 10, isTimerAllowed: true, totalTime: 60, option1: false, option2: true, option1Time: 0, option2Frequency: 0.3, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: false)
        
        self.init(n: dimensions.n, m: dimensions.m, z0: 3, gameType: .hexagonal, game1: firstGame, game2: secondGame, game3: thirdGame, game4: fourthGame, game5: fifthGame)
    }
    
    convenience init(simpleTriangularGameWith dimensions: (n: Int, m: Int)) {
        
        if (dimensions.n%2 != 0) || (dimensions.m%2 != 1) { fatalError("n doit être pair et m impair pour une partie triangulaire") }
        
        let firstGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 3, numberOfFlag: 4, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: true, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let secondGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 4, numberOfFlag: 4, isTimerAllowed: true, totalTime: 60, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let thirdGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 6, numberOfFlag: 8, isTimerAllowed: true, totalTime: 60, option1: true, option2: false, option1Time: 6, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fourthGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 10, numberOfFlag: 14, isTimerAllowed: true, totalTime: 90, option1: false, option2: true, option1Time: 0, option2Frequency: 0.2, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fifthGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 10, numberOfFlag: 10, isTimerAllowed: true, totalTime: 60, option1: false, option2: true, option1Time: 0, option2Frequency: 0.3, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: false)
        
        self.init(n: dimensions.n, m: dimensions.m, z0: 3, gameType: .triangular, game1: firstGame, game2: secondGame, game3: thirdGame, game4: fourthGame, game5: fifthGame)
    }
    
}

struct ColorSetForOneGame {
    var openColor = UIColor.white // color for open-case's background
    var emptyColor = UIColor.white // color for empty-case's background
    var strokeColor = UIColor.white
    var textColor = UIColor.black
}


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

let historyLevels: [OneGame] = [OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 10, m: 7, z: 10, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 12, m: 9, z: 15, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 14, m: 10, z: 10, totalTime: 60),
                                
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 8, m: 11, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 10, m: 11, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 10, m: 13, z: 4, totalTime: 60),
                                
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 10, m: 13, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 10, m: 15, z: 4, totalTime: 60),
                                OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 10, m: 17, z: 4, totalTime: 60),
                                
                                
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





class IsTheGameStarted {
    var value: Bool = false
    
    var delegate: variableCanCallGameVC?
    
    init(value: Bool) {
        self.value = value
        self.delegate = nil
    }
}

var isTheGameStarted = IsTheGameStarted(value: false)

let k: CGFloat = 0.86603 // variable such that w = k*h.
let maximumDifficulty: Int = 5 // Indice de la difficulté la plus élevée.



// MARK: - Modèle de données pour les tablesView de la boutique


/// ORDRE DES BONUS :
// Temps
// Drapeau
// Bombe
// Verification
// Vie
/// VARIABLE DE SAUVEGARDE : 'bonus'
struct BonusDescription {
    let name: String
    var niveau: Int = 0 // il faut faire +1 // INUTILE POUR LA LOGIQUE
    let descriptions: [String]
    let descriptionsAmeliorations: [String]
    let prixAchat: Int
    let prixAmelioration: [Int]
}
let allBonus: [BonusDescription] = [
    
    BonusDescription(name: "Temps", niveau: 0, descriptions: ["Récupérez 15 secondes", "Récupérez 30 secondes", "Récupérez 45 secondes", "Récupérez 1 minute"],descriptionsAmeliorations: ["+ 15 secondes", "+ 15 secondes", "+ 15 secondees"], prixAchat: 750, prixAmelioration: [8000, 16000, 30000, 40000] ),

    BonusDescription(name: "Drapeau", niveau: 0, descriptions: ["Gagnez un drapeau durant une partie", "Gagnez 2 drapeaux durant une partie", "Gagnez 3 drapeaux durant une partie"],descriptionsAmeliorations: ["+ 1 drapeau", "+ 1 drapeau"], prixAchat: 1000, prixAmelioration: [10000,20000] ),
    
    BonusDescription(name: "Bombe", niveau: 0, descriptions: ["Trouver une bombe avec une chance de 50%.","Trouver une bombe !","Trouver 2 bombes avec une chance de 50%"],descriptionsAmeliorations: ["Trouvez-là avec 100% de chance !", "+ 1 bombe à 50% de chances"], prixAchat: 1000, prixAmelioration: [10000,20000] ),
    
    BonusDescription(name: "Verification", niveau: 0 , descriptions: ["Vérifiez certains de vos drapeaux","Vérifiez tous les drapeaux"],descriptionsAmeliorations: ["Vérifiez tous les drapeaux"], prixAchat: 2000, prixAmelioration: [20000, 50000] ),
    
    BonusDescription(name: "Vie", niveau: 0, descriptions: ["Obtenez une seconde chance", "Vous surviverez à 2 bombes", "3 échecs ne vous abatteront pas !"],descriptionsAmeliorations: ["Survivez à 2 bombes !", "Survivez à 3 bombes"], prixAchat: 2500, prixAmelioration: [20000, 50000] )
    
]


// Packs de pièces a achetés
struct PackagesDescription {
    let size: MoneyPackage.PackageSize
    let description: String
    let prix: Double
    let amountOfCoins: Int
}
let allPacks: [PackagesDescription] = [
    PackagesDescription(size: .small, description: "Achetez X pièces", prix: 0.99, amountOfCoins: 1),
    PackagesDescription(size: .medium, description: "Achetez une bourse de X pièces", prix: 2.99, amountOfCoins: 10),
    PackagesDescription(size: .large, description: "Achetez un grand coffre de X pièces", prix: 4.99, amountOfCoins: 100)
]


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
    var isUnlocked: Bool
}
var allThemes: [ColorTheme] = [
    ColorTheme(name: "Classic", price: 0, colors: [colorForRGB(r: 255, g: 255, b: 255), colorForRGB(r: 184, g: 120, b: 0), colorForRGB(r: 66, g: 66, b: 66)], isUnlocked: true),
    ColorTheme(name: "Cartoon", price: 2500, colors: [colorForRGB(r: 204, g: 255, b: 153), colorForRGB(r: 0, g: 102, b: 255), colorForRGB(r: 204, g: 51, b: 153)], isUnlocked: false),
    ColorTheme(name: "Dark", price: 3000, colors: [colorForRGB(r: 55, g: 22, b: 55), colorForRGB(r: 153, g: 102, b: 0), colorForRGB(r: 179, g: 179, b: 179)], isUnlocked: false)
]
var selectedTheme: Int = 0
