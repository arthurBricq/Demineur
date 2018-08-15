//
//  ScoreModel.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//


/*
 Model de sauvegarde en ligne pour le score
 Il y a deux éléments:
 - une structure Score de sauvegarde
 - une classe ScoresModel, avec un tableau [AllScore] qui s'occupe de la sauvegarde.
 
 Pour ajouter ou supprimer des éléments, il faut utiliser les fonctions "addOneScore" ou "delete(at:)" qui vont s'occuper de tout le fonctionnement.
 Les éléments sauvegardées sont dans le tableau AllScores.
 Il y a une fonction de rafraichissement qui permet de récupérer les données en lignes.
 Il faut donner à la variable scores les fonctions qu'elle doit faire lorsqu'il y a une erreure.
 
 Il y a une variable globale du type ScoresModel dans le fichier DataModel.swift
*/

import Foundation
import CloudKit


// MARK: - Structure à sauvegarder
struct Score {
    
    fileprivate static let recordType = "Score"
    fileprivate static let keys: (level: String, numberOfBombs: String) = ("level","numberOfBombs")
    
    var record: CKRecord
    
    init() {
        self.record = CKRecord(recordType: Score.recordType)
    }
    
    init(record: CKRecord) {
        self.record = record
    }
    
    // Propriétés de la structure
    var level: Int {
        get {
            return self.record.value(forKey: Score.keys.level) as! Int
        }
        set {
            self.record.setValue(newValue, forKey: Score.keys.level)
        }
    }
    
    var numberOfBombs: Int {
        get {
            return self.record.value(forKey: Score.keys.numberOfBombs) as! Int
        }
        set {
            self.record.setValue(newValue, forKey: Score.keys.numberOfBombs)
        }
    }
    
    
}

// MARK: - Classe de sauvegarde qui gère la structure "Score"
class ScoresModel {
    private let database = CKContainer.default().publicCloudDatabase
    var allScores = [Score]() {
        didSet {
            self.notificationQueue.addOperation {
                self.onChange?()
            }
        }
    }
    
    var onChange : (() -> Void)?
    var onError : ((Error) -> Void)?
    var notificationQueue = OperationQueue.main
    var records = [CKRecord]()
    // les listes d'attentes
    var insertedObjects = [Score]()
    var deletedObjectIds = Set<CKRecordID>()
    
    init() { }
    
    private func handle(error: Error) {
        self.notificationQueue.addOperation {
            self.onError?(error)
        }
    }
    
    func addOneScore(level: Int, numberOfBombs: Int) {
        var newScore = Score()
        newScore.level = level
        newScore.numberOfBombs = numberOfBombs
        database.save(newScore.record) { (_, error) in
            guard error == nil else {
                self.handle(error: error!)
                return
            }
        }
        
        self.insertedObjects.append(newScore) // liste d'attente
        self.updateModel()
    }
    
    func delete(at index: Int) {
        let recordId = self.allScores[index].record.recordID
        database.delete(withRecordID: recordId) { _, error in
            guard error == nil else {
                self.handle(error: error!)
                return
            }
        }
        
        deletedObjectIds.insert(recordId)
        self.updateModel()
    }
    
    /// Cette fonction permet d'actualiser les données "allScores" après qu'elle aient été modifées. Nottament cette fonction est en charge de rajouter ou de supprimer les éléments du tableau "allScores"
    private func updateModel() {
        
        // 1. On récupère tous les id des anciens records réalisé.
        var knownIds = Set(records.map { $0.recordID })
        
        // 2. Retirer tous les éléments de la liste des éléments insérés en attente qui ont déja été enregistrés.
        // En effet, le tableau "records" n'est actualisé que quand on refresh la database.
        self.insertedObjects.removeMatching { (score) -> Bool in
            knownIds.contains(score.record.recordID)
        }
        // puis on récupère l'union des deux tableaux
        knownIds.formUnion(self.insertedObjects.map { $0.record.recordID })
        
        // 3. On refais pareil pour la liste des éléments pas encore suprimées
        self.deletedObjectIds.formIntersection(knownIds)
        
        
        var scores = records.map { record in Score(record: record) } // créer un tableau à partir de tous les records -> récupérer les nouvelles données
        scores.append(contentsOf: self.insertedObjects) // rajouter les éléments qui sont pas encore enrigstré
        scores.removeMatching { (score) -> Bool in // enlever les éléments pas encore enlevé
            deletedObjectIds.contains(score.record.recordID)
        }
        
        self.allScores = scores
        
        debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
        
    }
    
    @objc func refresh() {
        let query =  CKQuery(recordType: Score.recordType, predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records, error == nil else {
                self.handle(error: error!)
                return
            }
            self.records = records
            self.updateModel()
        }
    }
    
    
}


// MARK: - Extension des arrays qui rajoute une fonction de suppression par valeurs
extension Array {
    
    /// Removes all items that satisfy the predicate:
    mutating func removeMatching(predicate: (Element) -> Bool) {
        for index in stride(from: count - 1, through: 0, by: -1) {
            if predicate(self[index]) {
                self.remove(at: index)
            }
        }
    }
}

