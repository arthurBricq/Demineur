//
//  caseButton.swift
//  viewOfMineGame_1
//
//  Created by Arthur BRICQ on 21/03/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
class SquareCase: UIButton {
    // This button is the one displaying the cases of the game.
    // Those buttons have many different states
    
    // Pour le dessin des angles
    @IBInspectable var cornersToDraw: [Int] = [1,2,3,4,5,6,7,8]
    @IBInspectable var ratio: CGFloat = 6
    @IBInspectable var lineWidth: CGFloat = 1.0
    
    var i: Int = 0
    var j: Int = 0
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
    
    var openColor = UIColor.white // color for open-case's background
    var emptyColor = UIColor.white // color for empty-case's background
    var strokeColor = UIColor.white
    var textColor = UIColor.black
    
    // Pour l'affichage d'un numero
    var caseState = CaseState.empty {
        didSet {
            
            if option1 {
                if caseState == .open {
                    option1Timer.start(limit: TimeInterval(option1Time), id: "ReturnCase")
                }
            }
            
            if caseState == .marked {
                let flag = FlagView(frame: bounds, circleCenter: CGPoint(x: bounds.width/2, y: bounds.height/2), r: 0.2*bounds.width, color: UIColor.orange)
                addSubview(flag)
                Vibrate().vibrate(style: .medium)
                marked = true
            }
            
            if caseState == .markedByComputer {
                let flag = FlagView(frame: bounds, circleCenter: CGPoint(x: bounds.width/2, y: bounds.height/2), r: 0.2*bounds.width, color: colorForRGB(r: 60, g: 160, b: 100))
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
            
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let w = rect.width
        let h = rect.height
        if w != h { fatalError("les tailles ne sont pas cohérentes") }
        let r = w
        
        ///// 1 dessin des contours habituels /////
        // ******** drawing the corners of the case ************ //
        strokeColor.setStroke()
        let n: CGFloat = ratio
        let borderPath = UIBezierPath()
        
        if cornersToDraw.contains(1) {
            borderPath.move(to: CGPoint.zero)
            borderPath.addLine(to: CGPoint(x: 0, y: r/n))
            borderPath.lineWidth = lineWidth
        }
        if cornersToDraw.contains(2) {
            borderPath.move(to: CGPoint.zero)
            borderPath.addLine(to: CGPoint(x: r/n, y: 0))
            borderPath.lineWidth = lineWidth
        }
        if cornersToDraw.contains(3) {
            borderPath.move(to: CGPoint(x: r, y: 0))
            borderPath.addLine(to: CGPoint(x: r - r/n, y: 0))
            borderPath.lineWidth = lineWidth
        }
        if cornersToDraw.contains(4) {
            borderPath.move(to: CGPoint(x: r, y: 0))
            borderPath.addLine(to: CGPoint(x: r, y: r/n))
            borderPath.lineWidth = lineWidth
        }
        if cornersToDraw.contains(5) {
            borderPath.move(to: CGPoint(x: r, y: r))
            borderPath.addLine(to: CGPoint(x: r - r/n, y: r))
            borderPath.lineWidth = lineWidth
        }
        if cornersToDraw.contains(6) {
            borderPath.move(to: CGPoint(x: r, y: r))
            borderPath.addLine(to: CGPoint(x: r , y: r - r/n))
            borderPath.lineWidth = lineWidth
        }
        if cornersToDraw.contains(7) {
            borderPath.move(to: CGPoint(x: 0, y: r))
            borderPath.addLine(to: CGPoint(x: r/n , y: r))
            borderPath.lineWidth = lineWidth
        }
        if cornersToDraw.contains(8) {
            borderPath.move(to: CGPoint(x: 0, y: r))
            borderPath.addLine(to: CGPoint(x: 0 , y: r - r/n))
            borderPath.lineWidth = lineWidth
        }
        
        ///// 2. différents types de cases /////
        
        // *********** DESSIN DE LA CASE *************** //
        switch caseState {
            
        case .empty, .marked, .markedByComputer:
            emptyColor.setFill()
            let path = UIBezierPath(rect: rect)
            path.fill()
            borderPath.stroke()
            
        case .blocked:
            Rayure.drawRayure(frame: rect, resizing: .aspectFill, color: emptyColor, color2: openColor)
            
        case .open:
            openColor.setFill()
            let path = UIBezierPath(rect: rect)
            path.fill() ;
            // Creation of the label to display the number.
            let myLabel = UILabel()
            let sizeOfLabel = CGSize(width: r, height: r)
            let origin = CGPoint(x: 0, y: 0)
            myLabel.frame = CGRect(origin: origin, size: sizeOfLabel)
            myLabel.textAlignment = .center
            myLabel.textColor = textColor
            number = gameState[i][j]
            if number == 0 {
                myLabel.text = " "
            } else if number == -1 {
                myLabel.textColor = UIColor.red
                myLabel.text = "O"
            } else {
                if option2 {
                    if random(Int((1/option2frequency))) == 0 {
                        myLabel.text = "?"
                        myLabel.textColor = emptyColor
                    } else {
                        myLabel.text = "\(number)"
                    }
                } else {
                    myLabel.text = "\(number)"
                }
            }
            self.addSubview(myLabel)
            borderPath.stroke()
            
        case .none:
            // do nothing here //
            break
        }
        
        //// 3. Surligner les cases qui sont en extrémités.
        /// On ne peut pas dessiner sur les cases qui sont au dessus ou en dessous de soi.
        /// il y a deux cas à distinguer : la case est à un bord blogal.
        /// la case est contre une none case (dans ce cas, il faut que ce soit la methode draw de la none case qui soit appelée.)
        func underlineUpperLine() {
            let contour = UIBezierPath()
            contour.move(to: CGPoint(x: 0, y: 0))
            contour.addLine(to: CGPoint(x: r/n, y: 0))
            contour.move(to: CGPoint(x: r, y: 0))
            contour.addLine(to: CGPoint(x: r - r/n, y: 0))
            contour.lineWidth = 1*lineWidth
            contour.stroke()
        }
        
        func underlineLowestLine() {
            let contour = UIBezierPath()
            contour.move(to: CGPoint(x: 0, y: r))
            contour.addLine(to: CGPoint(x: r/n, y: r))
            contour.move(to: CGPoint(x: r, y: r))
            contour.addLine(to: CGPoint(x: r - r/n, y: r))
            contour.lineWidth = 1*lineWidth
            contour.stroke()
        }
        
        func underlineRightmostLine() {
            let contour = UIBezierPath()
            contour.move(to: CGPoint(x: r, y: 0))
            contour.addLine(to: CGPoint(x: r, y: r/n))
            contour.move(to: CGPoint(x: r, y: r))
            contour.addLine(to: CGPoint(x: r, y: r-r/n))
            contour.lineWidth = 1*lineWidth
            contour.stroke()
        }
        
        func underlineLeftmostLine() {
            let contour = UIBezierPath()
            contour.move(to: CGPoint(x: 0, y: 0))
            contour.addLine(to: CGPoint(x: 0, y: r/n))
            contour.move(to: CGPoint(x: 0, y: r))
            contour.addLine(to: CGPoint(x: 0, y: r-r/n))
            contour.lineWidth = 1*lineWidth
            contour.stroke()
        }
        
        // bordure les plus extérieures //
        let cond_up = (i-1 == -1)
        let cond_down = (i+1 == gameState.count)
        let cond_left = (j-1 == -1)
        let cond_right = (j+1 == gameState[0].count)
        if caseState != .none {
            if cond_up { underlineUpperLine()  }
            if cond_down { underlineLowestLine() }
            if cond_left  { underlineLeftmostLine() }
            if cond_right  { underlineRightmostLine() }
        } else {
            if i+1 != gameState.count && gameState[i+1][j] != -2 { underlineLowestLine() }
            if i-1 != -1 && gameState[i-1][j] != -2 { underlineUpperLine() }
            if j-1 != -1 && gameState[i][j-1] != -2 { underlineLeftmostLine() }
            if j+1 != gameState[0].count && gameState[i][j+1] != -2 { underlineRightmostLine() }
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if caseState == .none { return }
        
        alpha = 0.4
        
        if caseState == .none { return }
        
        if isTheGameStarted.value == false {
            isTheGameStarted.delegate!.createTheGame(withFirstTouched: (i,j)) // le jeu est maintenant crée.
            return
        }
        
        if caseState == .open { return }
        
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
        
        if isTheGameStarted.value == false {
            isTheGameStarted.value = true
        }
        
        if caseState == .open { return }
        // ********* Logique lorsqu'on appuit sur un boutton ********** //
        if isUserInteractionEnabled { // Cela veut dire que le timer ne s'est pas encore terminé.
            markingTimer.stop()
            // on appelle la fonction pour retourner les cases
            
            superViewDelegate!.buttonHaveBeenTapped(i: i, j: j, marking: false)
        } else {
            isUserInteractionEnabled = true
        }
        
        
        
    }
    
    /// Quand la partie se termine, gère les animations de la case.
    func animateGameOver(win: Bool, bombTapped: Bool = false) {
        
        // Si la partie est gagnée
        if win {
            
            for subview in subviews {
                // si la case était marquée
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
            
            // si la partie est perdue
        } else {
            
            // si la case est celle sur laquelle le joueur a tappé
            if bombTapped {
                let cross = BombView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), percentOfCase: 0.4, lineWidth: 4, color: UIColor.red)
                self.addSubview(cross)
                
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 2.3
                scaleAnimation.toValue = 1
                scaleAnimation.duration = 0.5
                scaleAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, -0.1, 0.4, 0.5)
                scaleAnimation.fillMode = kCAFillModeBackwards
                cross.layer.add(scaleAnimation, forKey: nil)
            } else {
                
                // si la case était marquée
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
                    var color: UIColor?
                    if marked {
                        color = colorForRGB(r: 100, g: 200, b: 150)
                    } else {
                        color = UIColor.red
                    }
                    let cross = BombView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), percentOfCase: 0.4, lineWidth: 4, color: color!)
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

extension SquareCase: LimitedTimerProtocol {
    func timeLimitReached(id: String) {
        if id == "Marking" {
            
            superViewDelegate?.buttonHaveBeenTapped(i: i, j: j, marking: true)
            
            markingTimer.stop()
            isUserInteractionEnabled = false
            
        } else if id == "ReturnCase" { /// OPTION 1 HAPPENS HERE.
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

