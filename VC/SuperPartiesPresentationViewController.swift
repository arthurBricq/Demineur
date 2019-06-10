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
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    override var prefersStatusBarHidden: Bool { return true }
    var currentLevelReached: (square: Int, hex: Int, triangle: Int) = (1,0,0)
//    var selectedGame: (level: Int, gameType: GameType)?
    
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
        tableView.reloadData()
        
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
        
        // Settings up the lines display
        line1.backgroundColor = colorForRGB(r: 66, g: 66, b: 66)
        line2.backgroundColor = colorForRGB(r: 66, g: 66, b: 66)
        line3.backgroundColor = colorForRGB(r: 66, g: 66, b: 66)
        line4.backgroundColor = colorForRGB(r: 66, g: 66, b: 66)
        
        // Settings of the tableView
        tableView.layer.zPosition = -1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false 
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
}

// MARK: - Gestion du tableView
extension SuperPartiesPresentationViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuperPartieCell", for: indexPath) as! SuperPartiesTableViewCell
        
        cell.squareButton.cornersToDraw = [1,2,3,4,5,6,7,8]
        cell.squareButton.openColor = .white
        cell.squareButton.strokeColor = .black
        cell.squareButton.ratio = 2
        
        cell.hexButton.openColor = .white
        cell.hexButton.strokeColor = .black
    
        cell.triangularButton.openColor = .white
        cell.triangularButton.strokeColor = .black
        
        cell.numberDisplay.color = UIColor(red: 0.720, green: 0.469, blue: 0.000, alpha: 1.000)
        cell.numberDisplay.text = String(100*indexPath.row + 100)
        
        cell.level = indexPath.row
        cell.currentLevelReached = currentLevelReached
        
        cell.isUserInteractionEnabled = true
        
        cell.updateTheAlphas()
        cell.updateTheLines()
        cell.setNeedsDisplay()
        
        cell.closureToStartGame = { (levelTapped: Int,gameTypeTapped: GameType) -> Void in
            self.performSegue(withIdentifier: "StartSuperPartieSegue", sender: (levelTapped, gameTypeTapped))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let maxLevel = max(currentLevelReached.square, currentLevelReached.hex, currentLevelReached.triangle)
        return maxLevel+2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
