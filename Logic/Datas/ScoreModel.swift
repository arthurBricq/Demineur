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
import SystemConfiguration



// MARK: - Variable globale pour cloudKit
let scoresModel = ScoresModel()




// MARK: - Structure à sauvegarder
struct Score {
    
    fileprivate static let recordType = "Score"
    fileprivate static let keys: (level: String, numberOfBombs: String, userIdentifier: String) = ("level","numberOfBombs","userIdentifier")
    
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
    
    var userIdentifier: String {
        get {
            return self.record.value(forKey: Score.keys.userIdentifier) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Score.keys.userIdentifier)
        }
    }
    
}

// MARK: - Classe de sauvegarde qui gère la structure "Score"
class ScoresModel {
    private let database = CKContainer.default().publicCloudDatabase
    
    
    // MARK: - variables et propriétés remarquables
    var allScores = [Score]() {
        didSet {
            self.notificationQueue.addOperation {
                self.onChange?()
            }
        }
    }
    
    var bestLevel: Int  {
        var toReturn: Int = 1
        for score in allScores {
            if score.level > toReturn {
                toReturn = score.level
            }
        }
        return toReturn
    }
    
    var bestNumberOfBombs: Int  {
        var toReturn: Int = 0
        for score in allScores {
            if score.numberOfBombs > toReturn {
                toReturn = score.numberOfBombs
            }
        }
        return toReturn
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
    
    // MARK: - Fonctions pour la synchronisation
    
    func addOneScore(level: Int, numberOfBombs: Int) {
        var newScore = Score()
        newScore.level = level
        newScore.numberOfBombs = numberOfBombs
        
        // Pour ajouter l'identifiant des apples
        iCloudUserIDAsync { (recordID: CKRecordID?, error: NSError?) in
            if let userID = recordID?.recordName {
                newScore.userIdentifier = userID
            } else {
                print("Fetched iCloudID was nil")
            }
        }
        
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
        
        // debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
        
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
    
    // MARK: - Fonctions pour le calcul des statistiques
    // Il faut calculer 1. la longueur moyenne des parties 2. le nombre de bombes moyen et 3. le % des plus forts
    
    
    /// Cette fonction retourne un tableau de tous les scores équivalents de tous les joueurs, triés par ordre croissant
    /// Le score equivalent = 10*(Nombre Moyen de Niveau) + Nombre Moyen de Bombes
    func findEquivalentScoresOfPlayers() -> [Int] {
        var toReturn: [Int] = []
        
        // Version trié des scores
        let array = allScores.sorted { (score1, score2) -> Bool in
            return score1.userIdentifier < score2.userIdentifier
        }
        
        var curentId: String = array.first!.userIdentifier
        var arraysByPlayers: [[Score]] = [[Score]].init() // tableau de tableau, qui est trié par tous les comptes des joueurs.
        var tmpArray: [Score] = []
        
        print("current id:\(curentId)")
        // On progresse parmis tous les scores
        for element in array
        {
            print("id:\(element.userIdentifier)")
            
            if element.userIdentifier == curentId { // même joueur qu'avant -> remplir le tableau TMP
                print("a")
                tmpArray.append(element)
            } else { // il s'agit d'un nouveau joueur -> On change le current iD
                print("b")
                arraysByPlayers.append(tmpArray)
                tmpArray.removeAll()
                curentId = element.userIdentifier
                tmpArray.append(element)
            }
        }
        arraysByPlayers.append(tmpArray)
        
        for playerArray in arraysByPlayers {
            
            var sumOfLevel: Int = 0
            var sumOfBombs: Int = 0
            
            for i in playerArray { // tous les scores du joueur ...
                sumOfLevel += i.level
                sumOfBombs += i.numberOfBombs
            }
            
            // Nombres moyen pour le joueur X :
            let tmpLevel = sumOfLevel/playerArray.count
            let tmpBomb = sumOfBombs/playerArray.count
            
            let equivalentScore = 10*tmpLevel + tmpBomb
            toReturn.append(equivalentScore)
        }
        
        
        return toReturn.sorted(by: { (a, b) -> Bool in
            return a < b
        })

    }
    /// Cette fonction retourne un tableau de tous les niveau moyens des joueurs, triés par ordre croissant
    func findAverageLevelOfPlayers() -> [Int] {
        var toReturn: [Int] = []
        
        let array = allScores.sorted { (score1, score2) -> Bool in
            return score1.userIdentifier < score2.userIdentifier
        }
        
        var curentId: String = allScores.first!.userIdentifier
        var arraysByPlayers: [[Score]] = [[Score]].init() // tableau de tableau, qui est trié par tous les comptes des joueurs.
        var tmpArray: [Score] = [Score].init()
        
        
        for element in array {
            if element.userIdentifier == curentId { // même joueur qu'avant -> remplir le tableau TMP
                tmpArray.append(element)
            } else { // il s'agit d'un nouveau joueur
                arraysByPlayers.append(tmpArray)
                tmpArray.removeAll()
                curentId = element.userIdentifier
                tmpArray.append(element)
            }
        }
        
        arraysByPlayers.append(tmpArray)
        
        
        for playerArray in arraysByPlayers {
            
            var sumOfLevel: Int = 0
            var sumOfBombs: Int = 0
            
            for i in playerArray { // tous les scores du joueur ...
                sumOfLevel += i.level
                sumOfBombs += i.numberOfBombs
            }
            
            // Nombres moyen pour le joueur X :
            let tmpLevel = sumOfLevel/playerArray.count
            let tmpBomb = sumOfBombs/playerArray.count
            
            toReturn.append(tmpLevel)
            
        }
        
        return toReturn.sorted(by: { (a, b) -> Bool in
            return a < b
        })
        
    }
    
    /// Cette fonction retourne un tableau de tous les nombre de bombes moyens des joueurs, triés par ordre croissant
    func findTotalNumberOfBombsOfPlayers() -> [Int] {
        var toReturn: [Int] = []
        
        let array = allScores.sorted { (score1, score2) -> Bool in
            return score1.userIdentifier < score2.userIdentifier
        }
        
        var curentId: String = array.first!.userIdentifier
        var arraysByPlayers: [[Score]] = [[Score]].init() // tableau de tableau, qui est trié par tous les comptes des joueurs.
        var tmpArray: [Score] = []
        
        for element in array {
            if element.userIdentifier == curentId { // même joueur qu'avant -> remplir le tableau TMP
                tmpArray.append(element)
            } else { // il s'agit d'un nouveau joueur
                arraysByPlayers.append(tmpArray)
                tmpArray.removeAll()
                curentId = element.userIdentifier
                tmpArray.append(element)
            }
        }

        arraysByPlayers.append(tmpArray)

        for playerArray in arraysByPlayers {
            
            var sumOfBombs: Int = 0
            
            for i in playerArray { // tous les scores du joueur ...
                sumOfBombs += i.numberOfBombs
            }
        
            toReturn.append(sumOfBombs)
        }
        
        return toReturn.sorted(by: { (a, b) -> Bool in
            return a < b
        })
        
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

// MARK: - Vérification de la présence d'internet
public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}

// MARK: - Reconnaissance de l'identifiant iCloud afin de reconnaitre les joueurs

/// async gets iCloud record ID object of logged-in iCloud user
func iCloudUserIDAsync(complete: @escaping (_ instance: CKRecordID?, _ error: NSError?) -> ()) {
    let container = CKContainer.default()
    container.fetchUserRecordID() {
        recordID, error in
        if error != nil {
            print(error!.localizedDescription)
            complete(nil, error as NSError?)
        } else {
            print("fetched ID \(recordID?.recordName)")
            complete(recordID, nil)
        }
    }
}


/*

// call the function above in the following way:
// (userID is the string you are interested in!)
iCloudUserIDAsync { (recordID: CKRecordID?, error: NSError?) in
    if let userID = recordID?.recordName {
        print("received iCloudID \(userID)")
    } else {
        print("Fetched iCloudID was nil")
    }
}

 */
