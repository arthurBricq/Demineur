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
    func setGame(n:Int,m:Int,z:Int) {
        self.n = Int32(n)
        self.m = Int32(m)
        self.z = Int32(z)
    }
    
    
    /*
    // EFFECTS: will return an array of [(x:Int,y:Int)], so the sub arrays will have a size of 2
    func getPositionOfBoms() -> [[Int]] {
        return []
    }*/
}
