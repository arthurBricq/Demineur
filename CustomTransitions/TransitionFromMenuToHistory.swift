//
//  TransitionFromMenuToHistory.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

/// This is the transition to go from the menu to the presentation of history levels. 
class TransitionFromMenuToHistory: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animationDuration: TimeInterval 
    
    init(animationDuration: TimeInterval) {
        self.animationDuration = animationDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /*
         Desired animation
         - A line going from the first menu to the second menu, like a continuation.
        */
        
        // 1. Obtain the VCs and their views, and place the 2 VC on the animation context.
        let fromVC = transitionContext.viewController(forKey: .from) as! MenuViewController
        let toVC = transitionContext.viewController(forKey: .to) as! HistoryPresentationViewController
        let fromView = fromVC.view!
        let toView = toVC.view!
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        // The 'toView' is placed to the right of the screen, and will be displaced at the end of the animation
        toVC.view.frame = CGRect(x: fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
        
        // 2. We need three objects representing the lines.
        let line1 = LineView(lineWidth: 2.0, isVertical: false, strokeColor: Color.getColor(index: 2))
        let line2 = LineView(lineWidth: 2.0, isVertical: true, strokeColor: Color.getColor(index: 2))
        let line3 = LineView(lineWidth: 2.0, isVertical: false, strokeColor: Color.getColor(index: 2))
        fromVC.linesForAnimationToHistory = [line1,line2,line3]

        // 3. Find the origin position (using the design constraints), and position the views where they must start there trip
        let x1 = fromVC.getInitialXPositionForTransitionToHistory()
        let y1 = fromVC.getInitialYPositionForTransitionToHistory()
        let y2 = toVC.getFinalYPositionForTransition()
        let w = fromView.frame.width
        let multiplier: CGFloat = 0.93
        line1.frame = CGRect(x: x1, y: y1, width: 0, height: 2)
        line2.frame = CGRect(x: multiplier*w, y: y1, width: 2, height: 0)
        line3.frame = CGRect(x: multiplier*w, y: y2, width: 0.0, height: 2.0)
        fromView.addSubview(line1)
        fromView.addSubview(line2)
        fromView.addSubview(line3)
        
        // 4. Timing for the animation
        let t1 = 0.2
        let t2 = 0.2
        let t3 = 0.2
        let t4 = 0.2
        let t5 = 0.2
        
        // 5. perform the animation
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: [], animations: {
            
            // 1. The line start going to the right.
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: t1, animations: {
                line1.frame = CGRect(x: x1, y: y1, width: multiplier*w - x1, height: 2)
            })
            
            // 2. The line keep going by herself.
            UIView.addKeyframe(withRelativeStartTime: t1, relativeDuration: t2, animations: {
                // a. Take away all the views
                for subview in fromView.subviews {
                    if subview.tag > -1 || !(subview is LineView) {
                        subview.center.x = subview.center.x - w
                    }
                }
                
                // b. Make the line longer as well
                line1.frame = CGRect(x: x1 - w, y: y1, width: multiplier*w - x1 + w + 2, height: 2)

            })
            
            // 3. Make the line going to the vertical direction
            UIView.addKeyframe(withRelativeStartTime: t1+t2, relativeDuration: t3, animations: {
                line2.frame = CGRect(x: multiplier*w, y: y2, width: 2, height: y1-y2)
            })
            
            UIView.addKeyframe(withRelativeStartTime: t1+t2+t3, relativeDuration: t4, animations: {
                line3.frame = CGRect(x: multiplier*w, y: y2, width: 0.1*w, height: 2)
            })
            
            // 4. Make the 'toView' arrive from the right
            UIView.addKeyframe(withRelativeStartTime: t1+t2+t3+t4, relativeDuration: t5, animations: {
                fromView.center.x = -fromView.bounds.width/2
                toView.center.x = toView.bounds.width/2
                toVC.animateCells(index: 0)
            })
            
        }) { (_) in
            
            // Reset the first line to have the correct position for when going back 
            line1.frame = CGRect(x: x1, y: y1, width: multiplier*w - x1, height: 2)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
        
    }
    
}

