//
//  MessageManagor.swift
//  Demineur
//
//  Created by Arthur BRICQ on 27/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/// This class is in charge of presenting the message on the screen when the user taps on a bomb. There are two messages: first asking if the user wants to use a life, or if the user wants to buy a life, and then finish the game
class MessageManagor {
    
    var viewOfGame: ViewOfGame
    var superView: UIView
    var functionToFinishGame: ()->Void
    
    init(viewOfGame: ViewOfGame,superView: UIView, functionToFinishGame: ()->Void ) {
        self.viewOfGame = viewOfGame
        self.superView = superView
        self.functionToFinishGame = functionToFinishGame
    }
    
}
