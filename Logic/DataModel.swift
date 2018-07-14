//
//  DataModel.swift
//  Demineur
//
//  Created by Arthur BRICQ on 13/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let money = MoneyManager()

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
     Cette fonction est appellée à chaque modification de la variable 'currentAmountOfMoney'
    */
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Money")
        fetchRequest.includesPropertyValues = false
        
        // delete all older entries
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                managedContext.delete(item)
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Money", in: managedContext)!
        let money = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        money.setValue(currentAmountOfMoney, forKeyPath: "quantity")
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}
