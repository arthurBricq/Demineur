//
//  ViewOfGame.swift
//  viewOfMineGame_1
//
//  Created by Arthur BRICQ on 24/03/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

// @IBDesignable
/*
class ViewOfGameSquare: UIView {
    
    // MARK: - Variables
    @IBInspectable var n: Int = 4 // number of rows
    @IBInspectable var m: Int = 4 // number of columns
    var z: Int = 4
    @IBInspectable var ratio: CGFloat = 5
    @IBInspectable var lineWidth: CGFloat = 1.0
    var delegate: GameViewCanCallVC?
    var gameState = [[Int]].init()
    var option1: Bool = false
    var option1Time: CGFloat = 1.0
    var option2: Bool = false // certains numéros sont remplacés par des "?"
    var option2frequency: CGFloat = 0.5 // probabilité 0 et 1
    var option3Frequency: CGFloat = 0
    var option3Timer = CountingTimer()
    var numberOfFlags: Int = 5 {
        didSet {
            delegate?.updateFlagsDisplay(numberOfFlags: numberOfFlags)
        }
    }
    
    // MARK: - Autres variables et la fonction draw(_:)
    /// Permet de compter le nombre total de drapeaux correct que le joueur a posé. Cette closure va rajouter +1 à la variable 'numberOfBombs' du VC si on marque un drapeau au bon endroit.
    var onPosingFlag: ((Bool) -> Void)?
    /// Permet de compter le nombre total de drapeaux correct que le joueur a posé. Cette closure va enlever -1 à la variable 'numberOfBombs' du VC si on enlève un drapeau correct.
    var onUnposingFlag: ((Bool) -> Void)?
    
    var openColor = UIColor.white // color for open-case's background
    var emptyColor = UIColor.white // color for empty-case's background
    var strokeColor = UIColor.white
    var textColor = UIColor.black
    
    override func draw(_ rect: CGRect){
        var positionnerPoint: CGPoint = CGPoint.zero // iterator point
        let a = rect.width/CGFloat(m) ;
        let caseSize = CGSize(width: a, height: a)
        // ********** Creation of Buttons *************** //
        for i in 0..<n {
            for j in 0..<m {
                
                let newCase = SquareCase()
                newCase.i = i
                newCase.j = j
//                newCase.gameState = gameState
                newCase.option1Timer.delegate = newCase
                
                
                newCase.layer.masksToBounds = false
                
                if gameState[i][j] == -2 {
                    newCase.caseState = .none
                }
                
                newCase.frame = CGRect(origin: positionnerPoint, size: caseSize)
                self.addSubview(newCase)
                
                let x = positionnerPoint.x
                let y = positionnerPoint.y
                positionnerPoint = CGPoint(x: x + a, y: y)
                
            }
            
            let y = positionnerPoint.y
            positionnerPoint = CGPoint(x: 0, y: y + a)
        }
        
    }
    
}

// MARK: - Fonction qui gère l'ouverture des cases

extension ViewOfGameSquare: ButtonCanCallSuperView {
    func buttonHaveBeenTapped(i: Int, j: Int, marking: Bool) { // this function has all the logic whenever a button is tapped.
        
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
            if !cond1 { return } else {
                let cond2 = !isTheCaseOpen(i: i, j: j)
                let cond3 = !isTheCaseMarked(i: i, j: j)
                let cond4 = !isCaseNone(i: i, j: j)
                hasToOpen = cond1 && cond2 && cond3 && cond4
                
                // followings condition are true if we should not continue the recursion
                if gameState[i][j] == 0 {
                    hasToContinue = true
                }
                
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
                ouvertureRecursive(line: i, column: j-1)
                ouvertureRecursive(line: i-1, column: j-1)
                ouvertureRecursive(line: i-1, column: j)
                ouvertureRecursive(line: i-1, column: j+1)
                ouvertureRecursive(line: i, column: j+1)
            } else {
                return
            }
            
        }
        
        if isCaseNone(i: i, j: j) || isTheCaseOpen(i: i, j: j) { return }
        
        if marking { // hold tapping --> have to mark or unmark the card
            
            // Then ... 
            if !isTheCaseMarked(i: i, j: j)
            {
                let test = isCaseABomb(i: i, j: j)
                self.onPosingFlag?(test)
                
                markACaseAt(i: i, j: j)
            } else {
                self.onUnposingFlag?(isCaseABomb(i: i, j: j))
                unmarkACaseAt(i: i, j: j)
            }
            
            
        } else { // Quick tapping --> have to open the case
            if !isTheCaseMarked(i: i, j: j) { // si la case n'est pas marquée.
                if isCaseABomb(i: i, j: j) {
                    
                    
                    // Le joueur a tapé sur une bombe
                    delegate?.gameOver(win: false, didTapABomb: true, didTimeEnd: false)
                    callEndAnimation(onButtonAt: i, j: j, win: false, bombTapped: true)
                    
                } else {
                    ouvertureRecursive(line: i, column: j) // To open
                }
            }
        }
        
        if isTheGameFinished() { // end of game
            
            
            delegate!.gameOver(win: true, didTapABomb: false, didTimeEnd: false)
            returnAllTheCases(win: true)
            
        }
        
    }
}

// MARK: - Fonctions pour obtenir des infos sur la partie en cours
extension ViewOfGameSquare {
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
        if self.subviews[k] is SquareCase {
            let tmp = self.subviews[k] as! SquareCase
            if tmp.caseState == .marked || tmp.caseState == .markedByComputer {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func isTheCaseOpen(i: Int, j: Int) -> Bool {
        
        let k: Int = i*m + j ; // indice
        if self.subviews[k] is SquareCase {
            let tmp = self.subviews[k] as! SquareCase
            
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
        if self.subviews[k] is SquareCase {
            let caseChanging = self.subviews[k] as! SquareCase
            
            if caseChanging.caseState == .none {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func isCaseBlocked(i: Int, j: Int) -> Bool {
        let k: Int = i*m + j
        if self.subviews[k] is SquareCase {
            let caseWatched = self.subviews[k] as! SquareCase
            if caseWatched.caseState == .blocked {
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

// MARK: - Fonctions pour agir sur la partie
extension ViewOfGameSquare {
    func returnACaseAt(i: Int, j: Int) {
        
        let k: Int = i*m + j // indice
        if self.subviews[k] is SquareCase {
            let tmp = self.subviews[k] as! SquareCase
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
        if self.subviews[k] is SquareCase {
            let tmp = self.subviews[k] as! SquareCase
            if byComputer {
                tmp.caseState = .markedByComputer
            } else {
                tmp.caseState = .marked
            }
        }
        
    }
    
    func unmarkACaseAt(i: Int, j: Int) {
        let k: Int = i*m + j // indice
        if self.subviews[k] is SquareCase {
            let tmp = self.subviews[k] as! SquareCase
            tmp.caseState = .empty
        }
        
    }
    
    func blockACaseAt(i: Int, j: Int) {
        let k: Int = i*m + j // indice
        if self.subviews[k] is SquareCase {
            let tmp = self.subviews[k] as! SquareCase
            if tmp.caseState == .empty {
                tmp.caseState = .blocked
                tmp.isUserInteractionEnabled = false
            }
        }
        
    }
    
    func unblockACaseAt(i: Int, j: Int) {
        let k: Int = i*m + j // indice
        if self.subviews[k] is SquareCase {
            let tmp = self.subviews[k] as! SquareCase
            tmp.caseState = .empty
            tmp.isUserInteractionEnabled = true
        }
        
    }
    
    func updateAllNumbers() {
        for button in self.subviews {
            if button is SquareCase {
                let button = button as! SquareCase
                // button.gameState = gameState
            }
        }
    }
    
    func returnAllTheCases(win: Bool = false) {
        for i in 0..<gameState.count {
            for j in 0..<gameState[i].count {
                if isCaseABomb(i: i, j: j) {
                    callEndAnimation(onButtonAt: i, j: j, win: win)
                } else if isTheCaseMarked(i: i, j: j) {
                    callEndAnimation(onButtonAt: i, j: j, win: false)
                }
            }
        }
    }
    
    func callEndAnimation(onButtonAt i: Int, j: Int, win: Bool, bombTapped: Bool = false) {
        let buttonTappedId = i*m + j
        if self.subviews[buttonTappedId] is SquareCase {
            let buttonTapped = self.subviews[buttonTappedId] as! SquareCase
            buttonTapped.animateGameOver(win: win, bombTapped: bombTapped)
        }
    }
    
    
    /**
 Cette fonction est appelé pour le bonus 'bombe' afin de retourner une bombe aléatoire
    */
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
                            
                            // si on gagne la partie à l'aide du bonus ...
                            
                            if isTheGameFinished() { // end of game
                                delegate!.gameOver(win: true, didTapABomb: false, didTimeEnd: false)
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
                                delegate!.gameOver(win: true, didTapABomb: false, didTimeEnd: false)
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
            
            guard let squareCase = subview as? SquareCase else { continue }
            
            if squareCase.caseState == .marked || squareCase.caseState == .markedByComputer {
                
                for subview2 in squareCase.subviews {
                    guard let flag = subview2 as? FlagView else { continue }
                    if flag.tag != 1 {
                        UIView.animate(withDuration: 0.2, animations: {
                            flag.frame = CGRect(x: -5, y: -5, width: flag.frame.width + 10, height: flag.frame.height + 10)
                        }) { (_) in
                            if dataManager.verificationLevel == 0 && random(2) == 1 {
                                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                                    flag.frame = CGRect(x: 0, y: 0, width: flag.frame.width - 10, height: flag.frame.height - 10)
                                }, completion: nil)
                                
                            } else if self.isCaseABomb(i: squareCase.i, j: squareCase.j) {
                                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                                    flag.frame = CGRect(x: 0, y: 0, width: flag.frame.width - 10, height: flag.frame.height - 10)
                                }, completion: { (_) in
                                    flag.removeFromSuperview()
                                    flag.color = colorForRGB(r: 60, g: 160, b: 100)
                                    flag.tag = 1
                                    squareCase.addSubview(flag)
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
    
}

// MARK: - Gère les timers
extension ViewOfGameSquare: CountingTimerProtocol {
    func timerFires(id: String) {
        if id == "Option3" {
            
            for subview in subviews {
                if subview is SquareCase {
                    let square = subview as! SquareCase
                    if square.caseState == .blocked && random(100) < Int(100-option3Frequency*100)  {
                        square.caseState = .empty
                        square.isUserInteractionEnabled = true
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
                guard let square = subview as? SquareCase else { continue }
                square.option1Timer.pause()
            }
        }
    }
    
    func unPauseAllOption1Timers() {
        if option1 {
            for subview in subviews {
                guard let square = subview as? SquareCase else { continue }
                square.option1Timer.play()
            }
        }
    }
}
*/
