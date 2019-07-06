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
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playImageButton: MenuPauseIconsButtons!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var scoreImageButton: ScoreStarView!
    @IBOutlet weak var bestLevelLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func playButton(_ sender: Any) {
        self.performSegue(withIdentifier: "InfinitePresentationToInfiniteGame", sender: nil)
    }
    
    @IBAction func scoreButton(_ sender: Any) {
        self.performSegue(withIdentifier: "InfinitePresentationToScores", sender: nil)
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColors()
    }
    
    private func setColors() {
        self.view.backgroundColor = Color.getColor(index: 0)
        menuButton.setTitleColor(Color.getColor(index: 3), for: .normal)
        playButton.setTitleColor(Color.getColor(index: 3), for: .normal)
        scoreButton.setTitleColor(Color.getColor(index: 3), for: .normal)
        
        bestLevelLabel.textColor = Color.getColor(index: 3)
        bestLevelLabel.setNeedsDisplay()
        bestScoreLabel.textColor = Color.getColor(index: 3)
        bestScoreLabel.setNeedsDisplay()
        
        playImageButton.color = Color.getColor(index: 3)
        playImageButton.setNeedsDisplay()
        scoreImageButton.color = Color.getColor(index: 3)
        scoreImageButton.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let _ = TutorialManager(viewController: self)
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
