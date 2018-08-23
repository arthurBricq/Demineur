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
        return animationDuration+0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = (transitionContext.viewController(forKey: .from))!
        let toVC = transitionContext.viewController(forKey: .to) as! WinLooseViewController
        
        let fromView = fromVC.view!
        let toView = toVC.view!
        toView.alpha = 0
        toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)

        transitionContext.containerView.addSubview(toView)
        
        let lineFrame = toVC.lineView.frame
        toVC.lineView.frame = CGRect(x: lineFrame.minX, y: lineFrame.minY-toView.frame.height, width: lineFrame.width, height: toView.frame.height)
        let eFrame = toVC.letterE.frame
        toVC.letterE.frame = CGRect(x: eFrame.minX, y: eFrame.minY-toView.frame.height, width: eFrame.width, height: eFrame.height)
        let nFrame = toVC.letterN.frame
        toVC.letterN.frame = CGRect(x: nFrame.minX, y: nFrame.minY-toView.frame.height, width: nFrame.width, height: nFrame.height)
        let dFrame = toVC.letterD.frame
        toVC.letterD.frame = CGRect(x: dFrame.minX, y: dFrame.minY-toView.frame.height, width: dFrame.width, height: dFrame.height)
        
        toVC.label.alpha = 0
        toVC.menuButton.alpha = 0
        toVC.menuIconButton.alpha = 0
        toVC.replayButton.alpha = 0
        toVC.replayIconButton.alpha = 0
        toVC.lastButton.alpha = 0
        toVC.nextLevelIcon.alpha = 0
        
        let correctiveConstant: CGFloat = isItABigScreen() ? -24 : 20
        
        UIView.animateKeyframes(withDuration: self.animationDuration, delay: 0.6, options: [], animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                toView.alpha = 1
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.55, animations: {
                toVC.lineView.frame = CGRect(x: lineFrame.minX, y: lineFrame.minY, width: lineFrame.width, height: toView.frame.height)
                toVC.letterE.frame = CGRect(x: eFrame.minX, y: eFrame.minY-correctiveConstant, width: eFrame.width, height: eFrame.height)
                toVC.letterN.frame = CGRect(x: nFrame.minX, y: nFrame.minY-correctiveConstant, width: nFrame.width, height: nFrame.height)
                toVC.letterD.frame = CGRect(x: dFrame.minX, y: dFrame.minY-correctiveConstant, width: dFrame.width, height: dFrame.height)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
                toVC.label.alpha = 1
                toVC.menuButton.alpha = 1
                toVC.menuIconButton.alpha = 1
                toVC.replayButton.alpha = 1
                toVC.replayIconButton.alpha = 1
                toVC.lastButton.alpha = 1
                toVC.nextLevelIcon.alpha = 1
            })

        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}
