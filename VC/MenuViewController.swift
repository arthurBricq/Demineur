//
//  MenuViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 06/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var lineE: LineView!
    @IBOutlet weak var lineHeight: NSLayoutConstraint!
    @IBOutlet weak var mainLine: LineView!
    @IBOutlet weak var mainLineLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lineHeight.constant = 110 + 5*40 + 4*15
        
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is HistoryPresentationViewController || segue.destination is BoutiqueViewController || segue.destination is InfinitePresentationViewController {
            segue.destination.transitioningDelegate = self
        }
        
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        // retour au menu
    }
    
}

extension MenuViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented is HistoryPresentationViewController {
            let transition = TransitionToHistoryPresentationViewController()
            transition.animationDuration = 1.5
            transition.presenting = true
            return transition
        } else if presented is InfinitePresentationViewController {
            let transition = TransitionToInfinitePresentationViewController()
            transition.animationDuration = 1.5
            transition.presenting = true
            return transition
        } else if presented is BoutiqueViewController {
            let transition = TransitionToBoutique()
            transition.animationDuration = 1.5
            transition.presenting = true
            return transition
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is HistoryPresentationViewController {
            let transition = TransitionToHistoryPresentationViewController()
            transition.animationDuration = 1.5
            transition.presenting = false
            return transition
        } else if dismissed is InfinitePresentationViewController {
            let transition = TransitionToInfinitePresentationViewController()
            transition.animationDuration = 1.5
            transition.presenting = false
            return transition
        } else if dismissed is BoutiqueViewController {
            let transition = TransitionToBoutique()
            transition.animationDuration = 1.5
            transition.presenting = false
            return transition
        }
        
        return nil
    }
    
}
