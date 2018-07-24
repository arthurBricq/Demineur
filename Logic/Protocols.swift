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
protocol GameViewCanCallVC {
    func gameOver(win: Bool, didTapABomb: Bool)
    func updateFlagsDisplay(numberOfFlags: Int)
}
protocol CountingTimerProtocol {
    func timerFires(id: String)
}
protocol LimitedTimerProtocol {
    func timeLimitReached(id: String)
}
protocol variableCanCallGameVC {
    func createTheGame(withFirstTouched: (x: Int, y: Int))
}
protocol RoundButtonsCanCallVC {
    func buttonTapped(withIndex: Int)
}
protocol BonusButtonsCanCallVC {
    func tempsTapped()
    func drapeauTapped()
    func bombeTapped()
    func vieTapped()
    func verificationTapped()
}
