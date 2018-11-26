//
//  SquareViewOfGame.swift
//  Demineur
//
//  Created by Arthur BRICQ on 25/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit


class SquareViewOfGame: ViewOfGame {
    
    override func instantiateCases() {
        var positionnerPoint: CGPoint = CGPoint.zero // iterator point
        let a = self.frame.width/CGFloat(game!.m)
        let caseSize = CGSize(width: a, height: a)
        for i in 0..<game!.n {
            for j in 0..<game!.m {
                // Create a new square case 
            }
        }
    }
    
    override func ouvertureRecursive(line i: Int, column j: Int) {
        let minI = 0
        let minJ = 0
        let maxI = gameState.count-1
        let maxJ = gameState[0].count-1
        var hasToContinue: Bool = false
        var hasToOpen: Bool = false
        
        if isCaseBlocked(i: i, j: j) { return }
        
        // followings condition are true if we should open the case
        let cond1_1 = (i >= minI && i <= maxI) ; let cond1_2 = (j >= minJ && j <= maxJ);
        let cond1 = cond1_1 && cond1_2
        if !cond1 { return } else {
            let cond2 = !isTheCaseOpen(i: i, j: j)
            let cond3 = !isTheCaseMarked(i: i, j: j)
            let cond4 = !isCaseNone(i: i, j: j)
            hasToOpen = cond1 && cond2 && cond3 && cond4
            
            // followings condition are true if we should not continue the recursion
            hasToContinue = gameState[i][j] == 0
        }
    
        if hasToOpen {
            returnACaseAt(i: i, j: j)
        } else {
            return
        }
        
        if hasToContinue {
            ouvertureRecursive(line: i+1, column: j+1)
            ouvertureRecursive(line: i+1, column: j)
            ouvertureRecursive(line: i+1, column: j-1)
            ouvertureRecursive(line: i, column: j-1)
            ouvertureRecursive(line: i-1, column: j-1)
            ouvertureRecursive(line: i-1, column: j)
            ouvertureRecursive(line: i-1, column: j+1)
            ouvertureRecursive(line: i, column: j+1)
        } else {
            return
        }
        
    }
    
}
