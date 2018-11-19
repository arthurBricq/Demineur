//
//  IsTheGameStarted.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/// Cette classe permet d'initier les parties. Il y a une variable globale de communication, qui possède un appel de fonction via une delegation.
class IsTheGameStarted {
    var value: Bool = false
    
    var delegate: variableCanCallGameVC?
    
    init(value: Bool) {
        self.value = value
        self.delegate = nil
    }
}
