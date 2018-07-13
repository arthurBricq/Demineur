//
//  StarterFunctions.swift
//  DemineIt
//
//  Created by Marin on 04/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import Foundation
import UIKit

// ------------------------------- TRIANGULAR ---------------------------------
/**
 Cette fonction retourne les dimensions de la vue pour une partie triangulaire.
 */
func dimensionTriangularTable(n: Int, m: Int, maxW: CGFloat, maxH: CGFloat) -> (w: CGFloat, h: CGFloat) {
    
    /// Case 1 : le favoris
    let w1 = maxW
    // à partir de w, on doit trouver a, h
    let a1 = m%2==0 ? w1*2/CGFloat(m) : w1*2/CGFloat(m+1)
    // Normalement, on doit avoir que m%2 == 1, mais je fais dans les deux pour si on doit faire des visuelles différents de personnalisation.
    let h1 = sqrt(3) * a1/2 * CGFloat(n)
    
    /// Case 2 : lorsqu'on doit choisir la hauteur et pas la largeur.
    let h2 = maxH
    let a2 = 2*h2 / (sqrt(3)*CGFloat(n))
    let w2 = m%2==0 ? CGFloat(m)*a2/2 : CGFloat(m+1)*a2/2
    
    if h1 < maxH {
        return (w1,h1)
    } else if w2 < maxW {
        return (w2,h2)
    } else {
        return (0,0)
    }
}

func createNumbersToDisplayTriangle(in gameState: inout [[Int]]) {
    
    func numberOfBombAround(_ i: Int, _ j: Int) -> Int {
        var nbOfBomb: Int = 0
        
        
        let minI = i - 1
        let maxI = i + 1
        let minJ = j - 2
        let maxJ = j + 2
        
        for a in minI...maxI {
            for b in minJ...maxJ {
                if a >= 0 && a < gameState.count && b >= 0 && b < gameState[0].count
                {
                    
                    switch triangularButtonIsOfType(i: i, j: j) {
                    case 1:
                        if a == i+1 && (b == j-2 || b == j+2) { continue }
                        else if gameState[a][b] == -1 { nbOfBomb += 1 }
                    case 2:
                        if a == i-1 && (b == j-2 || b == j+2) { continue }
                        else if gameState[a][b] == -1 { nbOfBomb += 1 }
                    default:
                        break
                    }
                }
            }
        }
        
        return nbOfBomb
    }
    
    for i in 0..<gameState.count {
        for j in 0..<gameState[0].count {
            if gameState[i][j] >= 0 {
                gameState[i][j] = numberOfBombAround(i, j)
            }
        }
    }
}

// --------------------------------- HEXAGON ---------------------------------

/**
 Input : n = nombre de lignes ; m = nombre de colonne ; maxW = largeur maximale ; maxH = hauteur maximale à utiliser.
 Output : la fonction retourne un tuple (w,h) des dimensions que doit prendre la vue du jeu hexagonal. Le VC s'occupe alors de centrer la vue à partir de ces dimensions.
 
 Methode : la cas favorable est de remplir intégralement la largeur.
 */
func dimensionHexTable(n: Int, m: Int, maxW: CGFloat, maxH: CGFloat) -> (w: CGFloat, h: CGFloat) {
    
    // soit a le côté unité des cases.
    // Pour une case : w = sqrt(3)*a    et     h = 2*a
    
    let maxWOfOneCase = maxW/CGFloat(m)
    
    let w1 = maxW
    let a1 = maxWOfOneCase/sqrt(3)
    let h1 = CGFloat(n)*a1*1.5
    
    return (w1,h1)
    
}


/**
 Hexagone : Cette fonction permet d'initialiser le tableau gameState avec uniquement des 0.
 Ce tableau ressemble à n lignes, ou chaque lignes comporte m ou (m-1) elements les uns après les autres.
 */
func createEmptyHexGameState(n: Int,m: Int) -> [[Int]]
{
    var toReturn = [[Int]].init()
    
    for i in 0..<n {
        var TMP = [Int].init()
        
        if i%2 == 0 {
            for _ in 0..<m {
                TMP.append(0)
            }
        } else {
            for _ in 0..<(m-1) {
                TMP.append(0)
            }
        }
        
        toReturn.append(TMP)
    }
    
    return toReturn
}

/**
 Hexagone : Pour tous les élements du tableau, on vérifie si ce sont des cases vides.
 Si ce sont des cases vides, alors on met un -2 à la place du 0
 */
func positionNoneCaseHex(noneCases: [(i: Int,j: Int)], gameState: inout [[Int]] ) {
    
    
    for i in 0..<gameState.count {
        for j in 0..<gameState[i].count {
            
            
            if noneCases.contains(where: { (a,b) -> Bool in
                return a == i && b == j
            })
            { // la case doit être changé
                gameState[i][j] = -2
            }
        }
    }
}

/**
 Hexagone : Cette fonction pose les Z bombes sur la carte comme il le faut.
 Contrainte à respecter : on donne une case (x,y) qui représente là où l'utilisateur a tapé la première fois. Il faut créer une table de jeu où cette case n'est pas prise.
 */
func positionBombsHex(gameState: inout [[Int]], z: Int, withFirstTouched touch: (x: Int, y: Int))
{
    var remainingBombsToPlace: Int = z
    let n = gameState.count
    
    while remainingBombsToPlace > 0
    {
        
        let newPosX = random(n)
        let newPosY = random(gameState[newPosX].count)
        
        if newPosX == touch.x && newPosY == touch.y { continue }
        
        if gameState[newPosX][newPosY] != -2 && gameState[newPosX][newPosY] != -1 {
            gameState[newPosX][newPosY] = -1 // on rajoute une bombe.
            remainingBombsToPlace -= 1
        }
        
    }
    
}
/**
 Hexagone : Cette fonction est appelée après que les bombes et les trous ont été placés, puis retourne pour chaque case le numéro qu'il lui est associé.
 */
func createNumbersToDisplayHex(gameState: inout [[Int]])
{
    let n = gameState.count
    let m = gameState[0].count
    let minI = 0
    let minJ = 0
    let maxI = n
    
    func findNumberAtCase(i: Int, j: Int) -> Int {
        var compteur: Int = 0
        for a in (i-1)...(i+1) {
            for b in (j-1)...(j+1) {
                
                // il y a deux cas : ou bien i est paire ou bien i est impaire
                if i%2 == 0 { // il y m elements dans la ligne.
                    if a != i && b == (j+1) { continue }
                } else {
                    if b == (j-1) && a != i { continue }
                }
                
                if a >= 0 && a<maxI {
                    let maxJ = gameState[a].count
                    if b>=0 && b<maxJ {
                        if gameState[a][b] == -1 { compteur += 1 }
                    }
                }
                
            }
        }
        return compteur
    }
    
    for i in 0..<n {
        for j in 0..<gameState[i].count {
            if gameState[i][j] >= 0 {
                gameState[i][j] = findNumberAtCase(i: i, j: j)
            }
        }
    }
    
    
}


// --------------------------------- SQUARE ---------------------------------
/** Cette fonction doit retourner les dimensions de la vue à utiliser, selon le nombre de colonne ou de lignes.
 Il se passe forcément un des deux cas suivant :
 1) la contrainte est la largeur (cas 1)
 2) la contrainte est la hauteur (cas 2)
 */
func dimensionSquareTable(n: Int, m: Int, withMaximumWidth maximumWidth: CGFloat, withMaximumHeight maximumHeight: CGFloat) -> (w: CGFloat, h: CGFloat) {
    
    // Case 1
    let a1 = maximumWidth/CGFloat(m) // le cote
    let w1 = maximumWidth
    let h1 = CGFloat(n) * a1
    
    return (w1,h1)
}

/// Square : Fill a table with 0.
/// - parameter n : Number of lines
/// - parameter m : Number of columns
/// - parameter gameState : Table to fill, all its past values are removed.
func createEmptySquareGameState(n: Int, m: Int) -> [[Int]] {
    var emptyGameState = [[Int]].init()
    
    for _ in 0..<n {
        var line = [Int].init()
        for _ in 0..<m {
            line.append(0)
        }
        emptyGameState.append(line)
    }
    
    return emptyGameState
}

/// Square : Remplit le gameState en paramètre de -2 aux positions données.
func positionNoneCaseSquare(noneCases: [(Int, Int)], in gameState: inout [[Int]]) {
    for i in 0..<gameState.count {
        for j in 0..<gameState[0].count {
            if noneCases.contains(where: { (a, b) -> Bool in
                return (a == i && b == j)
            }) {
                gameState[i][j] = -2
            }
        }
    }
}

/// Square : Choisit des positions pour les bombes aléatoires.
func positionBombsSquare(in gameState: inout [[Int]], numberOfBombs z: Int, withFirstTouched touch: (x: Int, y: Int)) {
    var x: Int
    var y: Int
    var nbOfBombsRemaining: Int = z
    
    while nbOfBombsRemaining > 0 {
        repeat {
            x = random(gameState.count)
            y = random(gameState[0].count)
        } while (gameState[x][y] != 0)
        
        if x == touch.x && y == touch.y {
            continue
        } else {
            gameState[x][y] = -1
            nbOfBombsRemaining -= 1
        }
    }
}

/// Remplit le gameState des numéros corrects pour chaque case.
func createNumbersToDisplaySquare(in gameState: inout [[Int]]) {
    
    func numberOfBombAround(_ i: Int, _ j: Int, in gameState: [[Int]]) -> Int {
        var nbOfBomb: Int = 0
        
        let minX = i - 1
        let maxX = i + 1
        let minY = j - 1
        let maxY = j + 1
        
        for a in minX...maxX {
            for b in minY...maxY {
                if a >= 0 && a < gameState.count && b >= 0 && b < gameState[0].count {
                    if gameState[a][b] == -1 {
                        nbOfBomb += 1
                    }
                }
            }
        }
        
        return nbOfBomb
    }
    
    for i in 0..<gameState.count {
        for j in 0..<gameState[0].count {
            if gameState[i][j] >= 0 {
                gameState[i][j] = numberOfBombAround(i, j, in: gameState)
            }
        }
    }
}
