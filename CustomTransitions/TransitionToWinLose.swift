//
//  TransitionToWinLose.swift
//  Demineur
//
//  Created by Marin on 25/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TransitionToWinLose: NSObject, UIViewControllerAnimatedTransitioning {

    var animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = (transitionContext.viewController(forKey: .from))!
        let toVC = transitionContext.viewController(forKey: .to) as! WinLooseViewController
        
        let fromView = fromVC.view!
        let toView = toVC.view!
        toView.alpha = 0
        toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        
        delay(seconds: 0.6) {
            transitionContext.containerView.addSubview(toView)
            
            
            
            UIView.animate(withDuration: self.animationDuration, animations: {
                toView.alpha = 1
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        
    }
    
}
