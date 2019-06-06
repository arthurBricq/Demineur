//
//  SavedCase.swift
//  Demineur
//
//  Created by Arthur BRICQ on 05/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit
import CoreData

/**
 This class is the representation of one case onto core data. Used to save the state of a super party game.
 */
class SavedCase: NSManagedObject {
    public func setUp(case c: Case) {
        // 1. Position of the cell
        self.i = Int32(c.i)
        self.j = Int32(c.j)
        // 2. State of the cell
        self.caseState = c.caseState.rawValue
        // 3. Game state value at this position
        self.gameStateValue = Int32(c.gameState[c.i][c.j])
    }
}
