//
//  SuperPartieGame.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit
import CoreData

class SuperPartieGame: NSManagedObject {
    
    /// This function has a role similar to a init, just need to be called after the real init
    func setGame(n:Int,m:Int,z:Int,gameType: GameType) {
        self.n = Int32(n)
        self.m = Int32(m)
        self.z = Int32(z)
        self.gameType = Int32(gameType.rawValue)
    }
    
    public func describeGame() {
        print("\nDescription of game")
        print("  - Dimension: \(n),\(m)")
        print("  - Number of bombs: \(z)")
        print("  - Number of flags put: \(positionOfFlags?.count ?? 0)")
    }
    
}
