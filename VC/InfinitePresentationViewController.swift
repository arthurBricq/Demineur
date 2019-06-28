//
//  InfinitePresentationViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 10/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class InfinitePresentationViewController: UIViewController {

    // MARK: - Outlets et variables
    
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var headerView: HeaderInfinite!
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    // MARK: - Actions
    @IBAction func playButton(_ sender: Any) {
        self.performSegue(withIdentifier: "InfinitePresentationToInfiniteGame", sender: nil)
    }
    
    @IBAction func scoreButton(_ sender: Any) {
        self.performSegue(withIdentifier: "InfinitePresentationToScores", sender: nil)
    }
    
    // MARK: - Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if scoresModel.allScores.count == 0 && Reachability.isConnectedToNetwork() {
            scoresModel.refresh()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is InfiniteGameViewController || segue.destination is ScoreViewController {
            segue.destination.transitioningDelegate = self
        }
    }
    
    // MARK: - Functions for presentation
    
    /// Returns the x position in this VC's frame where the line for the transition needs to arrive
    public func getFinalXPosForTransition() -> CGFloat {
        return headerView.frame.origin.x
    }
    
    /// Returns the y position in this VC's frame where the line for the transition needs to arrive
    public func getFinalYPosForTransition() -> CGFloat {
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        let y = headerView.frame.origin.y
        return y + (topPadding ?? 0)
    }
    
    
}

// MARK: - Gère les transitions

extension InfinitePresentationViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented is InfiniteGameViewController {
            let transition = TransitionToInfiniteGameView(animationDuration: 1.5)
            return transition
        } else if presented is ScoreViewController {
            let transition = TransitionToScore()
            transition.animationDuration = 1.5
            transition.presenting = true
            return transition
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is ScoreViewController{
            let transition = TransitionToScore()
            transition.animationDuration = 1.5
            transition.presenting = false
            return transition
        }
        
        return nil
        
    }
    
    @IBAction func unwindToInfinitePresentation(segue: UIStoryboardSegue) {
        // retour aux niveaux
    }
    /// fonction appelée lorsque le unwind est fait
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
        
        return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController) {
            let fromView = fromViewController.view!
            let toView = toViewController.view!
            if let containerView = fromView.superview {
                toView.frame = fromView.frame
                toView.alpha = 0
                containerView.addSubview(toView)
                
                UIView.animate(withDuration: 1, animations: {
                    toView.alpha = 1
                }, completion: { (_) in
                    toView.removeFromSuperview()
                    self.dismiss(animated: false, completion: nil)
                })
            }
        }
        
    }
}
