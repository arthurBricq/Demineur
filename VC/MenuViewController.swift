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
        
        if segue.destination is HistoryPresentationViewController {
            segue.destination.transitioningDelegate = self
        }
        
    }
    
}

extension MenuViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented is HistoryPresentationViewController {
            let transition = TransitionToHistoryMenuViewController()
            transition.animationDuration = 2
            transition.presenting = true
            return transition
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is HistoryPresentationViewController {
            let transition = TransitionToHistoryMenuViewController()
            transition.animationDuration = 2
            transition.presenting = false
            return transition
        }
        
        return nil
    }
    
}
