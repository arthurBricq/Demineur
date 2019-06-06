//
//  SuperPartieGame.swift
//  Demineur
//
//  Created by Arthur BRICQ on 05/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit
import CoreData

/**
 This class is the representation of one game onto CD. It is used to restaure the game exactly at the same state as it was when the user left it last time.
 */
class SuperPartieGame: NSManagedObject {
    public func setUpGame(viewOfGame: ViewOfGame, level: Int ) {
        self.level = Int32(level)
        
        // 1. Save the informations about the map
        if let game = viewOfGame.game {
            self.n = Int32(game.n)
            self.m = Int32(game.m)
            self.z = Int32(game.z)
            self.gameType = game.gameType.rawValue
        }
        
        // TODO: save the non-cases of the application (it might be done by the gamestate ? IDK... But I think it's fine, I'll need to double-check)
        
        // 2. Save all the cases (position, state & gameState)
        for row in viewOfGame.cases {
            for cell in row {
                let savedCase = SavedCase(context: AppDelegate.viewContext)
                savedCase.setUp(case: cell)
                self.addToCases(savedCase)
            }
        }

    }
    
}
