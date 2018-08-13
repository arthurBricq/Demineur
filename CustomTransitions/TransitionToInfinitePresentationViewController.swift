//
//  TransitionToInfinitePresentationViewController.swift
//  Demineur
//
//  Created by Marin on 13/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TransitionToInfinitePresentationViewController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animationDuration: TimeInterval = 1.0
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if presenting {
            let fromVC = transitionContext.viewController(forKey: .from) as! MenuViewController
            let toVC = transitionContext.viewController(forKey: .to) as! InfinitePresentationViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toView.frame = CGRect(x: fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                    fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                })
                
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        } else {
            
            let fromVC = transitionContext.viewController(forKey: .from) as! InfinitePresentationViewController
            let toVC = transitionContext.viewController(forKey: .to) as! MenuViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toVC.view.frame = CGRect(x: -fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                    fromView.center.x = fromView.bounds.width*1.5
                    toView.center.x = toView.bounds.width/2
                })
                
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        }
        
    }
    

}
