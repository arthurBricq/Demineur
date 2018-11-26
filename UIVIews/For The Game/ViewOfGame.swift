//
//  ViewOfGame.swift
//  Demineur
//
//  Created by Arthur BRICQ on 25/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/// This class is responsible to handle a game, of any type and for any mode of party.
/// In practise, you never get to instantiate an element of this class (use child of the class) because we don't provide implementation of the draw methods here.
/// Methods to be overriden: instantiateCases, ouvertureRecursive

class ViewOfGame: UIView {
    
    // MARK: - Variables
    
    var game: OneGame?
    var delegate: GameViewCanCallVC?
    /// Holds the position of bombs and the numbers displayed when cases are opened.
    /// Keeps in mind that this array is only modified when one game is created.
    var gameState: [[Int]] = [[]]
    /// Holds all the cases present on screen.
    var cases: [[Case]] = [[]]
    /// Holds the number of remaining flags.
    var numberOfFlags: Int = 5 {
        didSet {delegate?.updateFlagsDisplay(numberOfFlags: numberOfFlags)}
    }
    /// Permet de compter le nombre total de drapeaux correct que le joueur a posé. Cette closure va rajouter +1 à la variable 'numberOfBombs' du VC si on marque un drapeau au bon endroit.
    var onPosingFlag: ((Bool) -> Void)?
    /// Permet de compter le nombre total de drapeaux correct que le joueur a posé. Cette closure va enlever -1 à la variable 'numberOfBombs' du VC si on enlève un drapeau correct.
    var onUnposingFlag: ((Bool) -> Void)?
    
    // MARK: - Inits functions
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    required init(coder aDecoder: NSCoder) { fatalError("This class does not support NSCoding") }
 
    convenience init(frame: CGRect, game: OneGame) {
        self.init(frame: frame)
        self.game = game
        instantiateCases()
    }
    
    // MARK: - Functions
    
    /// This is method is called by cases when user taps on them
    public func buttonHaveBeenTapped(i: Int, j: Int, marking: Bool) { // this function has all the logic whenever a button is tapped.
        
        if isCaseNone(i: i, j: j) || isTheCaseOpen(i: i, j: j) || isCaseBlocked(i: i, j: j) {
            return
            
        }
        
        if marking { // hold tapping --> have to mark or unmark the card
            if !isTheCaseMarked(i: i, j: j) {
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
    
    private func isTheGameFinished() -> Bool {
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
        return cases[i][j].caseState == .marked
    }
    
    func isTheCaseOpen(i: Int, j: Int) -> Bool {
        return cases[i][j].caseState == .open
    }
    
    func isCaseNone(i: Int, j: Int) -> Bool {
        return cases[i][j].caseState == .none
    }
    
    func isCaseBlocked(i: Int, j: Int) -> Bool {
        return cases[i][j].caseState == .blocked
    }
    
    func isCaseABomb(i: Int, j: Int) -> Bool {
        return gameState[i][j] == -1
    }
    
    /// This method needs to be overriden by subclasses.
    /// It's supposed to dispose the cases in the right position (not on the draw function anymore)
    func instantiateCases() {
        fatalError("This method needs to be overriden by children")
    }
    
    func ouvertureRecursive(line i: Int, column j: Int) {
        fatalError("This method needs to be overriden by children")
    }
    
    /// This method return the case (opens the case)
    func returnACaseAt(i: Int, j: Int) {
        cases[i][j].caseState = .open
    }
    
    private func markACaseAt(i: Int, j: Int, byComputer: Bool = false) {
        if numberOfFlags <= 0 { return }
        numberOfFlags = numberOfFlags - 1
        cases[i][j].caseState = byComputer ? .markedByComputer : .marked
    }
    
    private func unmarkACaseAt(i: Int, j: Int) {
        cases[i][j].caseState = .empty
    }
    
    private func blockACaseAt(i: Int, j: Int) {
        if cases[i][j].caseState == .empty {
            cases[i][j].caseState = .blocked
        }
    }
    
    private func unblockACaseAt(i: Int, j: Int) {
        cases[i][j].caseState = .empty
    }
    
    /* I feel like this method is totally useless
    func updateAllNumbers() {
        for button in self.subviews {
            if button is SquareCase {
                let button = button as! SquareCase
                button.gameState = gameState
            }
        }
    }
    */
    
    private func returnAllTheCases(win: Bool = false) {
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
    
    private func callEndAnimation(onButtonAt i: Int, j: Int, win: Bool, bombTapped: Bool = false) {
        cases[i][j].animateGameOver(win: win, bombTapped: bombTapped)
    }
    
    
    /**
     Cette fonction est appelé pour le bonus 'bombe' afin de retourner une bombe aléatoire
     */
    public func markARandomBomb() {
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
    
}
