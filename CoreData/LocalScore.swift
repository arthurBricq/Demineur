//
//  LocalScore.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit
import CoreData
import GameKit

class LocalScore: NSManagedObject {
    /// Try to publish on the game center this score
    public func publishScore() {
        if Reachability.isConnectedToNetwork() {
            let levelScore = GKScore(leaderboardIdentifier: ScoreViewController.LEVEL_LEADERBOARD_ID)
            levelScore.value = Int64(self.level)
            GKScore.report([levelScore]) { (error) in
                if let error = error {
                    print("There was an error publishing a level score to Game center: \(error)")
                } else {
                    print("Publition worked !!!")
                }
            }
        }
        
    }
}
