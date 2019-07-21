//
//  Case.swift
//  Demineur
//
//  Created by Arthur BRICQ on 25/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit
import CoreData

/// This class represents one abstract case  (it is never to be instantiated)
/// Methods that needs to be overriden: draw method (plus properties)

class Case: UIButton {
    
    // MARK: - Variables
    
    var i: Int = 0
    var j: Int = 0
    var game: OneGame?
    var gameState : [[Int]] {
        return viewOfGame!.gameState
    }
    var viewOfGame: ViewOfGame?
    var markingTimer = LimitedTimer()
    var option1Timer = LimitedTimer()
    var caseState: CaseState = .empty  {
        didSet {
            setNeedsDisplay()
            if game!.option1 && caseState == .open {
                option1Timer.start(limit: TimeInterval(game!.option1Time), id: "ReturnCase")
            }
            if caseState == .marked {
                addFlagToCase(flagColor: UIColor.orange)
            }
            if caseState == .markedByComputer {
                addFlagToCase(flagColor: Color.rgb(60, 160, 100))
            }
            if caseState == .empty {
                removeFlag()
            }
        }
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("This class does not support NSCoding") }
    
    convenience init(frame: CGRect, game: OneGame, i: Int, j: Int, viewOfGame: ViewOfGame) {
        self.init(frame: frame)
        self.game = game
        self.i = i
        self.j = j
        // self.gameState = gameState
        self.viewOfGame = viewOfGame
        option1Timer.delegate = self 
        markingTimer.delegate = self
    }
        
    // MARK: - Function when tapped
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if caseState == .none || caseState == .open { return }
        alpha = 0.4
        if isTheGameStarted.value == false {
            isTheGameStarted.delegate!.createTheGame(withFirstTouched: (i,j)) // le jeu est maintenant crée.
            isTheGameStarted.value = true
            return
        }
        // Starts the marking time
        markingTimer.start(limit: TimeInterval(dataManager.giveTimeToMantain()), id: "Marking")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        if caseState == .none || caseState == .open { return }
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1.0
        }
        // ********* Logique lorsqu'on appuit sur un boutton ********** //
        if isUserInteractionEnabled { // Cela veut dire que le timer ne s'est pas encore terminé.
            markingTimer.stop()
            // on appelle la fonction pour retourner les cases
            viewOfGame!.buttonHaveBeenTapped(i: i, j: j, marking: false)
        } else {
            isUserInteractionEnabled = true
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // Stopping the timer
        markingTimer.stop()
        UIView.animate(withDuration: 0.1) {
            self.alpha = 1.0
        }
    }
    
    // MARK: - Functions

    func addFlagToCase(flagColor: UIColor) {
        let circleCenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = 0.2*bounds.width
        let id = String(i) + String(j)
        let flag = FlagView(frame: frame, circleCenter: circleCenter, r: radius, id: id, color: flagColor)
        viewOfGame!.addSubview(flag)
        Vibrate().vibrate(style: .medium)
    }

    private func removeFlag() {
        for subview in viewOfGame!.subviews {
            if subview is FlagView {
                let flag = subview as! FlagView
                if flag.id == String(i) + String(j) {
                    flag.removeFromSuperview()
                    Vibrate().vibrate(style: .light)
                }
            }
        }
    }
    
    /// Quand la partie se termine, gère les animations de la case.
    func animateGameOver(win: Bool, bombTapped: Bool = false) {
        if win {
            for subview in viewOfGame!.subviews {
                // Pour le drapeau
                if subview is FlagView {
                    let flag = subview as! FlagView
                    if flag.id == String(i) + String(j) {
                        // si la case était une bombe
                        if gameState[i][j] == -1 {
                            // La case était marquée et était une bombe
                            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                            scaleAnimation.values = [1.0, 0.9, 1.7, 1.1]
                            scaleAnimation.keyTimes = [0, 0.2, 0.6, 1]
                            scaleAnimation.duration = 0.5
                            scaleAnimation.isRemovedOnCompletion = false
                            scaleAnimation.fillMode = CAMediaTimingFillMode.forwards
                            subview.layer.add(scaleAnimation, forKey: nil)
                        } else {
                            // La case était marquée et n'était pas une bombe
                            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                            scaleAnimation.values = [1.0, 1.3, 0]
                            scaleAnimation.keyTimes = [0, 0.2, 1]
                            scaleAnimation.duration = 0.5
                            scaleAnimation.isRemovedOnCompletion = false
                            scaleAnimation.fillMode = CAMediaTimingFillMode.forwards
                            subview.layer.add(scaleAnimation, forKey: nil)
                        }
                    }
                }
            }
        } else {
            // La partie est perdue
            // si la case est celle sur laquelle le joueur a tappé
            if bombTapped {
                var verticalDisplacement: CGFloat = 0
                if self.game!.gameType == .triangular {
                    let triangularCase = self as! TriangularCase
                    verticalDisplacement = (triangularButtonIsOfType(i: triangularCase.i, j: triangularCase.j) == 1) ? -bounds.width/7.5 : bounds.width/7.5 // décaler les vues.
                }
                let cross = BombView(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y + verticalDisplacement, width: self.frame.width, height: self.frame.height), percentOfCase: 0.35, lineWidth: 4, color: UIColor.red)
                self.viewOfGame!.addSubview(cross)
                
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 2.3
                scaleAnimation.toValue = 1
                scaleAnimation.duration = 0.5
                scaleAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, -0.1, 0.4, 0.5)
                scaleAnimation.fillMode = CAMediaTimingFillMode.backwards
                cross.layer.add(scaleAnimation, forKey: nil)
            } else {
                // si la case était marquée
                if caseState == .marked || caseState == .markedByComputer {
                    for subview in viewOfGame!.subviews {
                        if subview is FlagView {
                            let flag = subview as! FlagView
                            if flag.id == String(i) + String(j) {
                                let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                                scaleAnimation.values = [1.0, 1.3, 0]
                                scaleAnimation.keyTimes = [0, 0.2, 1]
                                scaleAnimation.duration = 0.5
                                scaleAnimation.isRemovedOnCompletion = false
                                scaleAnimation.fillMode = CAMediaTimingFillMode.forwards
                                subview.layer.add(scaleAnimation, forKey: nil)
                            }
                        }
                    }
                }
                // si la case était une bombe
                if gameState[i][j] == -1 {
                    var color: UIColor?
                    if caseState == .marked || caseState == .markedByComputer {
                        color = Color.rgb(100, 200, 150)
                    } else {
                        color = UIColor.red
                    }
                    var verticalDisplacement: CGFloat = 0
                    if self.game!.gameType == .triangular {
                        let triangularCase = self as! TriangularCase
                        verticalDisplacement = (triangularButtonIsOfType(i: triangularCase.i, j: triangularCase.j) == 1) ? -bounds.width/7.5 : bounds.width/7.5 // décaler les vues.
                    }
                    let cross = BombView(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y + verticalDisplacement, width: self.frame.width, height: self.frame.height), percentOfCase: 0.35, lineWidth: 4, color: color!)
                    viewOfGame!.addSubview(cross)
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

extension Case: LimitedTimerProtocol {
    func timeLimitReached(id: String) {
        if id == "Marking" {
            viewOfGame!.buttonHaveBeenTapped(i: i, j: j, marking: true)
            markingTimer.stop()
            // Block the case
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
