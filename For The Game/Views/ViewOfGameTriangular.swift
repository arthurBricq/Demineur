//
//  ViewOfGameTriangular.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 15/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
/*
class ViewOfGameTriangular: UIView {
    
    // MARK: - Variables sur le jeu en cours
    @IBInspectable var n: Int = 4 // Doit être multiple de 2
    @IBInspectable var m: Int = 4 // Ne doit pas être multiple de 2
    var z: Int = 4
    @IBInspectable var emptyColor: UIColor = .black
    @IBInspectable var openColor: UIColor = .black
    @IBInspectable var strokeColor: UIColor = .black
    @IBInspectable var lineWidth: CGFloat = 1.5
    var textColor = UIColor.black
    var delegateVC: GameViewCanCallVC?
    var gameState = [[Int]].init()
    var option1: Bool = false
    var option1Time: CGFloat = 1.0
    var option2: Bool = false // certains numéros sont remplacés par des "?"
    var option2frequency: CGFloat = 0.5 // probabilité 0 et 1
    var option3Frequency: CGFloat = 0
    var option3Timer = CountingTimer()
    var numberOfFlags: Int = 5 {
        didSet {
            delegateVC?.updateFlagsDisplay(numberOfFlags: numberOfFlags)
        }
    }
    
    // MARK: - Autres variables et la fonction draw(_:)
    /// Permet de compter le nombre total de drapeaux correct que le joueur a posé. Cette closure va rajouter +1 à la variable 'numberOfBombs' du VC si on marque un drapeau au bon endroit.
    var onPosingFlag: ((Bool) -> Void)?
    /// Permet de compter le nombre total de drapeaux correct que le joueur a posé. Cette closure va enlever -1 à la variable 'numberOfBombs' du VC si on enlève un drapeau correct.
    var onUnposingFlag: ((Bool) -> Void)?
    
    override func draw(_ rect: CGRect) {
        // les dimensions de la vue doivent être les bonnes, grâce à la fonction de dimensionnement.
        var a = CGFloat.init()
        // trouver la constante a = a(m,n)
        if m%2 == 0 { a = rect.width*2/CGFloat(m)
        } else { a = rect.width*2/CGFloat(m+1) }
        let h = rect.height / CGFloat(n)
        
        var iteratorPoint = CGPoint(x: 0.0, y: 0.0)
        let size = CGSize(width: a, height: h)
        
        for i in 0..<n {
            for j in 0..<gameState[i].count {
                let button = TriangularCase()
                button.i = i
                button.j = j
//                button.gameState = gameState
//                button.emptyColor = emptyColor
//                button.strokeColor = strokeColor
//                button.textColor = textColor
//                button.lineWidth = lineWidth
//                button.openColor = openColor
//                button.option1 = option1
//                button.option1Time = option1Time
//                button.option1Timer.delegate = button
//                button.option2 = option2
//                button.option2frequency = option2frequency
//                button.superViewDelegate = self
                iteratorPoint.x = CGFloat(j) * a/2
                iteratorPoint.y = CGFloat(i) * h
                button.frame = CGRect(origin: iteratorPoint, size: size)
                if gameState[i][j] == -2 {
                    button.caseState = .none
                } else {
                    button.caseState = .empty
                }
                self.addSubview(button)
            }
        }
    }
}

// MARK: - Fonction qui gère l'ouverture des cases
extension ViewOfGameTriangular: ButtonCanCallSuperView {
    
    func buttonHaveBeenTapped(i: Int, j: Int, marking: Bool) {
        
        func ouvertureRecursive(line i: Int, column j: Int) {
            
            // **** Constant to use **** //
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
            
            if isTheCaseBlocked(i: i, j: j) { return }
            
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
        
        
        if isCaseNone(i: i, j: j) || isTheCaseOpen(i: i, j: j) { return }
        
        if marking { // hold tapping --> have to mark or unmark the card
            
            if !isTheCaseMarked(i: i, j: j) {
                self.onPosingFlag?(isCaseABomb(i: i, j: j))
                markACaseAt(i: i, j: j)
            } else {
                self.onUnposingFlag?(isCaseABomb(i: i, j: j))
                unmarkACaseAt(i: i, j: j)
            }
            
        } else { // Quick tapping --> have to open the case
            if !isTheCaseMarked(i: i, j: j) { // si la case n'est pas marquée.
                if isCaseABomb(i: i, j: j) {
                    
                    delegateVC?.gameOver(win: false, didTapABomb: true, didTimeEnd: false) // End of game
                    callEndAnimation(onButtonAt: i, j: j, win: false, bombTapped: true)
                    
                } else {
                    ouvertureRecursive(line: i, column: j) // To open
                }
            }
        }
        
        if isTheGameFinished() { // end of game
            delegateVC!.gameOver(win: true, didTapABomb: false, didTimeEnd: false)
            returnAllTheCases(win: true)
        }
        
    }
}

// MARK: - Fonctions qui permettent d'obtenir des infos sur la partie
extension ViewOfGameTriangular {
    
    func isTheGameFinished() -> Bool {
        var toReturn = true
        
        for i in 0..<gameState.count {
            for j in 0..<gameState[0].count {
                // We check if all bombs are marked
                if isCaseABomb(i: i, j: j) {
                    if !isTheCaseMarked(i: i, j: j) {
                        toReturn = false
                    }
                }
                
            }
        }
        
        return toReturn
    }
    
    func isTheCaseMarked(i: Int, j: Int) -> Bool {
        let k: Int = i*m + j // indice
        if self.subviews[k] is TriangularCase {
            let tmp = self.subviews[k] as! TriangularCase
            if tmp.caseState == .marked || tmp.caseState == .markedByComputer {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func isTheCaseBlocked(i: Int, j: Int) -> Bool {
        let k: Int = i*m + j // indice
        if self.subviews[k] is TriangularCase {
            let tmp = self.subviews[k] as! TriangularCase
            if tmp.caseState == .blocked {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func isTheCaseOpen(i: Int, j: Int) -> Bool {
        
        let k: Int = i*m + j ; // indice
        
        if self.subviews[k] is TriangularCase {
            let tmp = self.subviews[k] as! TriangularCase
            
            if tmp.caseState == .open {
                return true
            } else {
                return false
            }
        }
        return false
        
    }
    
    func isCaseNone(i: Int, j: Int) -> Bool {
        let k: Int = i*m + j
        if self.subviews[k] is TriangularCase {
            let caseChanging = self.subviews[k] as! TriangularCase
            
            if caseChanging.caseState == .none {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func isCaseABomb(i: Int, j: Int) -> Bool {
        return gameState[i][j] == -1
    }
}

// MARK: - Fonctions qui permettent d'agir sur la partie
extension ViewOfGameTriangular {
    
    func returnACaseAt(i: Int, j: Int) {
        let k: Int = i*m + j // indice
        if self.subviews[k] is TriangularCase {
            let tmp = self.subviews[k] as! TriangularCase
            tmp.caseState = .open
        }
    }
    
    func markACaseAt(i: Int, j: Int, byComputer: Bool = false) {
        
        if numberOfFlags > 0 {
            numberOfFlags = numberOfFlags - 1
        } else {
            return
        }
        
        let k: Int = i*m + j // indice
        if self.subviews[k] is TriangularCase {
            let tmp = self.subviews[k] as! TriangularCase
            
            if byComputer {
                tmp.caseState = .markedByComputer
            } else {
                tmp.caseState = .marked
            }
        }
        
    }
    
    func unmarkACaseAt(i: Int, j: Int) {
        let k: Int = i*m + j // indice
        if self.subviews[k] is TriangularCase {
            let tmp = self.subviews[k] as! TriangularCase
            tmp.caseState = .empty
        }
    }
    
    func blockACaseAt(i: Int, j: Int) {
        let k: Int = i*m + j // indice
        if self.subviews[k] is TriangularCase {
            let tmp = self.subviews[k] as! TriangularCase
            if tmp.caseState == .empty {
                tmp.caseState = .blocked
                tmp.isUserInteractionEnabled = false
            }
        }
        
    }
    
    func unblockACaseAt(i: Int, j: Int) {
        let k: Int = i*m + j // indice
        if self.subviews[k] is TriangularCase {
            let tmp = self.subviews[k] as! TriangularCase
            tmp.caseState = .empty
            tmp.isUserInteractionEnabled = true
        }
        
    }
    
    func updateAllNumbers() {
        for button in self.subviews {
            if button is TriangularCase {
                let button = button as! TriangularCase
//                button.gameState = gameState
            }
        }
    }
    
    func markARandomBomb() {
        // une chance sur deux de partir du haut
        let cas = random(2) + 1
        
        let n = gameState.count
        for i in 0..<n {
            let m = gameState[i].count
            
            for j in 0..<m {
                
                switch cas {
                case 1:
                    if isCaseABomb(i: i, j: j) {
                        if !isTheCaseMarked(i: i, j: j) {
                            
                            markACaseAt(i: i, j: j, byComputer: true)
                            
                            if isTheGameFinished() { // end of game
                                delegateVC!.gameOver(win: true, didTapABomb: false, didTimeEnd: false)
                                returnAllTheCases(win: true)
                            }
                            
                            return
                            
                        }
                    }
                case 2:
                    if isCaseABomb(i: n-i-1, j: m-j-1) {
                        if !isTheCaseMarked(i: n-i-1, j: m-j-1) {
                            
                            markACaseAt(i: n-i-1, j: m-j-1, byComputer: true)
                            
                            if isTheGameFinished() { // end of game
                                delegateVC!.gameOver(win: true, didTapABomb: false, didTimeEnd: false)
                                returnAllTheCases(win: true)
                            }
                            
                            return
                            
                        }
                    }
                default:
                    break
                }
            }
        }
        
    }
    
    func verificationBonusFunc() {
        for subview in subviews {
            
            guard let triangularCase = subview as? TriangularCase else { continue }
            
            if triangularCase.caseState == .marked || triangularCase.caseState == .markedByComputer {
                
                for subview2 in triangularCase.subviews {
                    guard let flag = subview2 as? FlagView else { continue }
                    if flag.tag != 1 {
                        UIView.animate(withDuration: 0.2, animations: {
                            flag.frame = CGRect(x: -5, y: -5, width: flag.frame.width + 10, height: flag.frame.height + 10)
                        }) { (_) in
                            if dataManager.verificationLevel == 0 && random(2) == 1 {
                                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                                    flag.frame = CGRect(x: 0, y: 0, width: flag.frame.width - 10, height: flag.frame.height - 10)
                                }, completion: nil)
                                
                            } else if self.isCaseABomb(i: triangularCase.i, j: triangularCase.j) {
                                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                                    flag.frame = CGRect(x: 0, y: 0, width: flag.frame.width - 10, height: flag.frame.height - 10)
                                }, completion: { (_) in
                                    flag.removeFromSuperview()
                                    flag.color = colorForRGB(r: 60, g: 160, b: 100)
                                    flag.tag = 1
                                    triangularCase.addSubview(flag)
                                    flag.setNeedsDisplay()
                                })
                            } else {
                                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                                    flag.frame = CGRect(x: 0, y: 0, width: flag.frame.width - 10, height: flag.frame.height - 10)
                                }, completion: nil)
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    
    func returnAllTheCases(win: Bool = false) {
        for i in 0..<gameState.count {
            for j in 0..<gameState[i].count {
                if isCaseABomb(i: i, j: j) {
                    callEndAnimation(onButtonAt: i, j: j, win: win)
                }  else if isTheCaseMarked(i: i, j: j) {
                    callEndAnimation(onButtonAt: i, j: j, win: false)
                }
            }
        }
    }
    
    func callEndAnimation(onButtonAt i: Int, j: Int, win: Bool, bombTapped: Bool = false) {
        let buttonTappedId = i*m + j
        if self.subviews[buttonTappedId] is TriangularCase {
            let buttonTapped = self.subviews[buttonTappedId] as! TriangularCase
            buttonTapped.animateGameOver(win: win, bombTapped: bombTapped)
        }
    }
}

// MARK: - Gère les timers
extension ViewOfGameTriangular: CountingTimerProtocol {
    func timerFires(id: String) {
        if id == "Option3" {
            
            for subview in subviews {
                if subview is TriangularCase {
                    let triangle = subview as! TriangularCase
                    if triangle.caseState == .blocked && random(100) < Int(option3Frequency*100)  {
                        triangle.caseState = .empty
                        triangle.isUserInteractionEnabled = true
                    }
                }
            }
            
            if random(100) < Int(option3Frequency*100) {
                let randN = random(n)
                let randM = random(m)
                blockACaseAt(i: randN, j: randM)
            }
            
        }
    }
    
    func pauseAllOption1Timers() {
        if option1 {
            for subview in subviews {
                guard let triangle = subview as? TriangularCase else { continue }
                triangle.option1Timer.pause()
            }
        }
    }
    
    func unPauseAllOption1Timers() {
        if option1 {
            for subview in subviews {
                guard let triangle = subview as? TriangularCase else { continue }
                triangle.option1Timer.play()
            }
        }
    }
}
*/
