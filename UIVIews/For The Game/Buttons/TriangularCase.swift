//
//  TriangularCases.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 15/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit


// @IBDesignable
class TriangularCase: UIButton {
    
    @IBInspectable var strokeColor: UIColor = .black
    @IBInspectable var emptyColor: UIColor = .black
    @IBInspectable var openColor: UIColor = .black
    @IBInspectable var textColor: UIColor = .black
    
    @IBInspectable var lineWidth: CGFloat = 1.5
    
    @IBInspectable var i: Int = 0
    @IBInspectable var j: Int = 0
    var gameState = [[Int]].init()
    var marked: Bool = false
    
    var superViewDelegate: ButtonCanCallSuperView?
    var markingTimer = LimitedTimer()
    
    var option1: Bool = false
    var option1Time: CGFloat = 1.0
    var option1Timer = LimitedTimer()
    var option2: Bool = false // certains numéros sont remplacés par des "?"
    var option2frequency: CGFloat = 0.5 // probabilité 0 et 1
    
    var caseState: CaseState = CaseState.empty {
        didSet {
            
            setNeedsDisplay()
            
            if option1 {
                if caseState == .open {
                    option1Timer.start(limit: TimeInterval(option1Time), id: "ReturnCase")
                }
            }
            
            if caseState == .marked {
                let buttonType = triangularButtonIsOfType(i: i, j: j)
                let verticalDisplacement: CGFloat = (buttonType == 1) ? -bounds.width/7.5 : bounds.width/7.5 // décaler les vues.
                let flag = FlagView(frame: bounds, circleCenter: CGPoint(x: bounds.width/2, y: bounds.height/2 + verticalDisplacement), r: 0.16*bounds.width, color: UIColor.orange)
                addSubview(flag)
                Vibrate().vibrate(style: .medium)
                marked = true
            }
            
            if caseState == .markedByComputer {
                let buttonType = triangularButtonIsOfType(i: i, j: j)
                let verticalDisplacement: CGFloat = (buttonType == 1) ? -bounds.width/7.5 : bounds.width/7.5 // décaler les vues.
                let flag = FlagView(frame: bounds, circleCenter: CGPoint(x: bounds.width/2, y: bounds.height/2 + verticalDisplacement), r: 0.16*bounds.width, color: colorForRGB(r: 60, g: 160, b: 100))
                addSubview(flag)
                Vibrate().vibrate(style: .medium)
                marked = true
            }
            
            if caseState == .empty {
                
                for subview in subviews {
                    if subview is FlagView {
                        let flag = subview as! FlagView
                        flag.removeFromSuperview()
                        Vibrate().vibrate(style: .light)
                        marked = false
                    }
                }
            }
            
        }
    }
    
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
        strokeColor.setStroke()
        let verticalDisplacement: CGFloat = (buttonType == 1) ? -a/7.5 : +a/7.5 // décaler les vues.
        switch caseState {
            
        case .empty, .marked, .markedByComputer: // Lorsque la case n'est pas encore retourée.
            // Remplir le background
            emptyColor.setFill()
            contourPath.fill()
            contourPath.stroke()
            
        case .blocked:
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            contourPath.addClip()
            Rayure.drawRayure(frame: rect, resizing: .aspectFill, color: emptyColor, color2: openColor)
            context?.restoreGState()
            
        case .open: // Lorsque la case est ouverte.
            // Remplissage des couleurs
            openColor.setFill()
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
            myLabel.textColor = textColor
            
            let number = gameState[i][j] ; var stringToDisplay: String = "" ;
            if number == 0 { stringToDisplay = " " }
            else if number == -1 { myLabel.textColor = .red ;  stringToDisplay = "x"  }
            else {
                if option2 {
                    if random(Int((1/option2frequency))) == 0 {
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
        strokeColor.setStroke()
        contour1.lineWidth = 2.2*lineWidth
        contour1.stroke()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        if caseState == .none { return }
        alpha = 0.4
        
        if isTheGameStarted.value == false { // si c'est la première fois qu'on tappe.
            isTheGameStarted.delegate!.createTheGame(withFirstTouched: (i,j)) // le jeu est maintenant crée.
            return
        }
        
        if caseState == .open { return }
        
        // **** logique du timer **** //
        markingTimer.delegate = self
        markingTimer.start(limit: 0.4, id: "Marking")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        
        if caseState == .none { return }
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1.0
        }
        
        if isTheGameStarted.value == false { // si c'est la première fois qu'on tappe.
            isTheGameStarted.value = true
            superViewDelegate!.buttonHaveBeenTapped(i: i, j: j, marking: false)
            return
        }
        
        if caseState == .open { return }
        
        // ********* Logique lorsqu'on appuit sur un boutton ********** //
        if isUserInteractionEnabled { // Button have been tapped without marking
            markingTimer.stop()
            superViewDelegate!.buttonHaveBeenTapped(i: i, j: j, marking: false)
        } else {
            isUserInteractionEnabled = true
        }
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
    
    func animateGameOver(win: Bool, bombTapped: Bool = false) {
        
        let buttonType = triangularButtonIsOfType(i: i, j: j)
        let verticalDisplacement: CGFloat = (buttonType == 1) ? -self.bounds.width/7.5 : +self.bounds.width/7.5
        
        if win {
            
            for subview in subviews {
                if subview is FlagView {
                    
                    let buttonType = triangularButtonIsOfType(i: i, j: j)
                    let verticalDisplacement: CGFloat = (buttonType == 1) ? -bounds.width/7.5 : bounds.width/7.5
                    let translationAnimation = CABasicAnimation(keyPath: "position.y")
                    translationAnimation.toValue = subview.layer.position.y - verticalDisplacement/2
                    
                    let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                    if gameState[i][j] == -1 {
                        scaleAnimation.values = [1.0, 0.9, 1.7, 1.1]
                        scaleAnimation.keyTimes = [0, 0.2, 0.6, 1]
                    } else {
                        scaleAnimation.values = [1.0, 1.3, 0]
                        scaleAnimation.keyTimes = [0, 0.2, 1]
                    }
                    
                    let groupAnimation = CAAnimationGroup()
                    groupAnimation.animations = [translationAnimation, scaleAnimation]
                    groupAnimation.duration = 0.5
                    groupAnimation.isRemovedOnCompletion = false
                    groupAnimation.fillMode = kCAFillModeForwards
                    subview.layer.add(groupAnimation, forKey: nil)
                    
                }
            }
            
        } else {
            if bombTapped {
                
                let cross = BombView(frame: CGRect(x: 0, y: verticalDisplacement, width: self.frame.width, height: self.frame.height), percentOfCase: 0.35, lineWidth: 4, color: UIColor.red)
                self.addSubview(cross)
                
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 1.8
                scaleAnimation.toValue = 1
                scaleAnimation.duration = 0.5
                scaleAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, -0.1, 0.4, 0.5)
                scaleAnimation.fillMode = kCAFillModeBackwards
                cross.layer.add(scaleAnimation, forKey: nil)
                
            } else {
                
                if marked {
                    for subview in subviews {
                        if subview is FlagView {
                            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                            scaleAnimation.values = [1.0, 1.3, 0]
                            scaleAnimation.keyTimes = [0, 0.2, 1]
                            scaleAnimation.duration = 0.5
                            scaleAnimation.isRemovedOnCompletion = false
                            scaleAnimation.fillMode = kCAFillModeForwards
                            subview.layer.add(scaleAnimation, forKey: nil)
                        }
                    }
                }
                
                if gameState[i][j] == -1 {
                    let cross = BombView(frame: CGRect(x: 0, y: verticalDisplacement, width: self.frame.width, height: self.frame.height), percentOfCase: 0.35, lineWidth: 4, color: UIColor.red)
                    self.addSubview(cross)
                    
                    let alphaAnimation = CABasicAnimation(keyPath: "opacity")
                    alphaAnimation.fromValue = 0
                    alphaAnimation.toValue = 1
                    alphaAnimation.duration = 0.5
                    alphaAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0, 0.7, 0.4)
                    cross.layer.add(alphaAnimation, forKey: nil)
                }
            }
        }
        
    }
    
}

extension TriangularCase: LimitedTimerProtocol {
    func timeLimitReached(id: String) {
        if id == "Marking" {
            
            superViewDelegate?.buttonHaveBeenTapped(i: i, j: j, marking: true)
            
            
            
            markingTimer.stop()
            isUserInteractionEnabled = false
            
        } else if id == "ReturnCase" {
            if self.caseState == .open {
                self.caseState = .empty
                if self.subviews.count > 0 {
                    self.subviews[0].removeFromSuperview()
                }
                setNeedsDisplay()
            }
        }
    }
}

