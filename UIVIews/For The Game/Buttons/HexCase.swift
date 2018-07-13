//
//  HexCase.swift
//  HexagoneViewMineIt
//
//  Created by Arthur BRICQ on 30/03/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

@IBDesignable
class HexCase: UIButton
{ // La vue doit être un carré
    
    @IBInspectable var strokeColor: UIColor = .black // Pour les contours
    @IBInspectable var emptyColor: UIColor = .black // Pour le background des cases vides
    @IBInspectable var openColor: UIColor = .black // Pour le background des cases ouvertes
    @IBInspectable var textColor: UIColor = .black
    @IBInspectable var lineWidth: CGFloat = 1.5 // Pour l'épaisseur des lignes.
    @IBInspectable var name: String = ""
    
    @IBInspectable var i: Int = 0
    @IBInspectable var j: Int = 0
    var numberOfColumns: Int = 4
    var number: Int = 0
    var marked: Bool = false
    var gameState = [[Int]].init()
    
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
        }
    }
    
    
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
        strokeColor.setStroke()
        contourPath.lineWidth = lineWidth
        
        //// 2.
        // ******* Personnalisation des cases en fonction de leur état ******* //
        strokeColor.setStroke()
        switch caseState {
            
        case .empty, .marked:
            emptyColor.setFill()
            contourPath.fill()
            contourPath.stroke()
            
        case .blocked:
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()
            contourPath.addClip()
            Rayure.drawRayure(frame: rect, resizing: .aspectFill, color: emptyColor, color2: openColor)
            context?.restoreGState()
            
        case .open:
            // background color
            openColor.setFill()
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
            myLabel.textColor = textColor
            
            number = gameState[i][j]
            var stringToDisplay: String = ""
            if number == 0 { stringToDisplay = " " }
            else if number == -1 { myLabel.textColor = .red ;  stringToDisplay = "\(number)"  }
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
        if shouldThisLineContainsAllButtons(atLine: i) {
            if (j == numberOfColumns-1 && gameState[i][j] != -2) || (j < numberOfColumns-1 &&  gameState[i][j+1] == -2 && gameState[i][j] != -2 ) {
                let newPath = UIBezierPath()
                newPath.lineWidth = 2*lineWidth
                newPath.move(to: p2)
                newPath.addLine(to: p3)
                newPath.stroke()
            }
        } else {
            if (j == numberOfColumns-2 && gameState[i][j] != -2 ) || (j < numberOfColumns-2 &&  gameState[i][j+1] == -2 && gameState[i][j] != -2 )  {
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        if caseState == .none { return }
        
        alpha = 0.4
        
        if caseState == .none { return }
        
        if isTheGameStarted.value == false { // si c'est la première fois qu'on tappe.
            isTheGameStarted.delegate!.createTheGame(withFirstTouched: (i,j)) // le jeu est maintenant crée.
            return
        }
        
        if caseState == .open { return }
        
        // **** logique du timer **** //
        markingTimer.delegate = self
        markingTimer.start(limit: 0.3, id: "Marking")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        
        if caseState == .none { return }
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1.0
        }
        
        if caseState == .none { return }
        
        if isTheGameStarted.value == false { // si c'est la première fois qu'on tappe.
            print("B")
            isTheGameStarted.value = true
            //superViewDelegate!.buttonHaveBeenTapped(i: i, j: j, marking: false)
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
    
    func animateGameOver(win: Bool, bombTapped: Bool = false) {
        print("i = \(i)   j = \(j)    win = \(win)")
        if win {
            
            for subview in subviews {
                if subview is FlagView {
                    
                    // si la case était une bombe
                    if gameState[i][j] == -1 {
                        
                        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                        scaleAnimation.values = [1.0, 0.9, 1.7, 1.1]
                        scaleAnimation.keyTimes = [0, 0.2, 0.6, 1]
                        scaleAnimation.duration = 0.5
                        scaleAnimation.isRemovedOnCompletion = false
                        scaleAnimation.fillMode = kCAFillModeForwards
                        subview.layer.add(scaleAnimation, forKey: nil)
                        
                    } else {
                        print("a")
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
            
        } else {
            if bombTapped {
                
                let cross = BombView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), percentOfCase: 0.4, lineWidth: 4, color: UIColor.red)
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
                
                // si la case était une bombe
                if gameState[i][j] == -1 {
                    let cross = BombView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), percentOfCase: 0.4, lineWidth: 4, color: UIColor.red)
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

extension HexCase: LimitedTimerProtocol {
    func timeLimitReached(id: String) {
        if id == "Marking" {
            
            superViewDelegate?.buttonHaveBeenTapped(i: i, j: j, marking: true)
            
            if caseState == .marked {
                let flag = FlagView(frame: bounds, circleCenter: CGPoint(x: bounds.width/2, y: bounds.height/2), r: 0.2*bounds.width, color: UIColor.orange)
                addSubview(flag)
                Vibrate().vibrate(style: .medium)
                marked = true
            } else if caseState == .empty {
                for subview in subviews {
                    if subview is FlagView {
                        let flag = subview as! FlagView
                        flag.removeFromSuperview()
                        Vibrate().vibrate(style: .light)
                        marked = false
                    }
                }
            }
            
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


