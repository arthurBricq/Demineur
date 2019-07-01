//
//  ScoreViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit
import CoreData
import GameKit


class ScoreViewController: UIViewController, GKGameCenterControllerDelegate {
    

    // MARK: - Outlets
    
    @IBOutlet weak var text1label: UILabel!
    @IBOutlet weak var number1label: UILabel!
    @IBOutlet weak var text2label: UILabel!
    @IBOutlet weak var numbe2label: UILabel!
    @IBOutlet weak var lineView: LineView!
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - Variables
    
    var gcEnabled = Bool() // Check if the user has Game Center enabled
    var gcDefaultLeaderBoard = String() // Check the default leaderboardID
    
    // MARK: - Constants
    
    static let LEVEL_LEADERBOARD_ID = "com.score.minehunter"
    
    // MARK: - Actions
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gameCenterButtonTapped(_ sender: Any) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = ScoreViewController.LEVEL_LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Verify that the itunes account is available
        authenticateLocalPlayer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLabels()
    }
    
    private func getAllLocalScores() -> [LocalScore] {
        // Get all the local scores
        let request: NSFetchRequest<LocalScore> = LocalScore.fetchRequest()
        do {
            let allScores = try AppDelegate.viewContext.fetch(request)
            return allScores
        } catch {
            print("ERROR: fetching the local scores from the database")
            return []
        }
    }
    
    private func updateLabels() {
        let scores = getAllLocalScores()
        print("Number of scores : \(scores.count)")
        
        if scores.count == 0 {
            text1label.text = "Pas de niveau."
            number1label.text = ""
            text2label.text = ""
            numbe2label.text = ""
            return
        }
        
        if let maxLevel = (scores.max { (score1, score2) -> Bool in
            return score1.level > score2.level
        })?.level {
            text1label.text = "Plus grand niveau atteint durant une partie:"
            number1label.text = "\(maxLevel)"
        }
        
        if let biggestNumberOfBombs = (scores.max { (score1, score2) -> Bool in
            return score1.numberOfBombs > score2.numberOfBombs
        })?.numberOfBombs {
            text2label.text = "Plus grand nombre de bombes désamorcées"
            numbe2label.text = "\(biggestNumberOfBombs)"
        }
        
        
        
        
    }
    
    // MARK: - Functions for game center

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true , completion: nil)
    }
    
    /// This function connects the player to game center if it is not already the case
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(vc, error) -> Void in
            if((vc) != nil) {
                // 1. Show login if player is not logged in
                self.present(vc!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error!)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }
    
    // TODO: - create the function to add new scores once the application is released
    // TODO: - create a leaderboard for the application, once the application is released
    
    
}
