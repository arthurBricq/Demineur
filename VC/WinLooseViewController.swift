//
//  WinLooseViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 23/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/// Ce VC est appelé en fin de partie, quand l'utilisateur termine un niveau ou bien quand l'utilisateur meurt à cause du temps fini ou à cause du nombre de bombes.
class WinLooseViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { return true }
    
    
    /// OUTLETS
    // @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: LineView!
    @IBOutlet weak var letterE: Letter!
    @IBOutlet weak var letterN: Letter!
    @IBOutlet weak var letterD: Letter!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuIconButton: MenuPauseIconsButtons!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var replayIconButton: MenuPauseIconsButtons!
    @IBOutlet weak var lastButton: UIButton!
    
    
    /// VARIABLES

    var win: Bool = false
    var didTapABomb: Bool = false
    var precedentViewController: UIViewController?
    var precedentGameIndex: Int = 1 // uniquement important pour le mode histoire
    
    
    
    /// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        menuIconButton.isUserInteractionEnabled = true
        replayIconButton.isUserInteractionEnabled = true
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        transitioningDelegate = nil
        
        var darkBlur = UIBlurEffect()
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.frame //your view that have any objects
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        
        
        
        if win {
            updateWinDisplay()
        } else {
            updateLooseDisplay()
        }
        
        
    }
    
    
    /// pour actualiser la vue lorsque la partie est gagnée (uniquement en mode histoire)
    func updateWinDisplay() {
        // titleLabel.text = "GAGNE"
        // titleLabel.textColor = colorForRGB(r: 79, g: 143, b: 0)
        label.text = "Bien joué ! Vous avez trouvé toutes les bombes à temps."
        lastButton.isUserInteractionEnabled = true
        lastButton.isHidden = false
        lastButton.addTarget(self, action: #selector(nextLevel), for: .touchUpInside)
    
    }

    /// pour actualiser la vue lorsque la partie est perdue (peut etre en mode histoire ou en mode infinie)
    func updateLooseDisplay() {
        // titleLabel.text = "PERDU"
        // titleLabel.textColor = colorForRGB(r: 148, g: 17, b: 0)
        
        if didTapABomb {
            label.text = "Dommage ! Vous avez touchez une bombe. "
            lastButton.isUserInteractionEnabled = true
            lastButton.isHidden = true
        } else {
            label.text = "Dommage ! Le temps est écoulé."
            lastButton.isUserInteractionEnabled = false
            lastButton.isHidden = true
        }
        
    }
    
    
    /// ACTIONS
    
    /// Pour retourner au menu
    @IBAction func menuButtonTapped(_ sender: Any) {
        if precedentViewController is InfiniteGameViewController {
            self.performSegue(withIdentifier: "BackToMenu", sender: nil)
        } else if precedentViewController is HistoryGameViewController {
            self.performSegue(withIdentifier: "BackToPresentation", sender: nil)
        }
    }
    
    /// Recommencer le niveau courrant
    @IBAction func rejouerButtonTapped(_ sender: Any) {
        if precedentViewController is InfiniteGameViewController {
            let gameViewController = precedentViewController as! InfiniteGameViewController
            gameViewController.restartTheGame()
        } else if precedentViewController is HistoryGameViewController {
            let gameViewController = precedentViewController as! HistoryGameViewController
            gameViewController.gameTimer.play()
            gameViewController.removePrecendentViewOfGame()
            gameViewController.startANewGame()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Passer au niveau suivant, uniquement en mode histoire
    @objc func nextLevel() {
        let gameViewController = precedentViewController as! HistoryGameViewController
        gameViewController.game = historyLevels[precedentGameIndex+1]
        
        if precedentGameIndex == gameData.currentLevel {
            gameData.currentLevel += 1 // On débloque le niveau suivant 
        }
        
        gameViewController.gameIndex = precedentGameIndex + 1
        gameViewController.gameTimer.play()
        gameViewController.removePrecendentViewOfGame()
        gameViewController.startANewGame()
        self.dismiss(animated: true, completion: nil)
    }
  
    
    
    // NAVIGATIONS

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        
        
    }
    

}
