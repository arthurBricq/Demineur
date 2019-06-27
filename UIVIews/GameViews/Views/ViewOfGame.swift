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
    var delegate: GameController?
    /// Holds the position of bombs and the numbers displayed when cases are opened.
    /// Keeps in mind that this array is only modified when one game is created.
    var gameState: [[Int]] = [[Int]].init()
    /// Holds all the cases present on screen.
    var cases: [[Case]] = [[Case]].init()
    /// Holds the number of remaining flags.
    var numberOfRemainingFlags: Int = 5 {
        didSet {delegate?.updateFlagsDisplay(numberOfFlags: numberOfRemainingFlags)}
    }
    /// Permet de compter le nombre total de drapeaux correct que le joueur a posé. Cette closure va rajouter +1 à la variable 'numberOfBombs' du VC si on marque un drapeau au bon endroit.
    var onPosingFlag: ((Bool) -> Void)?
    /// Permet de compter le nombre total de drapeaux correct que le joueur a posé. Cette closure va enlever -1 à la variable 'numberOfBombs' du VC si on enlève un drapeau correct.
    var onUnposingFlag: ((Bool) -> Void)?
    /// This variable is only used to restaure the game at the correct state, if we start from a game that was already existing. 
    var allCaseStates: [[CaseState]]?
    
    var option3Timer = CountingTimer()
    
    
    // MARK: - Inits functions
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    required init(coder aDecoder: NSCoder) { fatalError("This class does not support NSCoding") }
    
    /// This init asks for frame, which implies a constraint dimension of the viewOfGame (infinite game). In this case, the VC is in charge of positionnning the view.
    convenience init(frame: CGRect, game: OneGame, gameState: inout [[Int]]) {
        self.init(frame: frame)
        self.game = game
        self.gameState = gameState
        instantiateCases()
    }
    
    /// This init don't ask for a frame, which means that the frame is calculated based on unit dimension of the case. After calling this init, the viewOfGame is already positienned at the right position for the scroll view where it belongs.
    convenience init(game: OneGame, gameState: inout [[Int]]) {
        self.init()
        self.game = game
        self.gameState = gameState
        self.frame = CGRect(origin: CGPoint.zero, size: dimension)
        instantiateCases()
    }
    
    /// This init must be call when we want to restaure a game. It needs more information about the states of cases.
    convenience init(restauredGame game: OneGame, gameState: inout [[Int]], allCaseStates: [[CaseState]], scrollViewDimension: CGSize) {
        self.init()
        self.game = game
        self.gameState = gameState
        self.allCaseStates = allCaseStates
        self.frame = CGRect(origin: CGPoint.zero, size: dimension)
        instantiateCases(isRestauringGame: true)
    }
    
    
    // MARK: - computed properties for the automatic sizing process
    
    /// Is the dimension of the viewOfGame, when n and m are set, calculated using the unit dimension of the case. It is function of n,m and of a.
    /// - In the infinite mode, this propert is irrelevant since we calculate the dimension to fit the screen size.
    /// - But in the history mode and in the superParties mode, the game can be as big as you want.
    var dimension: CGSize {
        fatalError("Needs to be overiden by each subclass")
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
            for j in 0..<gameState[i].count {
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
        return cases[i][j].caseState == .marked || cases[i][j].caseState == .markedByComputer
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
    /// If the parameter 'isRestauringGame' is passed as true, then the function will look for the correct information to be passed in the cases
    func instantiateCases(isRestauringGame: Bool = false) {
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
        if numberOfRemainingFlags <= 0 { return }
        numberOfRemainingFlags = numberOfRemainingFlags - 1
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
            switch cas {
            case 1:
                let m = gameState[i].count
                for j in 0..<m {
                    if !isTheCaseMarked(i: i, j: j) {
                        if isCaseABomb(i: i, j: j) {
                            markACaseAt(i: i, j: j, byComputer: true)
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
                            markACaseAt(i: n-i-1, j: m-j-1, byComputer: true)
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
        for line in cases {
            for c in line {
                // c is the case
                if c.caseState == .marked || c.caseState == .markedByComputer {
                    for subview in c.subviews {
                        guard let flag = subview as? FlagView else { continue }
                        if flag.tag != 1 {
                            UIView.animate(withDuration: 0.2, animations: {
                                flag.frame = CGRect(x: -5, y: -5, width: flag.frame.width + 10, height: flag.frame.height + 10)
                            }) { (_) in
                                if dataManager.verificationLevel == 0 && random(2) == 1 {
                                    UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                                        flag.frame = CGRect(x: 0, y: 0, width: flag.frame.width - 10, height: flag.frame.height - 10)
                                    }, completion: nil)
                                } else if self.isCaseABomb(i: c.i, j: c.j) {
                                    UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                                        flag.frame = CGRect(x: 0, y: 0, width: flag.frame.width - 10, height: flag.frame.height - 10)
                                    }, completion: { (_) in
                                        flag.removeFromSuperview()
                                        flag.color = colorForRGB(r: 60, g: 160, b: 100)
                                        flag.tag = 1
                                        c.addSubview(flag)
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
}


// MARK: - Timer extension
extension ViewOfGame: CountingTimerProtocol {
    func timerFires(id: String) {
        if id == "Option3" {
            for line in cases {
                for c in line {
                    // Do option 3
                    if c.caseState == .blocked && random(100) < Int(100-game!.option3Frequency*100)  {
                        c.caseState = .empty
                        c.isUserInteractionEnabled = true
                    }
                }
            }

            if random(100) < Int(game!.option3Frequency*100) {
                let randN = random(game!.n)
                var numberOfColumn: Int = game!.m
                if game?.gameType == .hexagonal {
                    if game!.n%2 == 1 {
                        numberOfColumn = game!.m - 1
                    }
                }
                let randM = random(numberOfColumn)
                blockACaseAt(i: randN, j: randM)
            }
            
        }
    }
    
    func pauseAllOption1Timers() {
        if game!.option1 {
            cases.forEach { (line) in
                line.forEach({ (c) in
                    c.option1Timer.pause()
                })
            }
        }
    }
    
    func unPauseAllOption1Timers() {
        if game!.option1 {
            cases.forEach { (line) in
                line.forEach({ (c) in
                    c.option1Timer.play()
                })
            }
        }
    }
}

