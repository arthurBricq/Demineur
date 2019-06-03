//
//  HexCase.swift
//  HexagoneViewMineIt
//
//  Created by Arthur BRICQ on 30/03/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class HexCase: Case {
    
    // MARK: - VARIABLES
    let lineWidth: CGFloat = 1.0 // Pour l'épaisseur des lignes.
    
    // MARK: - FUNCTIONS
    override func draw(_ rect: CGRect)
    {
        // contrainte : w = 0.87*h
        // h = a*2
        // w = 0.87*2*a <=> a = w/2.61
        
        // ***** DESSIN DES CASES HEXAGONALES ******* //
        let a = rect.height/2
        let x0 = rect.width/2
        let teta = CGFloat.pi / 3
        
        let p1 = CGPoint(x: x0, y: 0)
        let p2 = CGPoint(x: p1.x + a*sin(teta), y:p1.y + a*cos(teta))
        let p3 = CGPoint(x: p2.x, y:p2.y + a)
        let p4 = CGPoint(x: p1.x, y: p1.y + 2*a)
        let p5 = CGPoint(x: p4.x - a*sin(teta), y: p3.y)
        let p6 = CGPoint(x: p5.x, y: p2.y)
        
        let contourPath = UIBezierPath()
        contourPath.move(to: p1)
        contourPath.addLine(to: p2)
        contourPath.addLine(to: p3)
        contourPath.addLine(to: p4)
        contourPath.addLine(to: p5)
        contourPath.addLine(to: p6)
        contourPath.addLine(to: p1)
        game!.colors.strokeColor.setStroke()
        contourPath.lineWidth = lineWidth
        
        //// 2.
        // ******* Personnalisation des cases en fonction de leur état ******* //
        game!.colors.strokeColor.setStroke()
        switch caseState {
            
        case .empty, .marked, .markedByComputer:
            game!.colors.emptyColor.setFill()
            contourPath.fill()
            contourPath.stroke()
            
        case .blocked:
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            contourPath.addClip()
            Rayure.drawRayure(frame: rect, resizing: .aspectFill, color: game!.colors.emptyColor, color2: game!.colors.openColor)
            context?.restoreGState()
            
        case .open:
            // background color
            game!.colors.openColor.setFill()
            contourPath.fill()
            contourPath.stroke()
            
            // boite de texte avec le numero
            let myLabel = UILabel()
            let cx = rect.width/2
            let cy = rect.height/2
            let sizeOfLabel = CGSize(width: rect.width, height: rect.width)
            let origin = CGPoint(x: cx - rect.width/2, y: cy - rect.width/2)
            myLabel.frame = CGRect(origin: origin, size: sizeOfLabel)
            myLabel.textAlignment = .center
            myLabel.textColor = game!.colors.textColor
            
            var stringToDisplay: String = ""
            if gameState[i][j] == 0 { stringToDisplay = " " }
            else if gameState[i][j] == -1 { myLabel.textColor = .red ;  stringToDisplay = "\(gameState[i][j])"  }
            else {
                if game!.option2 {
                    if random(Int((1/game!.option2Frequency))) == 0 {
                        stringToDisplay = "?"
                    } else {
                        stringToDisplay = "\(gameState[i][j])"
                    }
                } else {
                    stringToDisplay = "\(gameState[i][j])"
                }
            }
            myLabel.text = stringToDisplay
            self.addSubview(myLabel)
            
        case .none:
            break
        }
        
        ////3.
        //*********** renforcer les lignes des côtées *************** //
        // à gauche
        if (j == 0 && gameState[i][j] != -2) || (j > 0 &&  gameState[i][j-1] == -2 && gameState[i][j] != -2 ) {
            let newPath = UIBezierPath()
            newPath.lineWidth = 2*lineWidth
            newPath.move(to: p5)
            newPath.addLine(to: p6)
            newPath.stroke()
        }
        // à droite
        // Assuming that numberOfColumns = gameState[i].count
        if shouldThisLineContainsAllButtons(atLine: i) {
            if (j == gameState[i].count-1 && gameState[i][j] != -2) || (j < gameState[i].count-1 &&  gameState[i][j+1] == -2 && gameState[i][j] != -2 ) {
                let newPath = UIBezierPath()
                newPath.lineWidth = 2*lineWidth
                newPath.move(to: p2)
                newPath.addLine(to: p3)
                newPath.stroke()
            }
        } else {
            if (j == gameState[i].count-2 && gameState[i][j] != -2 ) || (j < gameState[i].count-2 &&  gameState[i][j+1] == -2 && gameState[i][j] != -2 )  {
                let newPath = UIBezierPath()
                newPath.lineWidth = 2*lineWidth
                newPath.move(to: p2)
                newPath.addLine(to: p3)
                newPath.stroke()
            }
        }
    
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool { // this function specify the region of the button where we want the hitbox
        
        var toReturn: Bool = false
        
        let x = point.x
        let y = point.y
        
        let h = self.bounds.height
        let w = self.bounds.width
        let a = h/2
        
        // contrainte : w = 0.87h
        switch y
        {
        case 0..<(a/2):
            // première partie en haut de l'hexagone
            if x > 0 && x < w/2 { // à gauche du triangle
                let B = a/2
                let A = -(a/2)/(w/2)
                let fineY = linearFunction(a: A, b: B, x: x)
                if y > fineY {
                    toReturn = true
                }
            } else if x > 0 && x >= w/2 && x < w { // à droite du triangle
                let B = -a/2
                let A = +(a/2)/(w/2)
                let fineY = linearFunction(a: A, b: B, x: x)
                if y > fineY {
                    toReturn = true
                }
            }
            
        case (a/2)..<(3*a/2):
            // deuxième partie au milieu
            if x > 0 && x < w { toReturn = true }
            
        case (3*a/2)...h:
            // troisième partie au milieu
            if x > 0 && x < w/2 { // à gauche du triangle
                let B = 3*a/2
                let A = (a/2)/(w/2)
                let fineY = linearFunction(a: A, b: B, x: x)
                if y < fineY {
                    toReturn = true
                }
            } else if x > 0 && x >= w/2 && x < w { // à droite du triangle
                let B = 5*a/2
                let A = -(a/2)/(w/2)
                let fineY = linearFunction(a: A, b: B, x: x)
                if y < fineY {
                    toReturn = true
                }
            }
            
        default:
            return false
        }
        
        return toReturn
    }
    
}
