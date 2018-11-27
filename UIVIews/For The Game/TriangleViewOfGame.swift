//
//  TriangleViewOfGame.swift
//  Demineur
//
//  Created by Arthur BRICQ on 26/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit


class TriangleViewOfGame: ViewOfGame {
    override func instantiateCases() {
        // Les dimensions de la vue doivent être les bonnes, grâce à la fonction de dimensionnement.
        var a: CGFloat = 0
        // Trouver la constante a = a(m,n) et la hauteur
        if game!.m%2 == 0 { a = frame.width*2/CGFloat(game!.m)
        } else { a = frame.width*2/CGFloat(game!.m+1) }
        let h = frame.height / CGFloat(game!.n)
        // Positionner toutes les cases
        var iteratorPoint = CGPoint(x: 0.0, y: 0.0)
        let size = CGSize(width: a, height: h)
        for i in 0..<game!.n {
            var line: [Case] = []
            for j in 0..<game!.m {
                iteratorPoint.x = CGFloat(j) * a/2
                iteratorPoint.y = CGFloat(i) * h
                let newCase = TriangularCase(frame: CGRect(origin: iteratorPoint, size: size), game: game!, i: i, j: j, viewOfGame: self)
                newCase.caseState = gameState[i][j] == -2 ? .none : .empty
                line.append(newCase)
                self.addSubview(newCase)
            }
            cases.append(line)
        }
    }
    
    override func ouvertureRecursive(line i: Int, column j: Int) {
        // **** to use **** //
        let minI = 0
        let minJ = 0
        let maxI = gameState.count-1
        let maxJ = gameState[0].count-1
        var hasToContinue: Bool = false
        var hasToOpen: Bool = false
        
        // followings condition are true if we should open the case
        let cond1_1 = (i >= minI && i <= maxI) ; let cond1_2 = (j >= minJ && j <= maxJ);
        let cond1 = cond1_1 && cond1_2
        if !cond1 { return } else
        {
            let cond2 = !isTheCaseOpen(i: i, j: j)
            let cond3 = !isTheCaseMarked(i: i, j: j)
            let cond4 = !isCaseNone(i: i, j: j)
            let cond5 = (gameState[i][j] != -1)
            hasToOpen = cond1 && cond2 && cond3 && cond4 && cond5
            // followings condition are true if we should not continue the recursion
            hasToContinue = (gameState[i][j] == 0)
        }
        
        if isCaseBlocked(i: i, j: j) { return }
        
        // Implementation starts here
        if hasToOpen {
            returnACaseAt(i: i, j: j)
        } else {
            return
        }
        
        if hasToContinue {
            ouvertureRecursive(line: i+1, column: j+1)
            ouvertureRecursive(line: i+1, column: j)
            ouvertureRecursive(line: i+1, column: j-1)
            ouvertureRecursive(line: i+1, column: j-2)
            ouvertureRecursive(line: i+1, column: j+2)
            ouvertureRecursive(line: i, column: j-1)
            ouvertureRecursive(line: i-1, column: j-1)
            ouvertureRecursive(line: i-1, column: j)
            ouvertureRecursive(line: i-1, column: j+1)
            ouvertureRecursive(line: i-1, column: j-2)
            ouvertureRecursive(line: i-1, column: j+2)
            ouvertureRecursive(line: i, column: j+1)
        } else {
            return
        }
        
    }
}
