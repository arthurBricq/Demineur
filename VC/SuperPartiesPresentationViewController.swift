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
    var currentLevelReached: (square: Int, hex: Int, triangle: Int) = (1,0,0)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SuperPartiesGameViewController {
            let dest = segue.destination as! SuperPartiesGameViewController
            if let selectedGame = sender as! (level: Int, gameType: GameType)? {
                // 1. Pass the level index
                dest.gameIndex = selectedGame.level
                
                // 2. Check if there is an existing game at this index, and if so pass it
                if isGameAlreadyStarted(level: selectedGame.level, gameType: selectedGame.gameType) {
                    print("There is a game saved for this level")
                    if let savedGame = getSavedGame(level: selectedGame.level, gameType: selectedGame.gameType) {
                        // TODO: pass the information needed to recover the game
                        print("b")
                        dest.savedGame = savedGame
                        return
                    }
                } else {
                    print("Creating a new game for this level")
                    dest.game = getNewGame(level: selectedGame.level, gameType: selectedGame.gameType)
                }
                
            }
            
        }
    }
    
    // Returns true if there is an existing game saved locally for this level
    private func isGameAlreadyStarted(level: Int, gameType: GameType) -> Bool {
        print("Is game started ? level: \(level) - gameType: \(gameType)")
        let request: NSFetchRequest<SuperPartieGame> = SuperPartieGame.fetchRequest()
        request.predicate = NSPredicate(format: "level == \(level) && gameType == \(gameType.rawValue)")
        do {
            let games = try AppDelegate.viewContext.fetch(request)
            print("Number of games matching predicates: \(games.count)")
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
        return OneGame(gameTypeWithNoOptionsWithoutNoneCases: gameType, n: 50, m: 30, z: 300, totalTime: 1000)
    }
    
    // MARK: - Functions for the scroll view settings
    
    private func setUpScrollView() {
        addFirstRowToScrollView()
        addAllOtherRowsToScrollView()
    }
    
    
    private func addFirstRowToScrollView() {
        let w = self.view.frame.width
        let row = UIView(frame: CGRect(x: 0, y: 0, width: w, height: heightOfFirstRow))
        let text = "SUPER PARTIES"
        let font = UIFont(name: "PingFangSC-Regular", size: 28)!
        let lblWidth: CGFloat = 400
        let h = text.height(withConstrainedWidth: lblWidth, font: font)
        let lbl = UILabel(frame: CGRect(x: 100, y: heightOfFirstRow/2 - h/2, width: lblWidth, height: h))
        lbl.text = text
        lbl.font = font
        lbl.textColor = UIColor.gray
        row.addSubview(lbl)
        scrollView.addSubview(row)
    }
    
    private func addAllOtherRowsToScrollView() {
        let maxLevel = max(currentLevelReached.square, currentLevelReached.hex, currentLevelReached.triangle)
        let numberOfRows = maxLevel + 10
        let w = self.view.frame.width
        var yPos: CGFloat = heightOfFirstRow
        for i in 0..<numberOfRows {
            let newRow = SuperPartiesPresentationCell(frame: CGRect(x: 0, y: yPos, width: w, height: heightOfRow))
            yPos += heightOfRow
            newRow.setCell(reachedLevels: currentLevelReached, cellLevel: i, closure: { (levelTapped: Int , gameTypeTapped: GameType) -> Void in
                self.performSegue(withIdentifier: "StartSuperPartieSegue", sender: (levelTapped, gameTypeTapped))
            })
            scrollView.addSubview(newRow)
        }
    }
}
