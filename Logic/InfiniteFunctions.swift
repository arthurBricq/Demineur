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
    static let carreMap: [(n: Int, m: Int)] = [ (9,7),
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
    
    init() {
        self.iterators = InfiniteIterators()
    }
    
    /// Cette fonction retourne la prochaine section, pour une section donnée. Le deuxième paramètre est le remplissemet : z / (n*m)
    func nextSection(forLastRemplissement lastRemplissement: CGFloat, forSectionIndex index: Int = 1) -> Section {
        
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
        var z = floor(zTmp)
        if z < 3 { z = 3 } // numéro minimal de bombes
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
        // Les paramètres caractéristiques d'une section ne sont pas importants ici
        
        /*
        Notations:
        x1 -- partie basique
        x2 -- partie chrono
        x3 -- partie option 1
        x4 -- partion option 2
        x5 -- partie option 3
        x6 -- partie option 1 chrono
        x7 -- partie option 2 chrono
        x8 -- partie option 3 chrono
        x9 -- partie azheilwmer
        x10 -- partie hardcore
        */
 
        // Quelques ponderations de difficultés
        let easyPonderation = (10,3,2,2,2,2,2,2,1,1)
        let mediumPonderation = (4,3,2,2,2,3,3,3,1,1)
        let hardPonderation = (1,2,3,3,3,4,4,4,2,2)

        let level1: Int = 3
        let level2: Int = 5
        
        // Reglages des options et du temps de jeu.
        print("Parties à jouer")
        switch index {
        case -1..<level1:
            print("  Pondération facile")
            section.incrementBomb = 1
            section.game1 = createOneGame(forDensity: easyPonderation)
            section.game2 = createOneGame(forDensity: easyPonderation)
            section.game3 = createOneGame(forDensity: easyPonderation)
            section.game4 = createOneGame(forDensity: easyPonderation)
            section.game5 = createOneGame(forDensity: easyPonderation)
        case level1..<level2:
            print("  Pondération moyenne")
            section.incrementBomb = 2
            section.game1 = createOneGame(forDensity: mediumPonderation)
            section.game2 = createOneGame(forDensity: mediumPonderation)
            section.game3 = createOneGame(forDensity: mediumPonderation)
            section.game4 = createOneGame(forDensity: mediumPonderation)
            section.game5 = createOneGame(forDensity: mediumPonderation)
        default:
            print("  Pondération difficile")
            section.incrementBomb = 3
            section.game1 = createOneGame(forDensity: hardPonderation)
            section.game2 = createOneGame(forDensity: hardPonderation)
            section.game3 = createOneGame(forDensity: hardPonderation)
            section.game4 = createOneGame(forDensity: hardPonderation)
            section.game5 = createOneGame(forDensity: hardPonderation)
        }
        
        
        
        //// 5. Trouver le nombre de drapeaux suplémentaire des parties
        // Plus la partie est difficile, moins il faut rajouter de drapeaux.
        // On part d'un nombre max. de drapeau additionnel: mettons 2 drapeaux
        var additionalsFlags: [Int] = [2,2,2,2,2] // Pour les 5 parties différentes.
        // chaque partie a une probabilité de perdre soit 1 drapeau, soit 2 drapeaux
        
        var p1: CGFloat = 0.0 // probabilité de perdre 1 drapeau
        var p2: CGFloat = 0.0 // probabilité de perdre 2 drapeau
        
        switch index {
        case -1..<level1:
            p1 = 0.6 ;
            p2 = 0.1 ;
        case level1..<level2:
            p1 = 0.4 ;
            p2 = 0.2 ;
        default:
            p1 = 0.4 ;
            p2 = 0.3 ;
        }
        
        // On applique la logique aléatoire pour trouver les bons nombres de drapeaux
        for i in 0..<additionalsFlags.count {
            let tmp = random(100)
            if tmp < Int(100*p1) {
                additionalsFlags[i]-=1
            } else if tmp < Int(100*(p1+p2)) {
                additionalsFlags[i]-=2
            }
            
        }
        
        print("drapeaux additionels des parties : \(additionalsFlags)")
        
        section.additionalsFlags = additionalsFlags
        
        // Passer les paramètres de sections aux parties !
        section.updateGamesOfThisSection()
        
        
        return section
    }
    
    
    
    
    
    
    
    /** Fonctions qui créent les parties à joueur. Le paramètre densité représente la pondération des différentes parties. La probabilité d'obtenir une partie x est probabilité = ponderation / somme des pondérations
    
     Notations:
     x1 -- partie basique
     x2 -- partie chrono
     x3 -- partie option 1
     x4 -- partion option 2
     x5 -- partie option 3
     x6 -- partie option 1 chrono
     x7 -- partie option 2 chrono
     x8 -- partie option 3 chrono
     x9 -- partie azheilwmer
     x10 -- partie hardcore
    */
    private func createOneGame(forDensity density: (x1:Int,x2:Int,x3: Int, x4:Int, x5:Int, x6: Int, x7: Int, x8: Int, x9: Int, x10: Int)) -> OneGame
    {
        var game = OneGame()
        /**** Calcul de la densité *****
         
         Chaque partie a une version simple (avec +2 drapeaux) et une version difficile (sans drapeau additionnel)
         Les points représentent les pondérations des probabilités.
         
         Parties possibles:
         - Partie basique : aucune option, aucun timer ••• 4 points
         - Partie chrono : aucune option, avec timer ••• 2 points
         - Partie option1 : juste l'option 1, sans timer ••• 2 points
         - Partie option2 : juste l'option 2, sans timer ••• 2 points
         - Partie option3 : juste l'option 3, sans timer ••• 2 points
         - Partie option1 chrono : juste l'option 1, avec timer ••• 1 point
         - Partie option2 chrono :  juste l'option 2, avec timer ••• 1 point
         - Partie option3 chrono : juste l'option 3, avec timer ••• 1 point
         - Partie azheilmer : option 1 + option 2 sans timer ••• 1 point
         - Partie hardcore : option 1 + option 2 + option 3 ••• 1 point
         
         somme des points = 17 points
         
         
         */
        
        // distribution aléatoire
        
        let x1 = density.x1
        let x2 = density.x2
        let x3 = density.x3
        let x4 = density.x4
        let x5 = density.x5
        let x6 = density.x6
        let x7 = density.x7
        let x8 = density.x8
        let x9 = density.x9
        let x10 = density.x10
        
        let tmp2 = random(x1+x2+x3+x4+x5+x6+x7+x8+x9+x10)
        
        var stringToDisplay: String = ""
        
        switch tmp2 {
        case 0..<x1: // partie basique.
            stringToDisplay = "partie basique"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
        case x1..<x1+x2: // partie basique chrono.
            stringToDisplay = "partie basique chrono"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: true, totalTime: 60, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
        case x1+x2..<x1+x2+x3: // partie option 1 avec 10 secondes d'interval.
            stringToDisplay = "partie option 1 avec 10 secondes d'interval"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: false, totalTime: 0, option1: true, option2: false, option1Time: 10, option2Frequency: 0, option3: false, option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
        case x1+x2+x3..<x1+x2+x3+x4: // partie option 2 avec 0.2 de fréquence de points d'interrogations.
            stringToDisplay = "partie option 2 avec 0.2 de fréquence de points d'interrogations"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: false, totalTime: 0, option1: false, option2: true, option1Time: 10, option2Frequency: 0.2, option3: false, option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
        case x1+x2+x3+x4..<x1+x2+x3+x4+x5: // partie option 3 avec 0.2 de fréquence et un interval de 5 secondes
            stringToDisplay = "partie option 3 avec 0.2 de fréquence et un interval de 5 secondes"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 10, option2Frequency: 0.2, option3: true, option3Frequency: 0.2, option3Time: 5, noneCases: [], areNumbersShowed: true)
        case x1+x2+x3+x4+x5..<x1+x2+x3+x4+x5+x6: // partie option 1 avec 10 secondes d'interval & avec timer
            stringToDisplay = "partie option 1 avec 10 secondes d'interval & avec timer"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: true, totalTime: 90, option1: true, option2: false, option1Time: 10, option2Frequency: 0, option3: false, option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
        case x1+x2+x3+x4+x5+x6..<x1+x2+x3+x4+x5+x6+x7: // partie option 2 avec 0.2 de fréquence de points d'interrogations & avec timer
            stringToDisplay = "partie option 2 avec 0.2 de fréquence de points d'interrogations & avec timer"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: true, totalTime: 90, option1: false, option2: true, option1Time: 10, option2Frequency: 0.2, option3: false, option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true)
        case x1+x2+x3+x4+x5+x6+x7..<x1+x2+x3+x4+x5+x6+x7+x8: // partie option 3 avec 0.2 de fréquence et un interval de 5 secondes & avec timer
            stringToDisplay = "partie option 3 avec 0.2 de fréquence et un interval de 5 secondes & avec timer"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: true, totalTime: 90, option1: false, option2: false, option1Time: 10, option2Frequency: 0.2, option3: true, option3Frequency: 0.2, option3Time: 5, noneCases: [], areNumbersShowed: true)
        case x1+x2+x3+x4+x5+x6+x7+x8..<x1+x2+x3+x4+x5+x6+x7+x8+x9: // Partie azheilmer
            stringToDisplay = "Partie azheilmer"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: false, totalTime: 0, option1: true, option2: true, option1Time: 10, option2Frequency: 0.2, option3: false, option3Frequency: 0.0, option3Time: 0, noneCases: [], areNumbersShowed: true)
        case x1+x2+x3+x4+x5+x6+x7+x8+x9..<x1+x2+x3+x4+x5+x6+x7+x8+x9+x10: // Partie hardcore
            stringToDisplay = "Partie hardcore"
            game = OneGame(gameTypeWithNoneCases: .square, n: 18, m: 18, z: 18, numberOfFlag: 18, isTimerAllowed: false, totalTime: 0, option1: true, option2: true, option1Time: 10, option2Frequency: 0.2, option3: true, option3Frequency: 0.2, option3Time: 5, noneCases: [], areNumbersShowed: true)
        default:
            fatalError("Problème dans la génération aléatoire ")
        }
        
        print("type de la partie: "+stringToDisplay)
        
        return game
    }
    
}
