//
//  Enums.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

enum GameType: Int {
    case square = 0
    case hexagonal = 1
    case triangular = 2 
}


enum CaseState {
    case empty // quand il ne s'est rien passé
    case open // quand le joueur a ouvert la case
    case marked // quand le joueur a pose un drapeau
    case markedByComputer // quand l'ordinateur a pose un drapeau
    case none // quand il n'y a pas de cases
    case blocked // quand la case est temporairemetn bloque
}
