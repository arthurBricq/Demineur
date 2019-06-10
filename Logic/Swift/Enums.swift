//
//  Enums.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

enum GameType: Int32 {
    case square = 0
    case hexagonal = 1
    case triangular = 2 
}


enum CaseState: Int32 {
    case empty = 0 // quand il ne s'est rien passé
    case open = 1 // quand le joueur a ouvert la case
    case marked = 2 // quand le joueur a pose un drapeau
    case markedByComputer = 3 // quand l'ordinateur a pose un drapeau
    case none = 4 // quand il n'y a pas de cases
    case blocked = 5 // quand la case est temporairemetn bloque
}

/// Describe the 3 states that a cell of the type 'HistoryPresentationCell' (used to display the levels of history game) can have. Their drawing will depend on this state only
enum PresentationCellState {
    case notReachedYet
    case completed
    case reached
    case firstRow
}
