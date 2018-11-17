//
//  UserDefaultsManager.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/**
 The purpose of this class is to save all the value that needs to be saved in the user defaults
 
 Defaults values:
 - for Int: 0
 */

class UserDefaultsManager {
    
    fileprivate let defaults = UserDefaults.standard
    
    
    var money: Int {
        get {  return defaults.integer(forKey: "money")}
        set { defaults.set(newValue, forKey: "money") }
    }
    
    // MARK : - Quantity of bonus
    
    var vieQuantity: Int {
        get { return defaults.integer(forKey: "vieQuantity") }
        set { defaults.set(newValue, forKey: "vieQuantity") }
    }
    
    var bombeQuantity: Int {
        get { return defaults.integer(forKey: "bombeQuantity") }
        set { defaults.set(newValue, forKey: "bombeQuantity") }
    }
    
    var drapeauQuantity: Int {
        get { return defaults.integer(forKey: "drapeauQuantity") }
        set { defaults.set(newValue, forKey: "drapeauQuantity") }
    }
    
    var verificationQuantity: Int {
        get { return defaults.integer(forKey: "verificationQuantity")}
        set { defaults.set(newValue, forKey: "verificationQuantity") }
    }
    
    var tempsQuantity: Int {
        get { return defaults.integer(forKey: "tempsQuantity")}
        set { defaults.set(newValue, forKey: "tempsQuantity") }
    }
    
    // MARK: - Level of bonus
    
    var vieLevel: Int {
        get { return defaults.integer(forKey: "vieLevel") }
        set { defaults.set(newValue, forKey: "vieLevel") }
    }
    
    var bombeLevel: Int {
        get { return defaults.integer(forKey: "bombeLevel") }
        set { defaults.set(newValue, forKey: "bombeLevel") }
    }
    
    var drapeauLevel: Int {
        get { return defaults.integer(forKey: "drapeauLevel") }
        set { defaults.set(newValue, forKey: "drapeauLevel") }
    }
    
    var verificationLevel: Int {
        get { return defaults.integer(forKey: "verificationLevel")}
        set { defaults.set(newValue, forKey: "verificationLevel") }
    }
    
    var tempsLevel: Int {
        get { return defaults.integer(forKey: "tempsLevel")}
        set { defaults.set(newValue, forKey: "tempsLevel") }
    }
    
    // MARK: - Settings of the game
    
    var isMusicOn: Bool {
        get { return defaults.bool(forKey: "isMusicOn") }
        set { defaults.set(newValue, forKey: "isMusicOn") }
    }
    
    var isVibrationOn: Bool {
        get { return defaults.bool(forKey: "isVibrationOn") }
        set { defaults.set(newValue, forKey: "isVibrationOn") }
    }
    
    var areEffectsOn: Bool {
        get { return defaults.bool(forKey: "areEffectsOn") }
        set { defaults.set(newValue, forKey: "areEffectsOn") }
    }
    
    // MARK: - memories of current game state
    
    var indexOfSelectedBonusInPauseVC: Int {
        get { return defaults.integer(forKey: "indexOfSelectedBonusInPauseVC")}
        set { defaults.set(newValue, forKey: "indexOfSelectedBonusInPauseVC") }
    }
    
    var currentTheme: Int {
        get { return defaults.integer(forKey: "currentTheme") }
        set { defaults.set(newValue, forKey: "currentTheme") }
    }
    
    var languageIterator: Int {
        get { return defaults.integer(forKey: "languageIterator")}
        set { defaults.set(newValue, forKey: "languageIterator") }
    }
    
    var timeToMantainIterator: Int {
        get { return defaults.integer(forKey: "timeToMantainIterator") }
        set { defaults.set(newValue, forKey: "timeToMantainIterator") }
    }
    
    var unlockedThemes: [Int] {
        get { return (defaults.object(forKey: "unlockedThemes") as? [Int]) ?? [] }
        set {defaults.set(newValue, forKey: "unlockedThemes")}
    }
    
    
    
    // MARK: - Functions
    
    init() { }
    
}

