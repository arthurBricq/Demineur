//
//  ViewOfGame_Hex.swift
//  HexagoneViewMineIt
//
//  Created by Arthur BRICQ on 31/03/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class ViewOfGame_Hex: UIView {
    
    // MARK: - Variables sur le jeu en cours
    @IBInspectable var n: Int = 4
    @IBInspectable var m: Int = 4
    var z: Int = 4
    @IBInspectable var a: CGFloat = 30
    @IBInspectable var emptyColor: UIColor = .black
    @IBInspectable var openColor: UIColor = .black
    @IBInspectable var strokeColor: UIColor = .black
    var textColor = UIColor.black
    @IBInspectable var lineWidth: CGFloat = 1.5
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
    
    
    override func draw(_ rect: CGRect) {
        // hypothesis : 1) w = k * h    2) what matters is the height since h = 2*a
        // k = sqrt(3)/2
        // Conclustions: 1 w = k * h = 2 * a * k = sqrt(3) * a  and   2)   h = 2 * a
        
        // pour toutes les cases :
        let h = 2*a // la hauteur
        let w = k*h // la largeur
        let size = CGSize(width: w, height: h)
        
        // point itérateur pour positionner tous les boutons
        var iteratorPoint: CGPoint = .zero
        
        // ***** Dessin des cases ***** //
        
        for i in 0..<n {
            for j in 0..<gameState[i].count {
                
                let hexButton = HexCase()
                hexButton.i = i // coordonné de la ligne
                hexButton.j = j // coordonée de la colonne
                
                if gameState[i][j] == -2 {
                    hexButton.caseState = .none
                } else {
                    hexButton.caseState = .empty
                }
                
                if i%2 == 0 {
                    iteratorPoint.x = CGFloat(j) * sqrt(3) * a
                    iteratorPoint.y = CGFloat(i) * (3*a/2)
                } else {
                    iteratorPoint.x = w/2 + CGFloat(j) * sqrt(3) * a
                    iteratorPoint.y = CGFloat(i) * (3*a/2) // le y ne change pas par rapport au premier point
                }
                
                hexButton.frame = CGRect(origin: iteratorPoint, size: size)
                self.addSubview(hexButton)
                
            }
        }
        
        
    }
    
}

// MARK: - Fonction qui gère l'ouverture des cases
extension ViewOfGame_Hex: ButtonCanCallSuperView {
    
    /**
     Cette fonction permet d'ouvrir toutes les cases les unes après les autres.
     */
    func buttonHaveBeenTapped(i: Int, j: Int, marking: Bool)
    {
        if isACaseNone(i: i, j: j) { return }
        
        func ouvertureRecursive(i: Int, j: Int) {
            
            let minIJ = 0 ; let maxI = gameState.count ;
            if i >= minIJ && j >= minIJ && i < maxI
            { // pas une case en dehors du domaine.
                let maxJ = gameState[i].count ;
                if j < maxJ // Début de la logique ici ...
                {
                    
                    if isTheCaseBlocked(i: i, j: j) { return }
                    
                    if gameState[i][j] == -1 { // ******* fin du jeu ****** //
                        
                        delegate!.gameOver(win: false, didTapABomb: true, didTimeEnd: false)
                        callEndAnimation(onButtonAt: i, j: j, win: false, bombTapped: true)
                        return
                        
                    } else if gameState[i][j] == -2 {
                        return
                    } else if !isTheCaseMarked(i: i, j: j) && !isACaseOpen(i: i, j: j) { // pas une bombe, pas une none
                        returnACase(i: i, j: j)
                        if gameState[i][j] != 0 { return }
                        for a in (i-1)...(i+1) {
                            for b in (j-1)...(j+1) {
                                // il y a deux cas : ou bien i est paire ou bien i est impaire
                                if i%2 == 0 { // il y m elements dans la ligne.
                                    if a != i && b == (j+1) { continue }
                                } else {
                                    if b == (j-1) && a != i { continue }
                                }
                                
                                ouvertureRecursive(i: a, j: b)
                            }
                        }
                    }
                }
                
            }
        }
        
        if marking { // il faut marquer ou unmarquer la case
            
            if isACaseOpen(i: i, j: j) { return }
            
            if !isTheCaseMarked(i: i, j: j) {
                self.onPosingFlag?(isCaseABomb(i: i, j: j))
                markACase(i: i, j: j)
            } else {
                self.onUnposingFlag?(isCaseABomb(i: i, j: j))
                unmarkACase(i: i, j: j)
            }
                        
        } else { // appuyer sur la carte
            if !isTheCaseMarked(i: i, j: j) {
                ouvertureRecursive(i: i, j: j)
            }
        }
        
        if isTheGameFinished() {
            // ******** Partie Gagnée ********* //
            delegate!.gameOver(win: true, didTapABomb: false, didTimeEnd: false)
            returnAllTheCases(win: true)
        }
        
        
    }
}

// MARK: - Fonctions pour obtenir des infos sur la partie
extension ViewOfGame_Hex {
    
    func isTheCaseMarked(i: Int,j : Int)->Bool {
        var toReturn: Bool = false
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let k = i*m + j - delta
        if self.subviews[k] is HexCase {
            let button = self.subviews[k] as! HexCase
            if button.caseState == .marked || button.caseState == .markedByComputer {
                toReturn = true
            }
        }
        return toReturn
    }
    
    func isTheCaseBlocked(i: Int,j : Int)->Bool {
        var toReturn: Bool = false
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let k = i*m + j - delta
        if self.subviews[k] is HexCase {
            let button = self.subviews[k] as! HexCase
            if button.caseState == .blocked {
                toReturn = true
            }
        }
        return toReturn
    }
    
    func isACaseOpen(i: Int,j : Int)->Bool {
        var toReturn: Bool = false
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let k = i*m + j - delta
        if self.subviews[k] is HexCase {
            let button = self.subviews[k] as! HexCase
            if button.caseState == .open {
                toReturn = true
            }
        }
        return toReturn
    }
    
    func isACaseNone(i: Int,j : Int)->Bool {
        var toReturn: Bool = false
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let k = i*m + j - delta
        if self.subviews[k] is HexCase {
            let button = self.subviews[k] as! HexCase
            if button.caseState == .none {
                toReturn = true
            }
        }
        return toReturn
    }
    
    func isCaseABomb(i: Int, j: Int) -> Bool {
        return gameState[i][j] == -1
    }
}

// MARK: - Fonctions pour agir sur la partie
extension ViewOfGame_Hex {
    func markACase(i: Int,j: Int, byComputer: Bool = false) {
        
        if numberOfFlags > 0 {
            numberOfFlags = numberOfFlags - 1
        } else {
            return
        }
        
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let k = i*m + j - delta
        if self.subviews[k] is HexCase {
            let button = self.subviews[k] as! HexCase
            
            if byComputer {
                button.caseState = .markedByComputer
            } else {
                button.caseState = .marked
            }
        }
    }
    
    func unmarkACase(i: Int,j: Int) {
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let k = i*m + j - delta
        if self.subviews[k] is HexCase {
            let button = self.subviews[k] as! HexCase
            button.caseState = .empty
        }
    }
    
    func blockACase(i: Int,j: Int) {
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let k = i*m + j - delta
        if self.subviews[k] is HexCase {
            let button = self.subviews[k] as! HexCase
            if button.caseState == .empty {
                button.caseState = .blocked
                button.isUserInteractionEnabled = false
            }
        }
    }
    
    func unblockACase(i: Int,j: Int) {
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let k = i*m + j - delta
        if self.subviews[k] is HexCase {
            let button = self.subviews[k] as! HexCase
            button.caseState = .empty
            button.isUserInteractionEnabled = true
        }
    }
    
    func returnACase(i: Int, j: Int) {
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let k = i*m + j - delta
        if self.subviews[k] is HexCase {
            let button = self.subviews[k] as! HexCase
            button.caseState = .open
        }
    }
    
    func isTheGameFinished() -> Bool {
        var toReturn = true
        
        for i in 0..<gameState.count {
            for j in 0..<gameState[i].count {
                // We check if all bombs are marked
                if gameState[i][j] == -1 {
                    if !isTheCaseMarked(i: i, j: j) {
                        toReturn = false
                    }
                }
                
            }
        }
        
        // Si la partie est finie, il faut aussi bloquer les animations en cours sur les cases: par exemple arreter le timer de l'option 1
        
        if toReturn { // la partie est donc finie !
            for button in self.subviews {
                if button is HexCase {
                    let button = button as! HexCase
                    button.option1Timer.stop()
                }
            }
        }
        
        return toReturn
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
        let delta: Int = (i%2==0) ? i/2 : (i-1)/2
        let buttonTappedId = i*m + j - delta
        if self.subviews[buttonTappedId] is HexCase {
            let buttonTapped = self.subviews[buttonTappedId] as! HexCase
            buttonTapped.animateGameOver(win: win, bombTapped: bombTapped)
        }
    }
    
    func updateAllNumbers() {
        for button in self.subviews {
            if button is HexCase {
                let button = button as! HexCase
                // button.gameState = gameState
            }
        }
    }
    
    
    func markARandomBomb() {
        // une chance sur deux de partir du haut
        let cas = random(2) + 1
        
        let n = gameState.count
        for i in 0..<n {
            
            switch cas {
            case 1:
                
                let m = gameState[i].count
                
                for j in 0..<m {
                    if isCaseABomb(i: i, j: j) {
                        if !isTheCaseMarked(i: i, j: j) {
                            
                            markACase(i: i, j: j, byComputer: true)
                            
                            if isTheGameFinished() { // end of game
                                delegate!.gameOver(win: true, didTapABomb: false, didTimeEnd: false)
                                returnAllTheCases(win: true)
                            }
                            
                            
                            return
                            
                        }
                    }
                }
            case 2:
                let m = gameState[n-i-1].count
                
                for j in 0..<m {
                    if isCaseABomb(i: n-i-1, j: m-j-1) {
                        if !isTheCaseMarked(i: n-i-1, j: m-j-1) {
                            
                            markACase(i: n-i-1, j: m-j-1, byComputer: true)
                            
                            if isTheGameFinished() { // end of game
                                delegate!.gameOver(win: true, didTapABomb: false, didTimeEnd: false)
                                returnAllTheCases(win: true)
                            }
                            
                            return
                            
                        }
                    }
                }
            default:
                break
            }
            
        }
        
    }
    
    func verificationBonusFunc() {
        for subview in subviews {
            
            guard let hexCase = subview as? HexCase else { continue }
            
            if hexCase.caseState == .marked || hexCase.caseState == .markedByComputer {
                
                for subview2 in hexCase.subviews {
                    guard let flag = subview2 as? FlagView else { continue }
                    if flag.tag != 1 {
                        UIView.animate(withDuration: 0.2, animations: {
                            flag.frame = CGRect(x: -5, y: -5, width: flag.frame.width + 10, height: flag.frame.height + 10)
                        }) { (_) in
                            if dataManager.verificationLevel == 0 && random(2) == 1 {
                                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                                    flag.frame = CGRect(x: 0, y: 0, width: flag.frame.width - 10, height: flag.frame.height - 10)
                                }, completion: nil)
                                
                            } else if self.isCaseABomb(i: hexCase.i, j: hexCase.j) {
                                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                                    flag.frame = CGRect(x: 0, y: 0, width: flag.frame.width - 10, height: flag.frame.height - 10)
                                }, completion: { (_) in
                                    flag.removeFromSuperview()
                                    flag.color = colorForRGB(r: 60, g: 160, b: 100)
                                    flag.tag = 1
                                    hexCase.addSubview(flag)
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
extension ViewOfGame_Hex: CountingTimerProtocol {
    func timerFires(id: String) {
        if id == "Option3" {
            
            for subview in subviews {
                if subview is HexCase {
                    let hex = subview as! HexCase
                    if hex.caseState == .blocked && random(100) < Int(option3Frequency*100) {
                        hex.caseState = .empty
                        hex.isUserInteractionEnabled = true
                    }
                }
            }
            
            if random(100) < Int(option3Frequency*100) {
                let randN = random(n)
                let randM = n%2 == 0 ? random(m) : random(m-1)
                blockACase(i: randN, j: randM)
            }
            
        }
    }
    
    func pauseAllOption1Timers() {
        if option1 {
            for subview in subviews {
                guard let hex = subview as? HexCase else { continue }
                hex.option1Timer.pause()
            }
        }
    }
    
    func unPauseAllOption1Timers() {
        if option1 {
            for subview in subviews {
                guard let hex = subview as? HexCase else { continue }
                hex.option1Timer.play()
            }
        }
    }
}
