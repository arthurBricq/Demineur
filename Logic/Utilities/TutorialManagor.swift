//
//  TutorialManagor.swift
//  Demineur
//
//  Created by Arthur BRICQ on 01/07/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit


class TutorialManager {
    
    var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        if needsToShowTutorial() {
            displayTutorial()
        }
        
    }
    
    /// Returns true if the view controller needs to show an alert explaining the role of the view controller (self)
    private func needsToShowTutorial() -> Bool {
        switch viewController {
        case is MenuViewController:
            return hasKeyExistBefore(key: "MenuViewControllerLunch")
        case is HistoryPresentationViewController:
            return hasKeyExistBefore(key: "HistoryPresentationViewControllerLunch")
        case is InfinitePresentationViewController:
            return hasKeyExistBefore(key: "InfinitePresentationViewControllerLunch")
        default:
            return false
        }
        
    }
    
    
    
    private func displayTutorial() {
        switch viewController {
        case is MenuViewController: handleMenuVC()
        case is HistoryPresentationViewController: handleHistoryPresentatioonVC()
        case is InfinitePresentationViewController: handleInfinitePresentationVC()
        default:
            break
        }
    }
    
    
    /// Reset all the keys in order to re-have the tutorial presented on screen.
    static func resetInteractiveTutorial() {
        UserDefaults.standard.set(false, forKey: "MenuViewControllerLunch")
        UserDefaults.standard.set(false, forKey: "HistoryPresentationViewControllerLunch")
        UserDefaults.standard.set(false, forKey: "InfinitePresentationViewControllerLunch")
    }
    
    /// Returns true if user defaults doesn't contains already the given key. It means it's the first time that the key is passed as parameter
    fileprivate func hasKeyExistBefore(key: String) -> Bool {
        let hasLunchBefore = UserDefaults.standard.bool(forKey: key)
        if !hasLunchBefore {
            UserDefaults.standard.set(true, forKey: key)
        }
        return !hasLunchBefore
    }
    
    // MARK: - Private functions used for tutorials
    
    private func handleMenuVC() {
        self.viewController.displayRoundBox(title: "Hello", withMessage: "Welcome into our game.\nYou can play 3 different modes, the 'History Mode', the 'Infinite Party Mode' and the 'Super Party Mode'", buttonNames: ["Ok !"], buttonActions: [{
            print("Got It...")
            }], backgroundColor: .white, delay: 0.7)
    }
    
    private func handleHistoryPresentatioonVC() {
        self.viewController.displayRoundBox(title: "History Mode", withMessage: "This mode has 100 levels to complete. \nWe, the bricq brothers, dare you to finish them all ! It's a long path through bombs and difficulties. Good luck and may the force be with you... ", buttonNames: ["Let's see about that !"], buttonActions: [{
            
            // Second message
            self.viewController.displayRoundBox(title: "The game", withMessage: "The principle of the game is easy. There is a grid of cases, some of them contains bomb. You must mark all the bombs by flags. \nJust like minesweeper !", buttonNames: ["Ok. What's next ?"], buttonActions: [{
                
                
                
                }])
            
            }])
    }
    
    private func handleInfinitePresentationVC() {
        self.viewController.displayRoundBox(title: "Infinite Party", withMessage: "In this mode, the game never stops and you will have to die. \nThe question is, how long can you stand ?", buttonNames: ["Got it."], buttonActions: [{
            //
            }], delay: 0.2)
    }
    
    

}
