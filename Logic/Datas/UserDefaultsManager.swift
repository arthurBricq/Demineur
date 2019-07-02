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

let dataManager = UserDefaultsManager()

class UserDefaultsManager {

    fileprivate let defaults = UserDefaults.standard
    
    // MARK: - Static properties for data model
    
    static let allTimesToMantain: [String] = ["Petit","Moyen","Long"]
    static let allLanguages: [String] = ["fr","en"]

    // MARK: - Values for the game 
    
    var money: Int {
        get {  return defaults.integer(forKey: "money")}
        set { defaults.set(newValue, forKey: "money") }
    }
    
    var currentHistoryLevel: Int {
        get {  return defaults.integer(forKey: "currentHistoryLevel")}
        set { defaults.set(newValue, forKey: "currentHistoryLevel") }
    }
    
    var currentSuperPartiesLevels: (square: Int, hex: Int, triangle: Int) {
        get {
            return (defaults.integer(forKey: "superPartiesSquareLevel"),
                    defaults.integer(forKey:"superPartiesHexLevel"),
                    defaults.integer(forKey: "superPartiesTriangleLevel")
            )
        } set {
            defaults.set(newValue.square, forKey: "superPartiesSquareLevel")
            defaults.set(newValue.hex, forKey: "superPartiesHexLevel")
            defaults.set(newValue.triangle, forKey: "superPartiesTriangleLevel")
        }
    }
    
    // MARK: - Quantity of bonus
    
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
        get { return (defaults.object(forKey: "unlockedThemes") as? [Int]) ?? [0] }
        set {defaults.set(newValue, forKey: "unlockedThemes")}
    }
    
    // MARK: - Functions
    
    init() { }
    
    /// Cette fonction est appelée si on souhaite ré-initialiser toutes les propriétés d'une partie correctement
    public func initiateANewDevice(argent: Int, lives: Int, level: Int) {
        // 1. Niveau du joueur
        currentHistoryLevel = level
        // 2. Niveaux des bonus à 0
        tempsLevel = 0
        drapeauLevel = 0
        bombeLevel = 0
        verificationLevel = 0
        vieLevel = 0
        // 3. Argent du joueur
        money = argent
        // 4. Ajouter quelques bonus au joueur
        tempsQuantity = 10
        drapeauQuantity = 10
        bombeQuantity = 10
        verificationQuantity = 10
        vieQuantity = 10
    }
    
    public func levelOfBonus(atIndex i: Int) -> Int {
        switch i {
        case 0: return tempsLevel
        case 1: return drapeauLevel
        case 2: return bombeLevel
        case 3: return verificationLevel
        case 4: return vieLevel
        default: return -1
        }
    }
    
    public func quantityOfBonus(atIndex i: Int) -> Int {
        switch i {
        case 0: return tempsQuantity
        case 1: return drapeauQuantity
        case 2: return bombeQuantity
        case 3: return verificationQuantity
        case 4: return vieQuantity
        default: return -1
        }
    }
    
    public func giveTimeToMantain() -> CGFloat {
        if timeToMantainIterator == 0 {
            return 0.2
        } else if timeToMantainIterator == 1 {
            return 0.35
        } else {
            return 0.55
        }
    }
    
    public func giveCurrentLanguage() -> String {
        return UserDefaultsManager.allLanguages[languageIterator]
    }
    
}

