//
//  PauseViewController.swift
//  DemineIt
//
//  Created by Marin on 23/06/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    var pausedGameViewController: UIViewController?
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.viewController(forIndex: 0),
                self.viewController(forIndex: 1),
                self.viewController(forIndex: 2),
                self.viewController(forIndex: 3),
                self.viewController(forIndex: 4)]
    }()
    
    /// OUTLETS
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var boutiqueView: UIView!
    @IBOutlet weak var boutiqueLabel: UILabel!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var lifeLabel: UILabel!
    
    
    /// FUNCTIONS
    
    func viewController(forIndex index: Int) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "articleViewController") as! ArticleViewController
        vc.articleIndex = index
        vc.pauseVC = self
        return vc
        
        
    }
    
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
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.frame //your view that have any objects
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = options.indexOfArticle
        
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
            controller.setViewControllers([self.viewController(forIndex: options.indexOfArticle)], direction: .forward, animated: false, completion: nil)
        }
        
    }
    
    func updateMoneyDisplay() {
        moneyLabel.text = String(money.currentAmountOfMoney)
    }
    
    func updateLivesDisplay() {
        lifeLabel.text = String(bonus.vie)
    }
    
    
    /// ACTIONS
    
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
            
            gameViewController.bonusChoiceView?.updateTheNumberLabels()
            
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
            
            
            gameViewController.bonusChoiceView?.updateTheNumberLabels()
            
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func restartButtonTapped(_ sender: Any) {
        if pausedGameViewController is InfiniteGameViewController {
            let gameViewController = pausedGameViewController as! InfiniteGameViewController
            gameViewController.gameTimer.stop()
            gameViewController.containerView.subviews.last?.removeFromSuperview()
            gameViewController.containerView.subviews.last?.removeFromSuperview()
            gameViewController.sectionIndex = 0
            gameViewController.restartTheGame()
            gameViewController.startNewSection()
        } else if pausedGameViewController is HistoryGameViewController {
            let gameViewController = pausedGameViewController as! HistoryGameViewController
            gameViewController.gameTimer.play()
            gameViewController.removePrecendentViewOfGame()
            gameViewController.startANewGame()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        // retour au menu
        if pausedGameViewController is InfiniteGameViewController {
            self.performSegue(withIdentifier: "BackToMenu", sender: nil)
        } else if pausedGameViewController is HistoryGameViewController {
            self.performSegue(withIdentifier: "BackToPresentation", sender: nil)
        }
        
    }
    
    @IBAction func vibrationButtonTapped(_ sender: Any) {
        options.areVibrationsOn = !options.areVibrationsOn // changer les vibrations
    }
    
    
}

extension PauseViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
        
        options.indexOfArticle = index
        pageControl.currentPage = index
        
    }
    
}
