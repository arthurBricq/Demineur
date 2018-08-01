//
//  InfiniteFunctions.swift
//  Demineur
//
//  Created by Arthur BRICQ on 29/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit

class InfiniteIterators {
    var squareGameDimensionsIterator: Int = 0 // iterateur des cartes carrées
    var hexGameDimensionsIterator: Int = 0 // iterateur des cartes hexa
    var triangularGameDimensionsIterator: Int = 0 // iterateur des cartes triangulaires

    init(squareGameDimensionsIterator: Int,hexGameDimensionsIterator: Int,triangularGameDimensionsIterator: Int) {
        self.squareGameDimensionsIterator = squareGameDimensionsIterator
        self.hexGameDimensionsIterator = hexGameDimensionsIterator
        self.triangularGameDimensionsIterator = triangularGameDimensionsIterator
    }
    
    convenience init() {
        self.init(squareGameDimensionsIterator: 0, hexGameDimensionsIterator: 0, triangularGameDimensionsIterator: 0)
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
    func nextSection(forLastRemplissement lastRemplissement: CGFloat, forSectionIndex index: Int = 1) -> Section {
        
        let section = Section()
        
        //// 1. Trouver le type de case
        // 20% de chance pour triangle
        // 40% de chance pour carre
        // 40% de chance pour hexa
        let tmp1 = random(5)
        switch tmp1 {
        case 0,1:
            print("cas carré")
            section.gameType = .square
        case 2,3:
            print("cas hax")
            section.gameType = .hexagonal
        case 4:
            print("cas triangulaire")
            section.gameType = .triangular
        default:
            fatalError("Probleme dans la génération de tmp aléatoire ! ")
            break
        }
        
        
        //// 2. Trouver la partie à jouer (n,m)
        // 2 chances sur 3 d'avancer
        // sinon on recule
        let tmp2 = random(3)
        var increment2: Int = 0
        switch tmp2 {
        case 0,1:
            increment2 = 1
        case 2:
            increment2 = -1
        default:
            fatalError("Probleme dans la généraation de tmp aléatoire")
        }
        
        var map: (n:Int,m:Int) = (0,0)
        
        switch section.gameType {
        case .square:
            iterators.squareGameDimensionsIterator += increment2
            map = ListeDesMondes.carreMap[iterators.squareGameDimensionsIterator]
        case .hexagonal:
            iterators.hexGameDimensionsIterator += increment2
            map = ListeDesMondes.hexMap[iterators.hexGameDimensionsIterator]
        case .triangular:
            iterators.triangularGameDimensionsIterator += increment2
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
                increment3 = 0.1
            } else {
                increment3 = 0
            }
        case 2:
            increment3 = -0.1
        default:
            fatalError("Probleme dans la généraation de tmp aléatoire")
        }
        
        let newRemplissement = lastRemplissement + increment3 // = z / (n*m)
        let zTmp = newRemplissement * CGFloat(section.n) * CGFloat(section.m)
        let z = floor(zTmp)
        section.z0 = Int(z)
        
        // On a trouve les 4 propriétés principales d'une section s
        print(" *** Nouvelle section *** ")
        print("Type de case: \(section.gameType)")
        print("Dimensions: \(section.n),\(section.m)")
        print("Nombre de bombes: \(section.z0)")
        
        
        return section
    }
    
    init() {
        self.iterators = InfiniteIterators()
    }
    
}


