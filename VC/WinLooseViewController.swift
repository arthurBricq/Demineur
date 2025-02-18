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
    
    
    // MARK: -  OUTLETS
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
    @IBOutlet weak var nextLevelIcon: NextLevelButton!
    @IBOutlet weak var amountOfBomsDescriptionLabel: UILabel!
    @IBOutlet weak var amountOfBombsFoundLabel: UILabel!
    @IBOutlet weak var coinsEarnedDescriptionLabel: UILabel!
    @IBOutlet weak var coinsEarnedLabel: UILabel!
    @IBOutlet weak var coinView: PieceView!
    @IBOutlet weak var constraintUnderNextLevelButton: NSLayoutConstraint!
    
    
    // MARK: - VARIABLES

    var win: Bool = false
    var didTapABomb: Bool = false
    var precedentViewController: UIViewController?
    var precedentGameIndex: Int = 1 // uniquement important pour le mode histoire
    var amountOfBombsFound: Int = 0
    
    
    // MARK: -  FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        menuIconButton.isUserInteractionEnabled = true
        replayIconButton.isUserInteractionEnabled = true
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var darkBlur = UIBlurEffect()
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffect.Style.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffect.Style.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.frame //your view that have any objects
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        transitioningDelegate = nil
        
        if win {
            updateWinDisplay()
        } else {
            updateLooseDisplay()
        }
        
        amountOfBombsFoundLabel.text = amountOfBombsFound.description
        coinsEarnedLabel.text = String(10*amountOfBombsFound)
        
    }
    
    
    /// pour actualiser la vue lorsque la partie est gagnée (uniquement en mode histoire)
    func updateWinDisplay() {
        // titleLabel.text = "GAGNE"
        // titleLabel.textColor = colorForRGB(r: 79, g: 143, b: 0)
        label.text = "Bien joué ! Vous avez trouvé toutes les bombes à temps."
        lastButton.isUserInteractionEnabled = true
        lastButton.isHidden = false
        lastButton.addTarget(self, action: #selector(nextLevel), for: .touchUpInside)
        nextLevelIcon.isHidden = false
        nextLevelIcon.addTarget(self, action: #selector(nextLevel), for: .touchUpInside)
        
    }

    /// pour actualiser la vue lorsque la partie est perdue (peut etre en mode histoire ou en mode infinie)
    func updateLooseDisplay() {
        // titleLabel.text = "PERDU"
        // titleLabel.textColor = colorForRGB(r: 148, g: 17, b: 0)
        
        lastButton.isUserInteractionEnabled = false
        lastButton.isHidden = true
        nextLevelIcon.isHidden = true
        nextLevelIcon.isUserInteractionEnabled = false
        constraintUnderNextLevelButton.constant = -lastButton.frame.height
        
        if didTapABomb {
            label.text = "Dommage ! Vous avez touché une bombe. "
            
        } else {
            label.text = "Dommage ! Le temps est écoulé."
            
        }
        
    }
    
    
    /// ACTIONS
    
    /// Pour retourner au menu
    @IBAction func menuButtonTapped(_ sender: Any) {
        if precedentViewController is InfiniteGameViewController {
            self.performSegue(withIdentifier: "BackToInfinitePresentation", sender: nil)
        } else if precedentViewController is HistoryGameViewController {
            self.performSegue(withIdentifier: "BackToHistoryPresentation", sender: nil)
        } else if precedentViewController is SuperPartiesGameViewController {
            self.performSegue(withIdentifier: "BackToSuperPartiesPresentation", sender: nil)
        }
    }
    
    /// Recommencer le niveau courrant
    @IBAction func rejouerButtonTapped(_ sender: Any) {
        
        if precedentViewController is InfiniteGameViewController {
            let gameViewController = precedentViewController as! InfiniteGameViewController
            gameViewController.restartTheGame()
        } else if precedentViewController is HistoryGameViewController {
            let gameViewController = precedentViewController as! HistoryGameViewController
            gameViewController.removePrecendentViewOfGame()
            gameViewController.startANewGame(animatedFromTheRight: false)
        } else if precedentViewController is SuperPartiesGameViewController {
            let gameViewController = precedentViewController as! SuperPartiesGameViewController
            gameViewController.restartTheGame()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Passer au niveau suivant, uniquement en mode histoire.
    @objc func nextLevel() {
        let gameViewController = precedentViewController as! HistoryGameViewController
        if precedentGameIndex == dataManager.currentHistoryLevel {
            dataManager.currentHistoryLevel += 1 // On débloque le niveau suivant
        }
        gameViewController.game = historyLevels[precedentGameIndex+1]
        gameViewController.gameIndex = precedentGameIndex + 1
        gameViewController.animateNextLevel()
        dismiss(animated: true, completion: nil)
    }
  
    
    /// Returns the x coordinates of position the letter E
    func getXPositionOfLetterE() -> CGFloat {
        return letterE.frame.origin.x
    }
    
    /// Returns the x coordinates of position the letter N
    func getXPositionOfLetterN() -> CGFloat {
        return letterN.frame.origin.x
    }
    
    /// Returns the x coordinates of position the letter D
    func getXPositionOfLetterD() -> CGFloat {
        return letterD.frame.origin.x
    }
    
    /// Returns the y coordinates of position the letters
    func getYPostionOfLetters() -> CGFloat {
        let y = letterE.frame.origin.y
        return y 
    }
    
}
