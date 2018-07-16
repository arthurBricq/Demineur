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
                self.viewController(forIndex: 3)]
    }()
    
    
    
    /// OUTLETS
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var boutiqueView: UIView!
    @IBOutlet weak var boutiqueLabel: UILabel!
    
    /// FUNCTIONS
    
    func viewController(forIndex index: Int) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "articleViewController") as! ArticleViewController
        vc.articleIndex = index
        return vc
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let radius: CGFloat = 10.0
        pauseView.layer.cornerRadius = radius
        boutiqueView.layer.cornerRadius = radius-2
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
        
        pageControl.isUserInteractionEnabled = false
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pageSegue", let controller = segue.destination as? UIPageViewController {
            controller.delegate = self
            controller.dataSource = self
            controller.setViewControllers([self.viewController(forIndex: 0)], direction: .forward, animated: false, completion: nil)
        }
        
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
        
        pageControl.currentPage = index
    }
    
}










/**
 This function should add a view inside a UISCROLLVIEW
 */
//    func test() {
//        let view = UIView(frame: CGRect(x: 0, y: 30, width: 500, height: 20))
//        view.backgroundColor = UIColor.red
//        scrollView.addSubview(view)
// }


/**
 Cette fonction permet d'ajouter tous les boutons dans le scroll view de la boutique rapide dans le menu pause.
 */
//    func instantiateBoutiqueScrollView() {
//        let h = scrollView.frame.height
//        let b1 = UIButton(frame: CGRect(x: 0, y: 0, width: h, height: h))
//        b1.setTitle("m1", for: .normal)
//        b1.layer.borderWidth = 1.0
//        b1.layer.borderColor = UIColor.white.cgColor
//
//        let b2 = UIButton(frame: CGRect(x: h+20, y: 0, width: h, height: h))
//        b2.setTitle("m2", for: .normal)
//        b2.layer.borderWidth = 1.0
//        b2.layer.borderColor = UIColor.white.cgColor
//
//        let b3 = UIButton(frame: CGRect(x: 2*(h+20), y: 0, width: h, height: h))
//        b3.setTitle("m3", for: .normal)
//        b3.layer.borderWidth = 1.0
//        b3.layer.borderColor = UIColor.white.cgColor
//
//        scrollView.addSubview(b1)
//        scrollView.addSubview(b2)
//        scrollView.addSubview(b3)
//    }
