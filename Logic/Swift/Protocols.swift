//
//  Protocols.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 12/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit



// ***** PROTOCOLS ***** //
protocol ButtonCanCallSuperView {
    func buttonHaveBeenTapped(i: Int, j: Int, marking: Bool)
}
protocol GameController {
    func gameOver(win: Bool, didTapABomb: Bool, didTimeEnd: Bool) 
    func updateFlagsDisplay(numberOfFlags: Int)
    
}

protocol CountingTimerProtocol {
    func timerFires(id: String)
}
protocol LimitedTimerProtocol {
    func timeLimitReached(id: String)
}

/// Permet à la variable 'isTheGameStarted' (variable globale) de créer une partie après qu'une case ait été tapée.
protocol variableCanCallGameVC {
    func createTheGame(withFirstTouched: (x: Int, y: Int))
}
/*
protocol RoundButtonsCanCallVC {
    func buttonTapped(withIndex: Int)
} */
protocol BonusButtonsCanCallVC {
    func tempsTapped()
    func drapeauTapped()
    func bombeTapped()
    func vieTapped()
    func verificationTapped()
}

protocol CellCanCallTableViewController {
    func reloadDatas()
    func reloadMoney()
}
