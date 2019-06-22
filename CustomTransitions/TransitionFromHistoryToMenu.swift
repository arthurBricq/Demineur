//
//  TransitionFromHistoryToMenu.swift
//  Demineur
//
//  Created by Arthur BRICQ on 22/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

/// This is the transition to go from the menu to the presentation of history levels.
class TransitionFromHistoryToMenu: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animationDuration: TimeInterval
    
    init(animationDuration: TimeInterval) {
        self.animationDuration = animationDuration
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 1. Get the views and position them in the transition context
        let fromVC = transitionContext.viewController(forKey: .from) as! HistoryPresentationViewController
        let toVC = transitionContext.viewController(forKey: .to) as! MenuViewController
        let fromView = fromVC.view!
        let toView = toVC.view!
        toView.frame = CGRect(x: -fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
        transitionContext.containerView.addSubview(toView)
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: [], animations: {
            let h = toView.bounds.height
            let w = toView.bounds.width
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                toView.frame = CGRect(x: 0, y: 0, width: w, height: h)
                fromView.frame = CGRect(x: w, y: 0, width: w, height: h)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.1, animations: {
                let line3 = toVC.linesForAnimationToHistory![2]
                line3.frame = CGRect(x: line3.frame.origin.x, y: line3.frame.origin.y, width: 0, height: 2)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                let line2 = toVC.linesForAnimationToHistory![1]
                let y0 = line2.frame.origin.y
                let h0 = line2.frame.height
                line2.frame = CGRect(x: line2.frame.origin.x, y: y0+h0, width: 2, height: 0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                let line1 = toVC.linesForAnimationToHistory![0]
                line1.frame = CGRect(x: line1.frame.origin.x, y: line1.frame.origin.y, width: 0, height: 2)
            })
            

        }) { (_) in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }

 }
