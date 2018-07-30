//
//  InfiniteFunctions.swift
//  Demineur
//
//  Created by Arthur BRICQ on 29/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit

/// Cette classe permet de changer les cartes des modes infinies au fur et à mesure que la partie avance.
class InfiniteIterators {
    var squareGameDimensionsIterator: Int = -1 // iterateur des cartes carrées
    var hexGameDimensionsIterator: Int = -1 // iterateur des cartes hexa
    var triangularGameDimensionsIterator: Int = -1 // iterateur des cartes triangulaires

    init(squareGameDimensionsIterator: Int,hexGameDimensionsIterator: Int,triangularGameDimensionsIterator: Int) {
        self.squareGameDimensionsIterator = squareGameDimensionsIterator
        self.hexGameDimensionsIterator = hexGameDimensionsIterator
        self.triangularGameDimensionsIterator = triangularGameDimensionsIterator
    }
    
    convenience init() {
        self.init(squareGameDimensionsIterator: -1, hexGameDimensionsIterator: -1, triangularGameDimensionsIterator: -1)
    }
}

struct ListeDesMondes {
    static let carreMap: [(n: Int, m: Int)] = [ (9,6),
                                                (10,8),
                                                (13,10),
                                                (15,10),
                                                (17,12),
                                                (18,13) ]
    
    static let hexMap: [(n: Int, m: Int)] = [(9,6),
                                             (10,8),
                                             (12,8),
                                             (14,10),
                                             (15,10),
                                             (17,11) ]
    
    static let triangularMap: [(n: Int, m: Int)] = [(6,7),
                                                    (6,9),
                                                    (8,9),
                                                    (8,11),
                                                    (10,11),
                                                    (10,13) ]
    
}


class InfiniteGameManager {
    
    var iterators = InfiniteIterators()
    
    /// Cette fonction retourne la prochaine section, pour une section donnée. Pour la première section, il faut rentrer -1 en paramètre d'entré. Le deuxième paramètre est le remplissemet : z / (n*m)
    func nextSection(forLastRemplissement lastRemplissement: CGFloat) -> Section {
        
        let section = Section.init()
        
        //// 1. Trouver le type de case
        // 20% de chance pour triangle
        // 40% de chance pour carre
        // 40% de chance pour hexa
        let tmp1 = random(5)
        switch tmp1 {
        case 0,1:
            section.gameType = .square
        case 2,3:
            section.gameType = .hexagonal
        case 4:
            section.gameType = .triangular
        default:
            fatalError("Probleme dans la génération de tmp aléatoire ! ")
            break
        }
        
        
        //// 2. Trouver la partie à jouer (n,m)
        // 3 chances sur 4 d'avancer
        // sinon on recule (ou ne rien faire ?)
        let tmp2 = random(4)
        var increment2: Int = 0
        switch tmp2 {
        case 0,1,2:
            increment2 = 1 // on avance
        case 3:
            increment2 = 0 // on ne fais rien
        default:
            fatalError("Probleme dans la généraation de tmp aléatoire")
        }
        
        var map: (n:Int,m:Int) = (0,0)
        switch section.gameType {
        case .square:
            iterators.squareGameDimensionsIterator += increment2
            if iterators.squareGameDimensionsIterator <= -1 { iterators.squareGameDimensionsIterator = 0 }
            if iterators.squareGameDimensionsIterator == ListeDesMondes.carreMap.count { iterators.squareGameDimensionsIterator = ListeDesMondes.carreMap.count - 1 }
            map = ListeDesMondes.carreMap[iterators.squareGameDimensionsIterator]
        case .hexagonal:
            iterators.hexGameDimensionsIterator += increment2
            if iterators.hexGameDimensionsIterator <= -1 { iterators.hexGameDimensionsIterator = 0 }
            if iterators.hexGameDimensionsIterator == ListeDesMondes.hexMap.count { iterators.hexGameDimensionsIterator = ListeDesMondes.hexMap.count - 1 }
            map = ListeDesMondes.hexMap[iterators.hexGameDimensionsIterator]
        case .triangular:
            iterators.triangularGameDimensionsIterator += increment2
            if iterators.triangularGameDimensionsIterator <= -1 { iterators.triangularGameDimensionsIterator = 0 }
            if iterators.triangularGameDimensionsIterator == ListeDesMondes.triangularMap.count { iterators.triangularGameDimensionsIterator = ListeDesMondes.triangularMap.count - 1 }
            map = ListeDesMondes.triangularMap[iterators.triangularGameDimensionsIterator]
        }
        
        section.n = map.n
        section.m = map.m
        
        
        //// 3. Trouver le nombre de bombes de la première partie
        let remplissementMaximale: CGFloat = 0.5 // à ne pas dépasser
        // 2 chances sur 3 d'avancer (ou de stagner)
        // 1 chance sur 3 de reculer
        let tmp3 = random(3)
        var increment3: CGFloat = 0
        switch tmp3 {
        case 0,1:
            if lastRemplissement < remplissementMaximale {
                increment3 = 0.05
            } else {
                increment3 = 0
            }
        case 2:
            increment3 = -0.05
        default:
            fatalError("Probleme dans la génération de tmp aléatoire")
        }
        
        var newRemplissement = lastRemplissement + increment3 // = z / (n*m)
        if newRemplissement < 0 { newRemplissement = 0.1 } // ne pas avoir zero ou moins
        let zTmp = newRemplissement * CGFloat(section.n) * CGFloat(section.m)
        let z = floor(zTmp)
        section.z0 = Int(z)
        
        // On a trouve les 4 propriétés principales d'une section
        print(" \n*** Nouvelle section *** ")
        print("Type de case: \(section.gameType)")
        switch section.gameType {
        case .square:
            print("itérateur: \(iterators.squareGameDimensionsIterator)")
        case .hexagonal:
            print("itérateur: \(iterators.hexGameDimensionsIterator)")
        case .triangular:
            print("itérateur: \(iterators.triangularGameDimensionsIterator)")
        }
        print("Dimensions: \(section.n),\(section.m)")
        print("Nombre de bombes: \(section.z0) et \(zTmp)")
        print("Last remplissement: \(lastRemplissement)")
        print("Nouveau remplissement: \(newRemplissement)")
        
        
        //// 4. Il faut maintenant trouver les 5 parties de la section qui vient.
        // Pour cela, on fait un tirage au sort entre différentes parties. 
        section.updateGamesOfThisSection()
        
        
        
        
        
        return section
    }
    
    init() {
        self.iterators = InfiniteIterators()
    }
    
}


