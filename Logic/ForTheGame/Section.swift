//
//  Section.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit


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
