//
//  SuperPartiesGameViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 30/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.


import UIKit

/// This is used when presenting a game that can be really big and that must be saved when leaving the application.
/// The saving process uses 'SuperPartieGame' as saver class, and use ViewOfGame to retrieve the game in its last position. 
class SuperPartiesGameViewController: GameViewController {
    
    /// This variable is the CD object keeping this game. If there is no saved game from before, it will be nil.
    var savedGame: SuperPartieGame?
    
    // TODO : delete the saved game when the party is finished.
    
    // MARK: - new functions
    
    public func restartTheGame() {
        isTheGameStarted.delegate = self 
        self.removePrecendentViewOfGame()
        self.deleteTheGameFromCoreData()
        self.startANewGame(animatedFromTheRight: false)
    }
    
    /// This function save the current game to CD
    public func saveGameToCoreData() {
        // TODO: save the current state of the game to CD
        print("Is saving the game to CD !")
        // 1. Delete the precedent game
        if savedGame != nil {
            deleteTheGameFromCoreData()
        }
        
        // 2. Create the new one and set it up using the view of game. 
        let game = SuperPartieGame(context: AppDelegate.viewContext)
        game.setUpGame(viewOfGame: self.viewOfGame!, level: self.gameIndex)
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print("ERROR: coudn't save CD: \(error)")
        }
        
    }
    
    public func deleteTheGameFromCoreData() {
        print("Is deleting the game from CD")
        if let sg = self.savedGame {
            AppDelegate.viewContext.delete(sg)
        }
        savedGame = nil 
    }
    
    // MARK: - Overriden functions
    
    override func setUpLabelsForNewGame() {
        // instauration des drapeaux et des bombes sur l'écran
        if !game.areNumbersShowed {
            flagsLabel.isHidden = true
            flagView.isHidden = true
            bombsLabel.isHidden = true
            bombView.isHidden = true
        } else {
            flagsLabel.isHidden = false
            flagView.isHidden = false
            bombsLabel.isHidden = false
            bombView.isHidden = false
        }
    }
    
    override func getNewViewOfGame() -> ViewOfGame? {
        if savedGame == nil {
            print("New game to be created")
            return super.getNewViewOfGame()
        } else {
            print("Is constructing the correct view of game for this existing level.")
            isTheGameStarted.value = true 
            let vog = self.savedGame!.getViewOfGame(scrollViewDimension: scrollView.frame.size)
            self.game = vog!.game!
            return vog
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if savedGame != nil {
            isTheGameStarted.value = true 
            isTheGameStarted.delegate = nil
        }
    }
    
    
}
