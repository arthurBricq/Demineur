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
    case empty
    case open
    case marked
    case none
    case blocked
}


class Section {
    var n: Int = 8
    var m: Int = 8
    var gameType = GameType.square
    
    var game1: OneGame?
    var game2: OneGame?
    var game3: OneGame?
    var game4: OneGame?
    var game5: OneGame?
    
    init(n: Int, m: Int, gameType: GameType, game1: OneGame, game2: OneGame, game3: OneGame, game4: OneGame, game5: OneGame) {
        self.n = n
        self.m = m
        self.gameType = gameType
        self.game1 = game1
        self.game2 = game2
        self.game3 = game3
        self.game4 = game4
        self.game5 = game5
    }
    
    convenience init(simpleSquareGameWith dimensions: (n: Int,m: Int) ) {
        
        let firstGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 1, numberOfFlag: 4, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: true, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let secondGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 2, numberOfFlag: 4, isTimerAllowed: true, totalTime: 60, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: false)
        let thirdGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 3, numberOfFlag: 8, isTimerAllowed: true, totalTime: 60, option1: true, option2: false, option1Time: 10, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fourthGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 5, numberOfFlag: 14, isTimerAllowed: true, totalTime: 90, option1: false, option2: true, option1Time: 0, option2Frequency: 0.2, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fifthGame = OneGame(gameTypeWithNoneCases: .square, n: dimensions.n, m: dimensions.m, z: 5, numberOfFlag: 10, isTimerAllowed: true, totalTime: 60, option1: false, option2: true, option1Time: 0, option2Frequency: 0.1, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: false)
        
        self.init(n: dimensions.n, m: dimensions.m, gameType: .square, game1: firstGame, game2: secondGame, game3: thirdGame, game4: fourthGame, game5: fifthGame)
    }
    
    convenience init(simpleHexGameWith dimensions: (n: Int,m: Int) ) {
        
        let firstGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 3, numberOfFlag: 4, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: true, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let secondGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 4, numberOfFlag: 4, isTimerAllowed: true, totalTime: 60, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let thirdGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 6, numberOfFlag: 8, isTimerAllowed: true, totalTime: 60, option1: true, option2: false, option1Time: 6, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fourthGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 10, numberOfFlag: 14, isTimerAllowed: true, totalTime: 90, option1: false, option2: true, option1Time: 0, option2Frequency: 0.2, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fifthGame = OneGame(gameTypeWithNoneCases: .hexagonal, n: dimensions.n, m: dimensions.m, z: 10, numberOfFlag: 10, isTimerAllowed: true, totalTime: 60, option1: false, option2: true, option1Time: 0, option2Frequency: 0.3, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: false)
        
        self.init(n: dimensions.n, m: dimensions.m, gameType: .hexagonal, game1: firstGame, game2: secondGame, game3: thirdGame, game4: fourthGame, game5: fifthGame)
    }
    
    convenience init(simpleTriangularGameWith dimensions: (n: Int, m: Int)) {
        
        if (dimensions.n%2 != 0) || (dimensions.m%2 != 1) { fatalError("n doit être pair et m impair pour une partie triangulaire") }
        
        let firstGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 3, numberOfFlag: 4, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: true, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let secondGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 4, numberOfFlag: 4, isTimerAllowed: true, totalTime: 60, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let thirdGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 6, numberOfFlag: 8, isTimerAllowed: true, totalTime: 60, option1: true, option2: false, option1Time: 6, option2Frequency: 0, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fourthGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 10, numberOfFlag: 14, isTimerAllowed: true, totalTime: 90, option1: false, option2: true, option1Time: 0, option2Frequency: 0.2, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: true)
        let fifthGame = OneGame(gameTypeWithNoneCases: .triangular, n: dimensions.n, m: dimensions.m, z: 10, numberOfFlag: 10, isTimerAllowed: true, totalTime: 60, option1: false, option2: true, option1Time: 0, option2Frequency: 0.3, option3: false, option3Frequency: 0.5, option3Time: 2, noneCases: [], areNumbersShowed: false)
        
        self.init(n: dimensions.n, m: dimensions.m, gameType: .triangular, game1: firstGame, game2: secondGame, game3: thirdGame, game4: fourthGame, game5: fifthGame)
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


class IsTheGameStarted {
    var value: Bool = false
    
    var delegate: variableCanCallGameVC?
    
    init(value: Bool) {
        self.value = value
        self.delegate = nil
    }
}

var isTheGameStarted = IsTheGameStarted(value: false)


// ***** PROTOCOLS ***** //
protocol ButtonCanCallSuperView {
    func buttonHaveBeenTapped(i: Int, j: Int, marking: Bool)
}
protocol GameViewCanCallVC {
    func gameOver(win: Bool)
    func updateFlagsDisplay(numberOfFlags: Int)
}
protocol CountingTimerProtocol {
    func timerFires(id: String)
}
protocol LimitedTimerProtocol {
    func timeLimitReached(id: String)
}
protocol variableCanCallGameVC {
    func createTheGame(withFirstTouched: (x: Int, y: Int))
}


let k: CGFloat = 0.86603 // variable such that w = k*h.
let maximumDifficulty: Int = 5 // Indice de la difficulté la plus élevée.





//// BONUS

struct BonusDescription {
    let name: String
    var niveau: Int = 0 // il faut faire +1
    let descriptions: [String]
    let prixAchat: Int
    let prixAmelioration: [Int]
}

var allBonus: [BonusDescription] = [
    
    BonusDescription(name: "Temps", niveau: 0, descriptions: ["Récupérez 15 secondes", "Récupérez 30 secondes", "Récupérez 45 secondes", "Récupérez 1 minute"], prixAchat: 750, prixAmelioration: [8000, 16000, 30000, 40000] ),

    BonusDescription(name: "Drapeau", niveau: 0, descriptions: ["Gagnez un drapeau.", "Gagnez 2 drapeaux", "Gagnez 3 drapeaux"], prixAchat: 1000, prixAmelioration: [10000,20000] ),
    
    BonusDescription(name: "Bombe", niveau: 0, descriptions: ["Trouver une bombe avec une chance de 50%.","Trouver une bombe !","Trouver 2 bombes avec une chance de 50%"], prixAchat: 1000, prixAmelioration: [10000,20000] ),
    
    BonusDescription(name: "Vie", niveau: 0, descriptions: ["Obtenez une seconde chance", "Vous surviverez à deux bombes", "Trois échecs ne vous abatteront pas !"], prixAchat: 2500, prixAmelioration: [20000, 50000] ),
    
    BonusDescription(name: "Verification", niveau: 0 , descriptions: ["Vérifiez certains de vos drapeaux","Vérifiez tous les drapeaux"], prixAchat: 2000, prixAmelioration: [20000, 50000] )
    
]









