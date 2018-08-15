//  DataModel.swift
//  Demineur
//
//  Created by Arthur BRICQ on 13/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.

import Foundation
import UIKit
import CoreData

let money = MoneyManager()
let options = OptionsManager()
let bonus = BonusManager()
let levelOfBonus = LevelBonusManager()
let gameData = GameDataManager()

let scoresModel = ScoresModel()


/// Cette fonction est appelée si on souhaite ré-initialiser toutes les propriétés d'une partie correctement
func initiateANewDevice(argent: Int, lives: Int, level: Int) {
    // 1. Niveau du joueur
    gameData.currentLevel = level
    // 2. Niveaux des bonus
    levelOfBonus.initializeLevels(atLevel: 0) // indice zéro pour les premiers bonus
    // 3. Argent du joueur
    money.currentAmountOfMoney = argent
    // 4. Ajouter quelques bonus au joueur
    bonus.temps = 10
    bonus.drapeau = 10
    bonus.bombe = 10
    bonus.verification = 10
    bonus.vie = lives
}


/// Pour sauvegarder l'argent de la partie.
class MoneyManager {
    
    var currentAmountOfMoney: Int = 0 { // il s'agit de la variable qui contient l'argent du jeu. C'est celle-ci qu'il faut modifier lorsque l'on gagne de l'argent. On peut la modifier en utilisant des fonctions déjà construites ()
        didSet {
            save()
        }
    }
    
    func addMoney(amount: Int) { 
        currentAmountOfMoney += amount
    }
    
    func takeAwayMoney(amount: Int) {
        currentAmountOfMoney -= amount
    }
    
    
    /**
     Cette fonction actualise la variable 'currentAmountOfMoney', et supprime de la mémoire les anciennes valeurs stockées de cette variable.
    */
    @discardableResult func getCurrentValue() -> Int {
        var toReturn: Int = 0
        
        // 1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2 : creéer la requete
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Money") // on récupère tous les objets qui ont une entité Money
        
        // 3 : récuperer toutes les valeurs déjà sauvegardées, sous formes d'objets
        var allArgent: [NSManagedObject] = []
        do {
            allArgent = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            allArgent = []
        }
        
        // 4 : il faut supprimer toutes les anciennes sauvegardes.
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                managedContext.delete(item)
            }
        } catch let error as NSError {
            print("il y a une erreure pour supprimer les sauvegardes \(error), \(error.userInfo)")
        }
        
        // 5 : retourner la valeur courante

        guard let currentMoney = allArgent.last?.value(forKey: "quantity") as? Int else {
            return toReturn
        }
        
        toReturn = currentMoney
        self.currentAmountOfMoney = toReturn
        return toReturn
    }
    
    /**
     Cette fonction est appellée à chaque modification de la variable 'currentAmountOfMoney' dans le didSet de la variable.
    */
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        // 1 : creer une instance à sauvegarder.
        let entity = NSEntityDescription.entity(forEntityName: "Money", in: managedContext)!
        let money = NSManagedObject(entity: entity, insertInto: managedContext)
        money.setValue(currentAmountOfMoney, forKeyPath: "quantity")
        
        // 2 : sauvegarder le nouveau contexte.
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}


class GameDataManager {
    
    var currentLevel: Int = 0 {
        didSet {
            save()
        }
    }
    
    
    @discardableResult func getCurrentValue() -> Int {
        var toReturn: Int = 0
        
        // 1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2 : creéer la requete
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameData") // on récupère tous les objets qui ont une entité Money
        
        // 3 : récuperer toutes les valeurs déjà sauvegardées, sous formes d'objets
        var allObjects: [NSManagedObject] = []
        do {
            allObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            allObjects = []
        }
        
        // 4 : il faut supprimer toutes les anciennes sauvegardes.
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                managedContext.delete(item)
            }
        } catch let error as NSError {
            print("il y a une erreure pour supprimer les sauvegardes \(error), \(error.userInfo)")
        }
        
        // 5 : retourner la valeur courante
        
        guard let level = allObjects.last?.value(forKey: "level") as? Int else {
            return toReturn
        }
        
        toReturn = level
        self.currentLevel = level
        
        return toReturn
    }
    
    /**
     Cette fonction est appellée à chaque modification de la variable 'currentAmountOfMoney' dans le didSet de la variable.
     */
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 1 : creer une instance à sauvegarder.
        let entity = NSEntityDescription.entity(forEntityName: "GameData", in: managedContext)!
        let money = NSManagedObject(entity: entity, insertInto: managedContext)
        money.setValue(self.currentLevel, forKeyPath: "level")
        
        // 2 : sauvegarder le nouveau contexte.
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}


/// Pour sauvegarder les options du jeu
class OptionsManager {
    
    var areVibrationsOn: Bool = true {
        didSet {
            save()
        }
    }
    
    var indexOfArticle: Int = 0 {
        didSet {
            save()
        }
    }
    
    /**
     Cette fonction actualise la variable et supprime de la mémoire les anciennes valeurs stockées de cette variable.
     */
    @discardableResult func getCurrentValue() -> (Bool,Int) {
        var toReturn: (Bool,Int) = (true,0)
        
        // 1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return toReturn }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2 : creéer la requete
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Options") // on récupère tous les objets qui ont une entité Money
        
        // 3 : récuperer toutes les valeurs déjà sauvegardées, sous formes d'objets
        var options: [NSManagedObject] = []
        
        do {
            options = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // 4 : il faut supprimer toutes les anciennes sauvegardes.
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                managedContext.delete(item)
            }
        } catch let error as NSError {
            print("il y a une erreure pour supprimer les sauvegardes \(error), \(error.userInfo)")
        }
        
        // 5 : retourner la valeur courante
        guard let option1 = options.last?.value(forKey: "vibration") as? Bool else { return toReturn }
        guard let option2 = options.last?.value(forKey: "indexOfArticle") as? Int else { return toReturn }

    
        toReturn = (option1,option2)
        self.areVibrationsOn = option1
        self.indexOfArticle = option2
        
        
        return toReturn
    }
    
    /**
     Cette fonction est appellée à chaque modification de la variable 'currentAmountOfMoney'
     */
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        // 2 : create the instance to be saved
        let entity = NSEntityDescription.entity(forEntityName: "Options", in: managedContext)!
        let options = NSManagedObject(entity: entity, insertInto: managedContext)
        
        options.setValue(self.areVibrationsOn, forKeyPath: "vibration")
        options.setValue(self.indexOfArticle, forKey: "indexOfArticle")
        
        
        // 3 : save the instance that have been created
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func displayOptions() {
        print("      Parametres du jeu")
        print("vibrations: \(areVibrationsOn)")
        print("index de l'article: \(indexOfArticle)")
    }
}


/// Pour sauvegarder les bonus, il faut utiliser les fonctions de cette classe afin d'ajouter ou de soustraire des bonus pour le joueur.
class BonusManager {
    
    var temps: Int = 1 { didSet { save() }}
    var drapeau: Int = 1 { didSet { save() }}
    var bombe: Int = 1 { didSet { save() }}
    var verification: Int = 1 { didSet { save() }}
    var vie: Int = 1 { didSet { save() }}

    /**
     Cette fonction actualise la variable et supprime de la mémoire les anciennes valeurs stockées de cette variable.
     */
    @discardableResult func getCurrentValue() -> (Int,Int,Int,Int,Int)
    {
        var toReturn: (Int,Int,Int,Int,Int) = (1,1,1,1,1)
        
        // 1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return toReturn }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2 : creéer la requete
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bonus") // tous les objets qui ont une entité Bonus

    
        // 3 : récuperer toutes les valeurs déjà sauvegardées, sous formes d'objets
        var allBonus: [NSManagedObject] = []
        
        do {
            allBonus = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // 4 : il faut supprimer toutes les anciennes sauvegardes.
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                managedContext.delete(item)
            }
        } catch let error as NSError {
            print("il y a une erreur pour supprimer les sauvegardes : \(error), \(error.userInfo)")
        }
        
        // 5 - Retourner les valeurs courantes
        
        guard let bonus1 = allBonus.last?.value(forKey: "temps") as? Int else { return toReturn } // ...
        guard let bonus2 = allBonus.last?.value(forKey: "drapeau") as? Int else { return toReturn } // ...
        guard let bonus3 = allBonus.last?.value(forKey: "bombe") as? Int else { return toReturn } // ...
        guard let bonus4 = allBonus.last?.value(forKey: "verification") as? Int else { return toReturn } // avant derniere ...
        guard let bonus5 = allBonus.last?.value(forKey: "vie") as? Int else { return toReturn } // dernière valeure sauvegardée
        
        toReturn = (bonus1,bonus2,bonus3,bonus4,bonus5)

        updateBonusQuantity(temps: bonus1, drapeau: bonus2, bombe: bonus3, vie: bonus5, verification: bonus4)
        
        return toReturn
    }
    
    func save() {
        // 1 :
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2 : create the instance to be saved
        let entity = NSEntityDescription.entity(forEntityName: "Bonus", in: managedContext)!
        
        let option = NSManagedObject(entity: entity, insertInto: managedContext)
        
        option.setValue(self.temps, forKeyPath: "temps")
        option.setValue(self.drapeau, forKeyPath: "drapeau")
        option.setValue(self.bombe, forKeyPath: "bombe")
        option.setValue(self.vie, forKeyPath: "vie")
        option.setValue(self.verification, forKeyPath: "verification")
        
        
        // 3 : save the instance that have been created
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func addTemps(amount: Int) {
        updateBonusQuantity(temps: temps+amount, drapeau: drapeau, bombe: bombe, vie: vie, verification: verification)
    }
    
    func addDrapeau(amount: Int) {
        updateBonusQuantity(temps: temps, drapeau: drapeau+amount, bombe: bombe, vie: vie, verification: verification)
    }
    
    func addBomb(amount: Int) {
        updateBonusQuantity(temps: temps, drapeau: drapeau, bombe: bombe+amount, vie: vie, verification: verification)
    }
    
    func addVie(amount: Int) {
        if vie + amount < 0 {
            updateBonusQuantity(temps: temps, drapeau: drapeau, bombe: bombe, vie: 0, verification: verification)
        } else {
            updateBonusQuantity(temps: temps, drapeau: drapeau, bombe: bombe, vie: vie+amount, verification: verification)
        }
    }
    
    func addVerification(amount: Int) {
        updateBonusQuantity(temps: temps, drapeau: drapeau, bombe: bombe, vie: vie, verification: verification+amount)
    }
    
    /// ATTENTION L'ORDRE N'EST PAS LE MEME ///
    func updateBonusQuantity(temps: Int, drapeau: Int, bombe: Int, vie: Int, verification: Int) {
        self.temps = temps
        self.drapeau = drapeau
        self.bombe = bombe
        self.vie = vie
        self.verification = verification
        
        self.save()
    }
    
    func displayCurrentBonus() {
        print("Bonus du joueur")
        print("temps: \(self.temps)")
        print("drapeau: \(self.drapeau)")
        print("bombe: \(self.bombe)")
        print("verif.: \(self.verification)")
        print("vie: \(self.vie)")
    }
    
    
    /// Cette fonction retourne le nombre de bonus que le joueur possede à partir de l'indice du bonus (utile dans la boutique).
    func giveTheNumberOfBonus(forIndex index: Int) -> Int {
        var tmp: Int = 1
        
        switch index {
        case 0:
            tmp = temps
        case 1:
            tmp = drapeau
        case 2:
            tmp = bombe
        case 3:
            tmp = verification
        case 4:
            tmp = vie
        default:
            break
        }
        
        return tmp
    }
    
}

/// Pour sauvegarder le niveau des bonus, il faut utiliser les fonctions de cette classe afin d'ajouter ou de soustraire des bonus pour le joueur.
class LevelBonusManager {
    
    var temps: Int = 1 { didSet { save() } }
    var drapeau: Int = 1 { didSet { save() } }
    var bombe: Int = 1 { didSet { save() } }
    var vie: Int = 1 { didSet { save() } }
    var verification: Int = 1 { didSet { save() } }
    
    /**
     Cette fonction actualise la variable et supprime de la mémoire les anciennes valeurs stockées de cette variable.
     */
    @discardableResult func getCurrentValue() -> (Int,Int,Int,Int,Int)
    {
        var toReturn: (Int,Int,Int,Int,Int) = (0,0,0,0,0)
        
        // 1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return toReturn }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2 : creéer la requete
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LevelBonus") // tous les objets qui ont une entité Bonus
        
        // 3 : récuperer toutes les valeurs déjà sauvegardées, sous formes d'objets
        var allBonus: [NSManagedObject] = []
        
        do {
            allBonus = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // 4 : il faut supprimer toutes les anciennes sauvegardes.
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                managedContext.delete(item)
            }
        } catch let error as NSError {
            print("il y a une erreure pour supprimer les sauvegardes \(error), \(error.userInfo)")
        }
        
        // 5 - Retourner les valeurs courantes qui sont dans la dernière entitée sauvegardée
        print("nombre d'element: \(allBonus.count)")
        guard let bonus1 = allBonus.last?.value(forKey: "temps") as? Int else { return toReturn } // ...
        guard let bonus2 = allBonus.last?.value(forKey: "drapeau") as? Int else { return toReturn } // ...
        guard let bonus3 = allBonus.last?.value(forKey: "bombe") as? Int else { return toReturn } // ...
        guard let bonus4 = allBonus.last?.value(forKey: "vie") as? Int else { return toReturn } // avant derniere ...
        guard let bonus5 = allBonus.last?.value(forKey: "verification") as? Int else { return toReturn } // dernière valeure sauvegardée
        
        toReturn = (bonus1,bonus2,bonus3,bonus4,bonus5)
        
        updateBonusQuantity(temps: bonus1, drapeau: bonus2, bombe: bonus3, vie: bonus4, verification: bonus5)
        
        return toReturn
    }
    
    func save() {
        
        // 1 :
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2 : create the instance to be saved
        let entity = NSEntityDescription.entity(forEntityName: "LevelBonus", in: managedContext)!
        
        let option = NSManagedObject(entity: entity, insertInto: managedContext)
        option.setValue(self.temps, forKeyPath: "temps")
        option.setValue(self.drapeau, forKeyPath: "drapeau")
        option.setValue(self.bombe, forKeyPath: "bombe")
        option.setValue(self.vie, forKeyPath: "vie")
        option.setValue(self.verification, forKeyPath: "verification")
        
        
        // 3 : save the instance that have been created
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func addTemps(amount: Int) {
        updateBonusQuantity(temps: temps+amount, drapeau: drapeau, bombe: bombe, vie: vie, verification: verification)
    }
    
    func addDrapeau(amount: Int) {
        updateBonusQuantity(temps: temps, drapeau: drapeau+amount, bombe: bombe, vie: vie, verification: verification)
    }
    
    func addBomb(amount: Int) {
        updateBonusQuantity(temps: temps, drapeau: drapeau, bombe: bombe+amount, vie: vie, verification: verification)
    }
    
    func addVie(amount: Int) {
        updateBonusQuantity(temps: temps, drapeau: drapeau, bombe: bombe, vie: vie+amount, verification: verification)
    }
    
    func addVerification(amount: Int) {
        updateBonusQuantity(temps: temps, drapeau: drapeau, bombe: bombe, vie: vie, verification: verification+amount)
    }
    
    func updateBonusQuantity(temps: Int, drapeau: Int, bombe: Int, vie: Int, verification: Int) {
        self.temps = temps
        self.drapeau = drapeau
        self.bombe = bombe
        self.vie = vie
        self.verification = verification
        
        self.save()
    }
    
    func displayCurrentBonusLevel() {
        print("Bonus du joueur")
        print("temps: \(self.temps)")
        print("drapeau: \(self.drapeau)")
        print("bombe: \(self.bombe)")
        print("vie: \(self.vie)")
        print("verif.: \(self.verification)")
    }
    
    func initializeLevels(atLevel level: Int ) {
        self.temps = level
        self.drapeau = level
        self.bombe = level
        self.vie = level
        self.verification = level
        self.save()
    }
    
    /// Cette fonction retourne le nombre de bonus que le joueur possede à partir de l'indice du bonus (utile dans la boutique).
    func giveTheLevelOfBonus(forIndex index: Int) -> Int {
        var tmp: Int = 1
        
        switch index {
        case 0:
            tmp = temps
        case 1:
            tmp = drapeau
        case 2:
            tmp = bombe
        case 3:
            tmp = verification
        case 4:
            tmp = vie
        default:
            break
        }
        
        return tmp
    }
    
}

