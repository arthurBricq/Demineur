//
//  PauseViewController.swift
//  DemineIt
//
//  Created by Marin on 23/06/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {
    
    var pausedGameViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        
        if pausedGameViewController is InfiniteGameViewController {
            let gameViewController = pausedGameViewController as! InfiniteGameViewController
            gameViewController.gameTimer.play()
            
            let currentGameView = gameViewController.containerView.subviews[gameViewController.containerView.subviews.count-1]
            if currentGameView is ViewOfGameSquare {
                let squareView = currentGameView as! ViewOfGameSquare
                squareView.option3Timer.play()
            } else if currentGameView is ViewOfGame_Hex {
                let hexView = currentGameView as! ViewOfGame_Hex
                hexView.option3Timer.play()
            } else if currentGameView is ViewOfGameTriangular {
                let triangularView = currentGameView as! ViewOfGameTriangular
                triangularView.option3Timer.play()
            }
            
        } else if pausedGameViewController is HistoryGameViewController {
            let gameViewController = pausedGameViewController as! HistoryGameViewController
            gameViewController.gameTimer.play()
            
            if gameViewController.game.gameType == .square {
                gameViewController.viewOfGameSquare?.option3Timer.play()
            } else if gameViewController.game.gameType == .hexagonal {
                gameViewController.viewOfGameHex?.option3Timer.play()
            } else if gameViewController.game.gameType == .triangular {
                gameViewController.viewOfGameTriangular?.option3Timer.play()
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var darkBlur = UIBlurEffect()
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.frame //your view that have any objects
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
