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

    /// OUTLETS
    // @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lastButton: UIButton!
    
    
    /// VARIABLES

    var win: Bool = false
    var didTapABomb: Bool = false
    var precedentViewController: UIViewController?
    var precedentGameIndex: Int = 1
    
    
    
    /// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
            lastButton.isHidden = false
            lastButton.setTitle("NOUVELLE CHANCE", for: .normal)
            lastButton.addTarget(self, action: #selector(newChance), for: .touchUpInside)
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
            gameViewController.gameTimer.stop()
            gameViewController.containerView.subviews.last?.removeFromSuperview()
            gameViewController.containerView.subviews.last?.removeFromSuperview()
            gameViewController.sectionIndex = 0
            gameViewController.restartTheGame()
            gameViewController.startNewSection()
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
        print("passer au niveau suivant")
        self.performSegue(withIdentifier: "GoToNextLevel", sender: nil)
    }
    
    /// Pour continuer avec une vie en moins
    @objc func newChance() {
        print("continuer la partie")
    }
    
    
    // NAVIGATIONS

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.destination {
        case is HistoryGameViewController:
            let dest = segue.destination as! HistoryGameViewController
            if segue.identifier! == "GoToNextLevel" {
                dest.game = historyLevels[precedentGameIndex+1]
            }
        default:
            break
        }
        
        
    }
    

}
