//
//  WinLooseViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 23/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class WinLooseViewController: UIViewController {

    /// OUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lastButton: UIButton!
    
    
    /// VARIABLES

    var win: Bool = false
    var precedentViewController: UIViewController?
    
    
    
    
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
    
    
    /// pour actualiser la vue lorsque la partie est gagnée
    func updateWinDisplay() {
        titleLabel.text = "GAGNE"
        // titleLabel.textColor = colorForRGB(r: 79, g: 143, b: 0)
        label.text = "Bien joué ! Vous avez trouvé toutes les bombes à temps."
        lastButton.isUserInteractionEnabled = true
        lastButton.isHidden = false
    
    }

    /// pour actualiser la vue lorsque la partie est perdue
    func updateLooseDisplay() {
        titleLabel.text = "PERDU"
        // titleLabel.textColor = colorForRGB(r: 148, g: 17, b: 0)
        label.text = "Dommage ! Le temps est écoulé."
        lastButton.isUserInteractionEnabled = false
        lastButton.isHidden = true
    
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if precedentViewController is InfiniteGameViewController {
            self.performSegue(withIdentifier: "BackToMenu", sender: nil)
        } else if precedentViewController is HistoryGameViewController {
            self.performSegue(withIdentifier: "BackToPresentation", sender: nil)
        }
    }
    
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
    
    @IBAction func nextLevelButtonTapped(_ sender: Any) {
        menuButtonTapped(sender)
        
        
        
        
        
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
