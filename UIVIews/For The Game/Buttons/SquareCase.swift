//
//  caseButton.swift
//  viewOfMineGame_1
//
//  Created by Arthur BRICQ on 21/03/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
class SquareCase: Case {
    // This button is the one displaying the cases of the game.
    // Those buttons have many different states
    
    // MARK: -  VARIABLES
    @IBInspectable var lineWidth: CGFloat = 1.0
    
    
    // MARK: - FUNCTIONS
    override func draw(_ rect: CGRect) {
        let w = rect.width
        let h = rect.height
        if w != h { fatalError("les tailles ne sont pas cohérentes") }
        let r = w
        
        ///// 1 dessin des contours habituels /////
        // ******** drawing the corners of the case ************ //
        
        game!.colors.strokeColor.setStroke()
        
        let n: CGFloat = 6
        
        let borderPath = UIBezierPath()
        borderPath.move(to: CGPoint.zero)
        borderPath.addLine(to: CGPoint(x: 0, y: r/n))
        borderPath.move(to: CGPoint.zero)
        borderPath.addLine(to: CGPoint(x: r/n, y: 0))
        borderPath.move(to: CGPoint(x: r, y: 0))
        borderPath.addLine(to: CGPoint(x: r - r/n, y: 0))
        borderPath.move(to: CGPoint(x: r, y: 0))
        borderPath.addLine(to: CGPoint(x: r, y: r/n))
        borderPath.move(to: CGPoint(x: r, y: r))
        borderPath.addLine(to: CGPoint(x: r - r/n, y: r))
        borderPath.move(to: CGPoint(x: r, y: r))
        borderPath.addLine(to: CGPoint(x: r , y: r - r/n))
        borderPath.move(to: CGPoint(x: 0, y: r))
        borderPath.addLine(to: CGPoint(x: r/n , y: r))
        borderPath.move(to: CGPoint(x: 0, y: r))
        borderPath.addLine(to: CGPoint(x: 0 , y: r - r/n))
        
        
        ///// 2. différents types de cases /////
        // *********** DESSIN DE LA CASE *************** //
        switch caseState {
            
        case .empty, .marked, .markedByComputer:
            game!.colors.emptyColor.setFill()
            let path = UIBezierPath(rect: rect)
            path.fill()
            borderPath.stroke()
        case .blocked:
            Rayure.drawRayure(frame: rect, resizing: .aspectFill, color: game!.colors.emptyColor, color2: game!.colors.openColor)
        case .open:
            game!.colors.openColor.setFill()
            let path = UIBezierPath(rect: rect)
            path.fill() ;
            // Creation of the label to display the number.
            let myLabel = UILabel()
            let sizeOfLabel = CGSize(width: r, height: r)
            let origin = CGPoint(x: 0, y: 0)
            myLabel.frame = CGRect(origin: origin, size: sizeOfLabel)
            myLabel.textAlignment = .center
            myLabel.textColor = game!.colors.textColor
            
            if gameState[i][j] == 0 {
                myLabel.text = " "
            } else if gameState[i][j] == -1 {
                myLabel.textColor = UIColor.red
                myLabel.text = "O"
            } else {
                if game!.option2 {
                    if random(Int((1/game!.option2Frequency))) == 0 {
                        myLabel.text = "?"
                        myLabel.textColor = game!.colors.emptyColor
                    } else {
                        myLabel.text = "\(gameState[i][j])"
                    }
                } else {
                    myLabel.text = "\(gameState[i][j])"
                }
            }
            self.addSubview(myLabel)
            borderPath.stroke()
        case .none:
            break
        }
        
        
        
        
        
        
        
    }

}
