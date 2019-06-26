//
//  EndGameCoinAnimationManager.swift
//  Demineur
//
//  Created by Marin on 26/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

/// This class deals with the animation of the coins at the end of a game
class EndGameCoinAnimationManager: NSObject {
    
    var gameView: ViewOfGame
    
    init(gameViewToAnimate: ViewOfGame) {
        self.gameView = gameViewToAnimate
    }
    
    /// This function will return an array of all the bombs correctly marked in order to animate them
    private func returnAllCorrectlyMarkedBombs() -> [Case] {
        
        var correctlyMarkedBombs: [Case] = []
        
        for lineOfCasesTested in gameView.cases {
            
            for caseTested in lineOfCasesTested {
                
                if (caseTested.caseState == .marked || caseTested.caseState == .markedByComputer) && (gameView.gameState[caseTested.i][caseTested.j] == -1) {
                    correctlyMarkedBombs.append(caseTested)
                }
                
            }
            
        }
        
        return correctlyMarkedBombs
        
    }
    
    public func test() {
        for a in returnAllCorrectlyMarkedBombs() {
            print("i : \(a.i); j : \(a.j)")
        }
    }
    
}
