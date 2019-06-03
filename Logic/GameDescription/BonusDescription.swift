//
//  BonusDescription.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit


/// ORDRE DES BONUS :
// Temps
// Drapeau
// Bombe
// Verification
// Vie
/// VARIABLE DE SAUVEGARDE : 'bonus'
struct BonusDescription {
    let name: String
    var niveau: Int = 0 // il faut faire +1 // INUTILE POUR LA LOGIQUE
    var niveauMax: Int // egale au nombre de niveaux possible -1 (le 1er niveau étant d'indice 0)
    let descriptions: [String]
    let descriptionsAmeliorations: [String]
    let prixAchat: Int
    let prixAmelioration: [Int]
}

let allBonus: [BonusDescription] = [
    
    BonusDescription(name: "Temps", niveau: 0, niveauMax: 3, descriptions: ["Récupérez 15 secondes", "Récupérez 30 secondes", "Récupérez 45 secondes", "Récupérez 1 minute"],descriptionsAmeliorations: ["+ 15 secondes", "+ 15 secondes", "+ 15 secondees"], prixAchat: 750, prixAmelioration: [8000, 16000, 30000, 40000] ),
    
    BonusDescription(name: "Drapeau", niveau: 0, niveauMax: 2, descriptions: ["Gagnez un drapeau durant une partie", "Gagnez 2 drapeaux durant une partie", "Gagnez 3 drapeaux durant une partie"],descriptionsAmeliorations: ["+ 1 drapeau gagné", "+ 1 drapeau gagné"], prixAchat: 1000, prixAmelioration: [10000,20000] ),
    
    BonusDescription(name: "Bombe", niveau: 0, niveauMax: 2, descriptions: ["Trouver une bombe avec une chance de 50%.","Trouver une bombe !","Trouver 2 bombes avec une chance de 50%"],descriptionsAmeliorations: ["Trouvez-là avec 100% de chance !", "+ 1 bombe à 50% de chances"], prixAchat: 1000, prixAmelioration: [10000,20000] ),
    
    BonusDescription(name: "Verification", niveau: 0, niveauMax: 1 , descriptions: ["Vérifiez certains de vos drapeaux","Vérifiez tous les drapeaux"],descriptionsAmeliorations: ["Vérifiez tous les drapeaux"], prixAchat: 2000, prixAmelioration: [20000, 50000] ),
    
    BonusDescription(name: "Vie", niveau: 0, niveauMax: 2, descriptions: ["Obtenez une seconde chance", "Vous surviverez à 2 bombes", "3 échecs ne vous abatteront pas !"],descriptionsAmeliorations: ["Survivez à 2 bombes !", "Survivez à 3 bombes"], prixAchat: 2500, prixAmelioration: [20000, 50000] )
    
]
