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
            
            // On récupère les VC utilisés pour l'animation et on les place correctement
            let fromVC = transitionContext.viewController(forKey: .from) as! MenuViewController
            let toVC = transitionContext.viewController(forKey: .to) as! InfinitePresentationViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toView.frame = CGRect(x: fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
            for subview in toView.subviews {
                subview.alpha = 0
            }
            
            // Initialisation des lignes
            let lineFrameWidth: CGFloat = 4
            let lineWidth: CGFloat = 2
            
            let firstLine = LineView()
            firstLine.isVertical = false
            firstLine.strokeColor = colorForRGB(r: 66, g: 66, b: 66)
            firstLine.lineWidth = lineWidth
            firstLine.backgroundColor = UIColor.clear
            
            let secondLine = LineView()
            secondLine.isVertical = true
            secondLine.strokeColor = colorForRGB(r: 66, g: 66, b: 66)
            secondLine.lineWidth = lineWidth
            secondLine.backgroundColor = UIColor.clear
            
            
            // Calculs des différents points pour les lignes
            var firstX: CGFloat = 0
            var averageYs: [CGFloat] = [0, 0]
            for subview in fromView.subviews {
                
                if subview is Letter && subview.tag == 1 {
                    guard let line = subview.subviews.first as? LineView else { return }
                    firstX = (fromView.convert(line.frame.origin, from: subview)).x + line.frame.width/2
                }
                
                if subview is UIButton && subview.tag == 2 {
                    averageYs[0] = subview.frame.maxY
                }
                if subview is UIButton && subview.tag == 3 {
                    averageYs[1] = subview.frame.minY
                }
                
            }
            let firstY = (averageYs[0] + averageYs[1])/2
            
            var headerView: UIView?
            for subview in toView.subviews {
                if subview is HeaderInfinite {
                    headerView = subview
                }
            }
            let finalPoint = fromView.convert(CGPoint(x: 4.5*(headerView?.frame.width)!/163, y: 13.5*(headerView?.frame.height)!/163), from: headerView)
            
            
            firstLine.frame = CGRect(x: firstX, y: firstY, width: 0, height: lineFrameWidth)
            secondLine.frame = CGRect(x: finalPoint.x, y: firstY, width: lineFrameWidth, height: 0)
            fromView.addSubview(firstLine)
            fromView.addSubview(secondLine)
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                    firstLine.frame = CGRect(x: firstX, y: firstY - lineFrameWidth/2, width: 0.9*fromView.frame.width - firstX, height: lineFrameWidth)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3, animations: {
                    toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                    fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                    firstLine.frame = CGRect(x: firstX, y: firstY - lineFrameWidth/2, width: 1.9*fromView.frame.width - firstX, height: lineFrameWidth)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2, animations: {
                    firstLine.frame = CGRect(x: firstX, y: firstY - lineFrameWidth/2, width: finalPoint.x-firstX, height: lineFrameWidth)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.2, animations: {
                    firstLine.frame = CGRect(x: firstX, y: finalPoint.y - lineFrameWidth/2, width: finalPoint.x-firstX, height: lineFrameWidth)
                    secondLine.frame = CGRect(x: finalPoint.x - lineFrameWidth/2, y: finalPoint.y + firstLine.lineWidth/2, width: lineFrameWidth, height: 0.44*fromView.frame.height)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.05, animations: {
                    headerView?.alpha = 1
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.95, relativeDuration: 0.05, animations: {
                    for subview in toView.subviews {
                        if !(subview is HeaderInfinite) {
                            subview.alpha = 1
                        }
                    }
                })
                
            }) { (_) in
                
                for subview in toView.subviews {
                    subview.alpha = 1
                }
                
                let convertedFinalPoint = toView.convert(finalPoint, from: fromView)
                firstLine.removeFromSuperview()
                secondLine.removeFromSuperview()
                
                firstLine.frame = CGRect(x: 0, y: convertedFinalPoint.y - lineFrameWidth/2, width: convertedFinalPoint.x, height: lineFrameWidth)
                secondLine.frame = CGRect(x: convertedFinalPoint.x - lineFrameWidth/2, y: convertedFinalPoint.y + firstLine.lineWidth/2, width: lineFrameWidth, height: 0.44*toView.frame.height)
                
                toView.addSubview(firstLine)
                toView.addSubview(secondLine)
                
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
