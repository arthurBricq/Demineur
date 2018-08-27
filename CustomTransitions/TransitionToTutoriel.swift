//
//  TransitionToReglage.swift
//  Demineur
//
//  Created by Arthur BRICQ on 25/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TransitionToTutoriel: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animationDuration: TimeInterval = 1.0
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if presenting {
            
            let fromVC = transitionContext.viewController(forKey: .from) as! MenuViewController
            let toVC = transitionContext.viewController(forKey: .to) as! TutorialViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toView.frame = CGRect(x: 0, y: fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
            
            UIView.animate(withDuration: animationDuration, animations: {
                fromView.frame = CGRect(x: 0, y: -fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
                toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            }) { (_) in
                
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
            }
            
        } else {
            
            let fromVC = transitionContext.viewController(forKey: .from) as! TutorialViewController
            let toVC = transitionContext.viewController(forKey: .to) as! MenuViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toView.frame = CGRect(x: 0, y: -fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
            
            UIView.animate(withDuration: animationDuration, animations: {
                fromView.frame = CGRect(x: 0, y: fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
                toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            }) { (_) in
                
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
            }
            
        }
        
    }
    
    
}
