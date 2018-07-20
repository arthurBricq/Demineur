//
//  TransitionToGameView.swift
//  Demineur
//
//  Created by Arthur BRICQ on 19/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TransitionToGameView: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = (transitionContext.viewController(forKey: .from))!
        let toVC = (transitionContext.viewController(forKey: .to))!
        
        let fromView = fromVC.view!
        let toView = toVC.view!
        
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        
        UIView.animate(withDuration: animationDuration, animations: {
            fromView.alpha = 0
        }) { (_) in
            fromView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }

}
