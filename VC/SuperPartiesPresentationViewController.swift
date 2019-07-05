//
//  SuperPartiesPresentationViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 03/09/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit
import CoreData

class SuperPartiesPresentationViewController: UIViewController {

    // MARK: - Outlets
 
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuButton: UIButton!
    
    // MARK: - Constants
    
    let heightOfFirstRow: CGFloat = 150
    let heightOfRow: CGFloat = 120
    
    // MARK: - Variables
    
    override var prefersStatusBarHidden: Bool { return true }
    var currentLevelReached: (square: Int, hex: Int, triangle: Int) = (2,1,1)
    var rows: [SuperPartiesPresentationCell] = []
    
    // MARK: - Actions
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Unwind segue to come back nicely
    @IBAction func unwindToSuperpartiesPresentation(segue: UIStoryboardSegue) {
        // retour aux niveaux
    }
    
    /// fonction appelée lorsque le unwind est fait
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
        return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController) {
            let fromView = fromViewController.view!
            let toView = toViewController.view!
            if let containerView = fromView.superview {
                toView.frame = fromView.frame
                toView.alpha = 0
                containerView.addSubview(toView)
                
                UIView.animate(withDuration: 1, animations: {
                    toView.alpha = 1
                }, completion: { (_) in
                    toView.removeFromSuperview()
                    self.dismiss(animated: false, completion: nil)
                })
            }
        }
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(menuButton)
        
        // Settings of the tableView
        setUpScrollView()
        
        setColors()
        
    }
    
    func setColors() {
        
        self.view.backgroundColor = Color.getColor(index: 0)
        menuButton.setTitleColor(Color.getColor(index: 2), for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SuperPartiesGameViewController {
            let dest = segue.destination as! SuperPartiesGameViewController
            dest.transitioningDelegate = self
            
            // Note: to understand the prepare, see the method 'addAllOtherRowsToScrollView()' which create the closure used by the buttons.
            // The sender passed in this segue can either be of type 'SuperPartieGame' or of type 'OneGame', depending wether or not a party already exist or not
            
            if let data = sender as? (existingGame: SuperPartieGame, level: Int) {
                // --> It means a party was already started.
                print("Lunching a game that already exist")
                dest.savedGame = data.existingGame
                dest.gameIndex = data.level
                return
            }
            
            if let data = sender as? (newGame: OneGame, level: Int) {
                // --> It means a new game needs to be created
                print("Creating a new game ")
                dest.game = data.newGame
                dest.gameIndex = data.level
            }
            
        } else if segue.destination is MenuViewController {
            segue.destination.transitioningDelegate = (segue.destination  as! MenuViewController)
        }
    }
    
    // Returns true if there is an existing game saved locally for this level
    private func isGameAlreadyStarted(level: Int, gameType: GameType) -> Bool {
        let request: NSFetchRequest<SuperPartieGame> = SuperPartieGame.fetchRequest()
        request.predicate = NSPredicate(format: "level == \(level) && gameType == \(gameType.rawValue)")
        do {
            let games = try AppDelegate.viewContext.fetch(request)
            print("Number of records: \(games.count)")
            if games.count > 1 {
                print("ERROR: there are to many games saved for one specific level. ")
            }
            return games.count > 0
        } catch {
            print("Error fecthing games from CD: \(error)")
            return false
        }
    }
    
    /// If there is a game saved at this level and for this gameType, then it will return it. Else, it will return nil.
    private func getSavedGame(level: Int, gameType: GameType) -> SuperPartieGame?  {
        let request: NSFetchRequest<SuperPartieGame> = SuperPartieGame.fetchRequest()
        request.predicate = NSPredicate(format: "level == \(level) && gameType == \(gameType.rawValue)")
        do {
            let games = try AppDelegate.viewContext.fetch(request)
            if games.count > 1 {
                print("ERROR: there are to many games saved for one specific level. ")
            }
            if let firstGame = games.first {
                return firstGame
            } else {
                print("ERROR: there are no games...")
                return nil
            }
        } catch {
            print("Error fecthing games from CD: \(error)")
            return nil
        }
    }
    
    /**
     There is a maximum m fixed by default
     square --> m = 30
     hex --> m = ?
     triangle --> m = ?
     
     Then, using a ratio which depends on the difficulty, we determine the value of n required to fit the game
     */
    private func getNewGame(level: Int, gameType: GameType) -> OneGame {
        // TODO: find the valid game
        return OneGame(gameTypeWithNoneCases: gameType, n: 30, m: 30, z: 300, numberOfFlag: 302, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
    }
    
    // MARK: - Functions for the scroll view settings
    
    private func setUpScrollView() {
        addFirstRowToScrollView()
        addAllOtherRowsToScrollView()
    }
    
    private func addFirstRowToScrollView() {
        let w = self.view.frame.width
        let row = SuperPartiesPresentationCell(frame: CGRect(x: 0, y: 0, width: w, height: heightOfFirstRow), level: 0, animationDelegate: self)
        let text = "SUPER PARTIES"
        let font = UIFont(name: "PingFangSC-Regular", size: 28)!
        let lblWidth: CGFloat = 400
        let h = text.height(withConstrainedWidth: lblWidth, font: font)
        let lbl = UILabel(frame: CGRect(x: 100, y: heightOfFirstRow/2 - h/2 - 50, width: lblWidth, height: h))
        lbl.text = text
        lbl.textColor = Color.getColor(index: 3)
        lbl.font = font
        row.addSubview(lbl)
        self.rows.append(row)
        scrollView.addSubview(row)
    }
    
    private func addAllOtherRowsToScrollView() {
        let maxLevel = max(currentLevelReached.square, currentLevelReached.hex, currentLevelReached.triangle)
        let numberOfRows = maxLevel + 10
        let w = self.view.frame.width
        var yPos: CGFloat = heightOfFirstRow
        for i in 0..<numberOfRows {
            let newRow = SuperPartiesPresentationCell(frame: CGRect(x: 0, y: yPos, width: w, height: heightOfRow), level: i+1, animationDelegate: self)
            yPos += heightOfRow
            newRow.setCell(reachedLevels: currentLevelReached, cellLevel: i, closure: { (levelTapped: Int , gameTypeTapped: GameType) -> Void in
                
                // Logic here about game gestion... It's quite a mess...
                print("Info : \(levelTapped) - \(gameTypeTapped)")
                if self.isGameAlreadyStarted(level: levelTapped, gameType: gameTypeTapped) {
                    self.displayRoundBox(title: "Game started", withMessage: "A game already exist. Do you want to continue ?", buttonNames: ["Yes", "No"], buttonActions: [
                        {
                            // So we pass as the sender the 'SuperPartieGame'
                            let game = self.getSavedGame(level: levelTapped, gameType: gameTypeTapped)
                            self.performSegue(withIdentifier: "StartSuperPartieSegue", sender: (game!,levelTapped))
                        }, {
                            print("no")
                            // Delete the previous game
                            if let gameToDelete = self.getSavedGame(level: levelTapped, gameType: gameTypeTapped) {
                                AppDelegate.viewContext.delete(gameToDelete)
                            }
                            
                            // So we pass as the sender the 'OneGame' obtained...
                            let game = self.getNewGame(level: levelTapped, gameType: gameTypeTapped)
                            self.performSegue(withIdentifier: "StartSuperPartieSegue", sender: (game,levelTapped))
        
                        }], backgroundColor: UIColor.red.withAlphaComponent(0.7))
                } else {
                    self.displayRoundBox(title: "New game", withMessage: "A new game is created for this level", buttonNames: ["Play"], buttonActions: [
                        {
                            // So we pass as the sender the 'OneGame' obtained...
                            let game = self.getNewGame(level: levelTapped, gameType: gameTypeTapped)
                            self.performSegue(withIdentifier: "StartSuperPartieSegue", sender: (game,levelTapped))
                        }], backgroundColor: UIColor.red.withAlphaComponent(0.7))
                    
                }
            

            })
        
                
                
            self.rows.append(newRow)
            scrollView.addSubview(newRow)
        }
    }
    
    // MARK: - Functions for the transitions
    
    /// Returns the x position of the last point of the line
    public func getLastXPositionForTransition() -> CGFloat {
        return view.frame.width * 0.75
    }
    
    public func getYPositionForTransition() -> CGFloat {
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        return (heightOfFirstRow/2 + 50 + (topPadding ?? 0))-1
    }
    
    /// This function must draw the first line, then draw all the lines cells by cell. 
    public func animateLines() {
        self.rows[0].drawFirstRow(heightOfFirstLine: self.heightOfFirstRow/2 + 50)
    }
    
    private func animateCells(index: Int) {
        if index < rows.count {
            self.rows[index].drawRow()
        }
        
    }
}


// MARK: - Functions for animation gestion of cells

extension SuperPartiesPresentationViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // 1. Obtain the data sent by the cells
        if let cellNumber = anim.value(forKey: "cellNumber") as? Int  {
            if let isFinished = anim.value(forKey: "isFinished") as? Bool {
                if !isFinished {
                    animateCells(index: cellNumber+1)
                }
            }
        }
    }
}

// MARK: - Animations for transition

extension SuperPartiesPresentationViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented is SuperPartiesGameViewController {
            let transition = TransitionToGameView()
            transition.animationDuration = 0.75
            return transition
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}


