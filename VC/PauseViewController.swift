//
//  PauseViewController.swift
//  DemineIt
//
//  Created by Marin on 23/06/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {
    
    // MARK: - Variables
    override var prefersStatusBarHidden: Bool { return true }
    var pausedGameViewController: UIViewController?
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.viewController(forIndex: 0),
                self.viewController(forIndex: 1),
                self.viewController(forIndex: 2),
                self.viewController(forIndex: 3),
                self.viewController(forIndex: 4)]
    }()
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var boutiqueView: UIView!
    @IBOutlet weak var boutiqueLabel: UILabel!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var pieceView: PieceView!
    
    
    // MARK: - FUNCTIONS
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let radius: CGFloat = 10.0
        pauseView.layer.cornerRadius = radius
        pauseView.layer.borderWidth = 0.75
        pauseView.layer.borderColor = UIColor.gray.cgColor
        boutiqueView.layer.cornerRadius = radius-2
        boutiqueView.layer.borderWidth = 0.75
        boutiqueView.layer.borderColor = UIColor.gray.cgColor
        
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
        
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = dataManager.indexOfSelectedBonusInPauseVC
        
        updateMoneyDisplay()
        updateLivesDisplay()
        
        
        }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pageSegue", let controller = segue.destination as? UIPageViewController {
            controller.delegate = self
            controller.dataSource = self
            controller.setViewControllers([self.viewController(forIndex: dataManager.indexOfSelectedBonusInPauseVC)], direction: .forward, animated: false, completion: nil)
        }
        
    }
    
    func updateMoneyDisplay() {
        moneyLabel.text = String(dataManager.money)
    }
    
    func updateLivesDisplay() {
        lifeLabel.text = String(dataManager.vieQuantity)
    }
    
    
    // MARK: - ACTIONS
    
    @IBAction func returnButtonTapped(_ sender: Any) {
                
        if pausedGameViewController is InfiniteGameViewController {
            let gameViewController = pausedGameViewController as! InfiniteGameViewController
            gameViewController.gameTimer.play()
            let currentGameView = gameViewController.containerView.subviews.last as! ViewOfGame
            currentGameView.option3Timer.play()
            currentGameView.unPauseAllOption1Timers()
            gameViewController.bonusChoiceView?.updateTheNumberLabels()
         
        } else if pausedGameViewController is HistoryGameViewController {
            let gameViewController = pausedGameViewController as! HistoryGameViewController
            gameViewController.gameTimer?.play()
            gameViewController.viewOfGame?.option3Timer.play()
            gameViewController.viewOfGame?.unPauseAllOption1Timers()
            gameViewController.bonusChoiceView?.updateTheNumberLabels()
        } else if pausedGameViewController is SuperPartiesGameViewController {
            let gameViewController = pausedGameViewController as! SuperPartiesGameViewController
            
            /*
            if gameViewController.game!.gameType == .square {
                gameViewController.viewOfGameSquare?.option3Timer.play()
                gameViewController.viewOfGameSquare?.unPauseAllOption1Timers()
            } else if gameViewController.game!.gameType == .hexagonal {
                gameViewController.viewOfGameHex?.option3Timer.play()
                gameViewController.viewOfGameHex?.unPauseAllOption1Timers()
            } else if gameViewController.game!.gameType == .triangular {
                gameViewController.viewOfGameTriangular?.option3Timer.play()
                gameViewController.viewOfGameTriangular?.unPauseAllOption1Timers()
            }
             */
            
        }
        
        
        
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func restartButtonTapped(_ sender: Any) {
        
        if pausedGameViewController is InfiniteGameViewController {
            let gameViewController = pausedGameViewController as! InfiniteGameViewController
            gameViewController.restartTheGame()
        } else if pausedGameViewController is HistoryGameViewController {
            let gameViewController = pausedGameViewController as! HistoryGameViewController
            gameViewController.gameTimer?.play()
            gameViewController.removePrecendentViewOfGame()
            gameViewController.startANewGame(animatedFromTheRight: false)
        } else if pausedGameViewController is SuperPartiesGameViewController {
            let gameViewController = pausedGameViewController as! SuperPartiesGameViewController
            gameViewController.restartTheGame()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        
        // retour au menu
        
        if pausedGameViewController is InfiniteGameViewController {
            self.performSegue(withIdentifier: "BackToInfinitePresentation", sender: nil)
        } else if pausedGameViewController is HistoryGameViewController {
            self.performSegue(withIdentifier: "BackToHistoryPresentation", sender: nil)
        } else if pausedGameViewController is SuperPartiesGameViewController {
            (pausedGameViewController as! SuperPartiesGameViewController).saveGameToCoreData()
            self.performSegue(withIdentifier: "BackToSuperPartiesPresentation", sender: nil)
        }
    
    }
    
    @IBAction func vibrationButtonTapped(_ sender: Any) {
        dataManager.isVibrationOn = !dataManager.isVibrationOn // changer les vibrations
    }
    
    
}

// MARK: - Gère le PageViewController
extension PauseViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private func viewController(forIndex index: Int) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "articleViewController") as! ArticleViewController
        vc.articleIndex = index
        vc.pauseVC = self
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? ArticleViewController else {
            return nil
        }
        
        let index = vc.articleIndex // c'est l'index du vc d'avant
        
        
        guard orderedViewControllers.count > index else {
            return nil
        }
        
        guard index-1 > -1 else {
            return nil
        }
        
        return orderedViewControllers[index-1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vc = viewController as? ArticleViewController else {
            return nil
        }
        
        let index = vc.articleIndex
        
        guard orderedViewControllers.count > index+1 else {
            return nil
        }
        
        guard index < orderedViewControllers.count else {
            return nil
        }
        
        return orderedViewControllers[index+1]
    }
    
  
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        guard let vc = pageViewController.viewControllers![0] as? ArticleViewController else {
            return
        }
        let index = vc.articleIndex
        
        dataManager.indexOfSelectedBonusInPauseVC = index
        pageControl.currentPage = index
        
    }
    
}
