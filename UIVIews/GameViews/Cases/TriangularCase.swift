//
//  TriangularCases.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 15/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit

class TriangularCase: Case {
    
    // MARK: - VARIABLES
    let lineWidth: CGFloat = 1.5
    
    // MARK: - FUNCTIONS
    override func draw(_ rect: CGRect) {
        // Contrainte sur les dimensions : w = a ; h = sin(alpha)w
        let a: CGFloat = rect.width ;
        
        //// 1. dessin des lignes normales ////
        
        // Il y a deux types de bouttons triangulaires : type 1 et type 2
        // on détermine le type grâce à la logique qui vient ici.
        // Le boutton s'occupe lui même de se dessiner comme il le faut : pas besoin de spécifier le type du boutton.
        let buttonType = triangularButtonIsOfType(i: i, j: j)
        var contourPath = UIBezierPath() // C'est le chemin du contour.
        var p1 = CGPoint()
        var p2 = CGPoint()
        var p3 = CGPoint()
        
        if buttonType == 1 {
            // ***** TRACER DU TRIANGLE DE TYPE 1 ****** //
            p1 = CGPoint(x: 0, y: 0)
            p2 = CGPoint(x: a/2, y: rect.height)
            p3 = CGPoint(x: a, y: 0)
            let line = UIBezierPath()
            line.move(to: p1)
            line.addLine(to: p2)
            line.addLine(to: p3)
            line.addLine(to: p1)
            line.lineWidth = lineWidth
            contourPath = line
        } else if buttonType == 2 {
            // ***** TRACER DU TRIANGLE DE TYPE 2 ****** //
            p1 = CGPoint(x: 0, y: rect.height)
            p2 = CGPoint(x: a, y: rect.height)
            p3 = CGPoint(x: a/2, y: 0)
            let line = UIBezierPath()
            line.move(to: p1)
            line.addLine(to: p2)
            line.addLine(to: p3)
            line.addLine(to: p1)
            line.lineWidth = lineWidth
            contourPath = line
        }
        
        //// 2. Dessin des différents types de cases ////
        game!.colors.strokeColor.setStroke()
        let verticalDisplacement: CGFloat = (buttonType == 1) ? -a/7.5 : +a/7.5 // décaler les vues.
        switch caseState {
            
        case .empty, .marked, .markedByComputer: // Lorsque la case n'est pas encore retourée.
            // Remplir le background
            game!.colors.emptyColor.setFill()
            contourPath.fill()
            contourPath.stroke()
            
        case .blocked:
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            contourPath.addClip()
            Rayure.drawRayure(frame: rect, resizing: .aspectFill, color: game!.colors.emptyColor, color2: game!.colors.openColor)
            context?.restoreGState()
            
        case .open: // Lorsque la case est ouverte.
            // Remplissage des couleurs
            game!.colors.openColor.setFill()
            contourPath.fill()
            contourPath.stroke()
            // Dessin du numéro.
            let myLabel = UILabel()
            let cx = rect.width/2
            let cy = rect.height/2
            let sizeOfLabel = CGSize(width: rect.width, height: rect.width)
            let origin = CGPoint(x: cx - rect.width/2, y: cy - rect.width/2 + verticalDisplacement)
            myLabel.frame = CGRect(origin: origin, size: sizeOfLabel)
            myLabel.textAlignment = .center
            myLabel.textColor = game!.colors.textColor
            
            let number = gameState[i][j] ; var stringToDisplay: String = "" ;
            if number == 0 { stringToDisplay = " " }
            else if number == -1 { myLabel.textColor = .red ;  stringToDisplay = "x"  }
            else {
                if game!.option2 {
                    if random(Int((1/game!.option2Frequency))) == 0 {
                        stringToDisplay = "?"
                    } else {
                        stringToDisplay = "\(number)"
                    }
                } else {
                    stringToDisplay = "\(number)"
                }
            }
            myLabel.text = stringToDisplay
            self.addSubview(myLabel)
            
        case .none: // lorsque la case est supprimée du jeu
            // Pour l'instant : on laisse tout vide.
            break
        }
        
        
        //// 3. Surligner les cases qui se situent sur le bord /////
        /*
         Il y a deux cas à repérer : déjà s'il la case est dans un bord (il faudra surligner les lignes sans voisin); et puis si la case possède un voisin qui est une none case.
         Finalement, il y a aussi pour chaque cas deux versions différentes : pour les cases de type 1 et pour les cases de type 2
         Pour les cases triangulaires, il y a des soucis de largeur uniqueent pour les cases du dessus et du dessous ; les cases latérales n'ont pas de problèmes de surlignement.
         */
        let contour1 = UIBezierPath()
        let minI = 0 ;
        let maxI = gameState.count-1 ;
        // Il y a quatres possibilité : être en haut, être en bas, ... et ils sont deux par deux complémentaire
        let cond_up = (i-1 < minI)
        let cond_down = (i+1 > maxI)
        if triangularButtonIsOfType(i: i, j: j) == 1 {
            if (cond_up && gameState[i][j] != -2) || (!cond_up && gameState[i-1][j] == -2 && gameState[i][j] != -2) {
                contour1.move(to: p1) ; contour1.addLine(to: p3)
            }
        } else { // DEUXIEME TYPE
            if (cond_down && gameState[i][j] != -2) || (!cond_down && gameState[i+1][j] == -2 && gameState[i][j] != -2) {
                contour1.move(to: p2) ; contour1.addLine(to: p1)
            }
        }
        game!.colors.strokeColor.setStroke()
        contour1.lineWidth = 2.2*lineWidth
        contour1.stroke()
        
        
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let x = point.x
        let y = point.y
        let a = self.frame.width
        let h = self.frame.height
        
        let buttonType = triangularButtonIsOfType(i: i, j: j)
        
        if buttonType == 1 {
            if x >= 0 && x <= a/2 {
                if 0 < y && y < 2*h*x/a { return true }
            } else if a/2 < x && x <= a {
                if 0 < y && y < 2*h - 2*h*x/a { return true }
            }
        } else if buttonType == 2 {
            if x <= a/2 && x >= 0 {
                if y > (h - 2*h*x/a) && y < h { return true }
            } else if a/2 < x && x <= a {
                if y > (-h + 2*h*x/a) && y < h { return true  }
            }
        }
        
        return false
    }
    
    
    override func addFlagToCase(flagColor: UIColor) {
        let buttonType = triangularButtonIsOfType(i: i, j: j)
        let verticalDisplacement: CGFloat = (buttonType == 1) ? -bounds.width/7.5 : bounds.width/7.5 // décaler les vues.
        let circleCenter = CGPoint(x: bounds.width/2, y: bounds.height/2 + verticalDisplacement)
        let radius = 0.2*bounds.width
        let id = String(i) + String(j)
        let flag = FlagView(frame: frame, circleCenter: circleCenter, r: radius, id: id, color: flagColor)
        viewOfGame!.addSubview(flag)
        Vibrate().vibrate(style: .medium)
        
    }
    
    
}
