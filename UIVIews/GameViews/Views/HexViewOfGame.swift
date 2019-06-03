//
//  HexViewOfGame.swift
//  Demineur
//
//  Created by Arthur BRICQ on 25/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class HexViewOfGame: ViewOfGame {
    
    public func getA() -> CGFloat {
        return self.frame.width/(sqrt(3) * CGFloat(game!.m))
    }
    
    override var dimension: CGSize {
        // We must return the dimension taken by game.
        let n = game!.n ; let m = game!.m
        let a = 30.0
        let width = a * sqrt(3) * Double(m)
        let height = 3/2 * a * Double(n) + a/2 
        return CGSize(width: width, height: height)
    }
    
    override func instantiateCases() {
        var iteratorPoint: CGPoint = .zero
        let a = getA()
        let h = 2*a // la hauteur
        let w = k*h // la largeur
        let size = CGSize(width: w, height: h)
        
        for i in 0..<game!.n {
            var line: [Case] = []
            for j in 0..<gameState[i].count {
                if i%2 == 0 {
                    iteratorPoint.x = CGFloat(j) * sqrt(3) * a
                    iteratorPoint.y = CGFloat(i) * (3*a/2)
                } else {
                    iteratorPoint.x = w/2 + CGFloat(j) * sqrt(3) * a
                    iteratorPoint.y = CGFloat(i) * (3*a/2)
                }
                let hexButton = HexCase(frame: CGRect(origin: iteratorPoint, size: size), game: game!, i: i, j: j, viewOfGame: self)
                hexButton.caseState = gameState[i][j] == -2 ? .none : .empty
                self.addSubview(hexButton)
                line.append(hexButton)
            }
            cases.append(line)
        }
        
    }
    
    override func ouvertureRecursive(line i: Int, column j: Int) {
        let minIJ = 0
        let maxI = gameState.count
        let a = getA()
        if i >= minIJ && j >= minIJ && i < maxI {
            // Pas une case en dehors du domaine.
            let maxJ = gameState[i].count ;
            if j < maxJ {
                if isCaseBlocked(i: i, j: j) { return }
                if gameState[i][j] == -2 {
                    return
                } else if !isTheCaseMarked(i: i, j: j) && !isTheCaseOpen(i: i, j: j) { // pas une bombe, pas une none
                    returnACaseAt(i: i, j: j)
                    if gameState[i][j] != 0 { return }
                    for a in (i-1)...(i+1) {
                        for b in (j-1)...(j+1) {
                            // il y a deux cas : ou bien i est paire ou bien i est impaire
                            if i%2 == 0 { // il y m elements dans la ligne.
                                if a != i && b == (j+1) { continue }
                            } else {
                                if b == (j-1) && a != i { continue }
                            }
                            ouvertureRecursive(line: a, column: b)
                        }
                    }
                }
            }
        }
    }
}
