//
//  SuperPartieGame.swift
//  Demineur
//
//  Created by Arthur BRICQ on 05/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit
import CoreData

/**
 This class is the representation of one game onto CD. It is used to restaure the game exactly at the same state as it was when the user left it last time.
 */
class SuperPartieGame: NSManagedObject {
    public func setUpGame(viewOfGame: ViewOfGame, level: Int ) {
        
        // 1. Save the informations about the map
        if let game = viewOfGame.game {
            print("Is now filling the data")
            self.n = Int32(game.n)
            self.m = Int32(game.m)
            self.z = Int32(game.z)
            self.level = Int32(level)
            self.numberOfRemainingFlags = Int32(viewOfGame.numberOfRemainingFlags)
            self.gameType = game.gameType.rawValue
        }
        
        // TODO: save the non-cases of the application (it might be done by the gamestate ? IDK... But I think it's fine, I'll need to double-check)
        
        // 2. Save all the cases (position, state & gameState)
        for row in viewOfGame.cases {
            for cell in row {
                let savedCase = SavedCase(context: AppDelegate.viewContext)
                savedCase.setUp(case: cell)
                self.addToCases(savedCase)
            }
        }
    }
    
    /// Returns the view of game retrieving the game at the correct state. 
    public func getViewOfGame(scrollViewDimension: CGSize) -> ViewOfGame? {
        
        // 1. Obtain all the case states and the game state
        
        // Create the array cases and initialise it with the correct number of rows
        var cases = [[SavedCase]].init()
        for _ in 0..<n {
            cases.append([])
        }
        
        if let savedCases = getSavedCases() {
            // Position all the cases in their right row
            for c in savedCases {
                let i = Int(c.i)
                cases[i].append(c)
            }
            
            // Sort all the rows by their column
            for i in 0..<cases.count {
                cases[i].sort { (c1, c2) -> Bool in
                    c1.j < c2.j
                }
            }
            
            // (Now, the array cases is sorted like it was before being saved)
            // 2.a) Obtain all the case states
            let allCaseStates = cases.map { (row) -> [CaseState] in
                return row.map({ (savedCase) -> CaseState in
                    return CaseState(rawValue: savedCase.caseState)!
                })
            }
        
            // 2.b) Obtain the gamestate
            var gameState = cases.map { (row) -> [Int] in
                return row.map({ (savedCase) -> Int in
                    return Int(savedCase.gameStateValue)
                })
            }
           
            // 2.c) Obtain the noncases
            // TODO (inspect the array gameStates, maybe it's useless to include now that party is created)
            let nonCases: [(i: Int, j: Int)] = []
            
            // TODO: number of flags
            
            // 3. Obtain the game
            let oneGame = OneGame(gameTypeWithNoneCases: GameType(rawValue: self.gameType)!, n: Int(n), m: Int(m), z: Int(z), numberOfFlag: Int(numberOfRemainingFlags), isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0.0, option2Frequency: 0, option3: false, option3Frequency: 0, option3Time: 0, noneCases: nonCases, areNumbersShowed: true)
            oneGame.colors = ColorSetForOneGame(openColor: Color.rgb(192, 197, 206) , emptyColor: UIColor.white, strokeColor: Color.rgb(52, 61, 70), textColor: Color.rgb(52, 61, 70))
            
            // LAST. Obtain the view of game object
            let type = GameType(rawValue: gameType)!
            var viewOfGame: ViewOfGame?
            switch type {
            case .square: viewOfGame = SquareViewOfGame(restauredGame: oneGame, gameState: &gameState, allCaseStates: allCaseStates, scrollViewDimension: scrollViewDimension)
            case .hexagonal: viewOfGame = HexViewOfGame(restauredGame: oneGame, gameState: &gameState, allCaseStates: allCaseStates, scrollViewDimension: scrollViewDimension)
            case .triangular: viewOfGame = TriangleViewOfGame(restauredGame: oneGame, gameState: &gameState, allCaseStates: allCaseStates, scrollViewDimension: scrollViewDimension)
            }
            
            
            return viewOfGame
        } else {
            return nil
        }
        
        
        
    }
    
    /// This function returns the array of all saved cases, if it exist. Else, it returns nil
    private func getSavedCases() -> [SavedCase]? {
        if let cases = self.cases {
            return cases.map { (a) -> SavedCase in
                return a as! SavedCase
            }
        } else {
            return nil
        }
    }
    
    static func deleteAllRecords() {
        let request: NSFetchRequest<SuperPartieGame> = SuperPartieGame.fetchRequest()
        do {
            let games = try AppDelegate.viewContext.fetch(request)
            print("Number of records: \(games.count)")
            for g in games {
                AppDelegate.viewContext.delete(g)
            }
        } catch {
            print("Error fecthing games from CD: \(error)")
        }
    }
    
    
}
