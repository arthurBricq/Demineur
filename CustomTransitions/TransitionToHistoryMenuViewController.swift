//
//  TransitionToHistoryMenuViewController.swift
//  Demineur
//
//  Created by Marin on 16/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TransitionToHistoryMenuViewController: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    var animationDuration: TimeInterval = 1
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if presenting {
            let fromVC = transitionContext.viewController(forKey: .from) as! MenuViewController
            let toVC = transitionContext.viewController(forKey: .to) as! HistoryPresentationViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toVC.view.frame = CGRect(x: fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
            
            UIView.animate(withDuration: animationDuration, animations: {
                fromView.center.x = -fromView.bounds.width/2
                toView.center.x = toView.bounds.width/2
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            let fromVC = transitionContext.viewController(forKey: .from) as! HistoryPresentationViewController
            let toVC = transitionContext.viewController(forKey: .to) as! MenuViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toVC.view.frame = CGRect(x: -fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
            
            UIView.animate(withDuration: animationDuration, animations: {
                fromView.center.x = fromView.bounds.width*1.5
                toView.center.x = toView.bounds.width/2
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    
}
