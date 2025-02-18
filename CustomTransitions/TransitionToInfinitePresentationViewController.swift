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
            
            // MARK: - ANIMATION ALLER
            
            // MARK: - On récupère les VC utilisés pour l'animation et on les place correctement
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
            // TODO: use new init call
            let lineFrameWidth: CGFloat = 2
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
            
            let x1: CGFloat = fromVC.getInitialXPositionForTransitionToInfinite()
            let y1: CGFloat = fromVC.getInitialYPositionForTransitionToInfinite()
            let x2 = toVC.getFinalXPosForTransition()
            let y2 = toVC.getFinalYPosForTransition()
            let finalPoint = CGPoint(x: x2 + fromView.frame.width, y: y2)
            
            // Initialise the different views before animation
            firstLine.frame = CGRect(x: x1, y: y1, width: 0, height: lineFrameWidth)
            secondLine.frame = CGRect(x: finalPoint.x, y: y1, width: lineFrameWidth, height: 0)
            fromView.addSubview(firstLine)
            fromView.addSubview(secondLine)
            toVC.headerView.alpha = 0.0
            
            
            // Temps pour l'animation
            let t1: Double = 0.1
            let t2: Double = 0.15
            let t3: Double = 0.25
            let t4: Double = 0.3
            let t5: Double = 0.05
            let t6: Double = 0.05
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                // MARK: - 1: La ligne part sur la droite
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: t1, animations: {
                    firstLine.frame = CGRect(x: x1, y: y1 - lineFrameWidth/2, width: 0.9*fromView.frame.width - x1, height: lineFrameWidth)
                })
                
                // MARK: - 2: La ligne continue et la vue d'origine part à gauche
                UIView.addKeyframe(withRelativeStartTime: t1, relativeDuration: t2, animations: {
                    toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                    fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                    firstLine.frame = CGRect(x: x1, y: y1 - lineFrameWidth/2, width: 1.9*fromView.frame.width - x1, height: lineFrameWidth)
                })
                
                // MARK: - 3: La ligne finit d'avancer
                UIView.addKeyframe(withRelativeStartTime: t1+t2, relativeDuration: t3, animations: {
                    firstLine.frame = CGRect(x: x1, y: y1 - lineFrameWidth/2, width: finalPoint.x-x1, height: lineFrameWidth)
                })
                
                // MARK: - 4: La première ligne remonte et la deuxième descend
                UIView.addKeyframe(withRelativeStartTime: t1+t2+t3, relativeDuration: t4, animations: {
                    firstLine.frame = CGRect(x: x1, y: finalPoint.y - lineFrameWidth/2, width: finalPoint.x-x1+1, height: lineFrameWidth)
                    secondLine.frame = CGRect(x: finalPoint.x - lineFrameWidth/2, y: finalPoint.y + firstLine.lineWidth/2, width: lineFrameWidth, height: 285-30)
                })
                
                // MARK: - 5: Le titre apparait
                UIView.addKeyframe(withRelativeStartTime: t1+t2+t3+t4, relativeDuration: t5, animations: {
                    toVC.headerView.alpha = 1.0
                })
                
                // MARK: - 6: Le reste apparait
                UIView.addKeyframe(withRelativeStartTime: t1+t2+t3+t4+t5, relativeDuration: t6, animations: {
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
                
                // MARK: - Positionne les lignes définitivement
                let convertedFinalPoint = toView.convert(finalPoint, from: fromView)
                firstLine.removeFromSuperview()
                secondLine.removeFromSuperview()
                
                firstLine.frame = CGRect(x: 0, y: convertedFinalPoint.y - lineFrameWidth/2, width: convertedFinalPoint.x+1, height: lineFrameWidth)
                firstLine.tag = 10
                secondLine.frame = CGRect(x: convertedFinalPoint.x - lineFrameWidth/2, y: convertedFinalPoint.y + firstLine.lineWidth/2, width: lineFrameWidth, height: 285-30)
                secondLine.tag = 20
                
                toView.addSubview(firstLine)
                toView.addSubview(secondLine)
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        } else {
            
            // MARK: - ----------------
            // MARK: - ANIMATION RETOUR
            
            // MARK: - On récupère les VC utilisés pour l'animation et on les place correctement
            let fromVC = transitionContext.viewController(forKey: .from) as! InfinitePresentationViewController
            let toVC = transitionContext.viewController(forKey: .to) as! MenuViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toVC.view.frame = CGRect(x: -fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
            
            
            // MARK: - Récupère les lignes
            var verticalLine = LineView()
            var horizontalLine = LineView()
            for subview in fromView.subviews {
                if subview is LineView{
                    if subview.tag == 10 {
                        horizontalLine = subview as! LineView
                    } else if subview.tag == 20 {
                        verticalLine = subview as! LineView
                    }
                }
            }
            
            // MARK: - Calcul du point d'arrivée
            var finalPoint: CGPoint = CGPoint.zero
            var averageYs: [CGFloat] = [0, 0]
            for subview in toView.subviews {
                
                if subview is Letter && subview.tag == 1 {
                    guard let line = subview.subviews.first as? LineView else { return }
                    finalPoint.x = (toView.convert(line.frame.origin, from: subview)).x + line.frame.width/2 - fromView.frame.width
                }
                
                if subview is UIButton && subview.tag == 2 {
                    averageYs[0] = subview.frame.maxY
                }
                if subview is UIButton && subview.tag == 3 {
                    averageYs[1] = subview.frame.minY
                }
                
            }
            finalPoint.y = (averageYs[0] + averageYs[1])/2
            
            horizontalLine.frame = CGRect(x: finalPoint.x, y: horizontalLine.frame.minY, width: horizontalLine.frame.maxX - finalPoint.x, height: horizontalLine.frame.height)
            
            // MARK: - Temps pour l'animation
            let x1: Double = 0.05
            let x2: Double = 0.05
            let x3: Double = 0.3
            let x4: Double = 0.3
            let x5: Double = 0.3
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                // MARK: - 1 et 2: On fait tout disparaitre sauf les lignes
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: x1, animations: {
                    for subview in fromView.subviews {
                        if !(subview is HeaderInfinite) && !(subview is LineView) {
                            subview.alpha = 0
                        }
                    }
                })
                UIView.addKeyframe(withRelativeStartTime: x1, relativeDuration: x2, animations: {
                    for subview in fromView.subviews {
                        if subview is HeaderInfinite {
                            subview.alpha = 0
                        }
                    }
                })
                
                // MARK: - 3: Les lignes se recentrent en y sur le point d'arrivée
                UIView.addKeyframe(withRelativeStartTime: x1+x2, relativeDuration: x3, animations: {
                    horizontalLine.frame = CGRect(x: finalPoint.x, y: finalPoint.y, width: horizontalLine.frame.maxX - finalPoint.x, height: horizontalLine.frame.height)
                    verticalLine.frame = CGRect(x: verticalLine.frame.minX, y: finalPoint.y, width: verticalLine.frame.width, height: 0)
                })
                
                // MARK: - 4: La ligne s'allogne, comme si la vue reculait
                UIView.addKeyframe(withRelativeStartTime: x1+x2+x3, relativeDuration: x4, animations: {
                    
                    horizontalLine.frame = CGRect(x: finalPoint.x, y: finalPoint.y, width: 0.9*fromView.frame.width - finalPoint.x, height: horizontalLine.frame.height)
                })
                
                // MARK: - 5: Le menu revient et la ligne disparait
                UIView.addKeyframe(withRelativeStartTime: x1+x2+x3+x4, relativeDuration: x5, animations: {
                    fromView.center.x += fromView.bounds.width
                    toView.center.x += toView.bounds.width
                    horizontalLine.frame = CGRect(x: finalPoint.x, y: finalPoint.y, width: 0, height: horizontalLine.frame.height)
                })
                
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        }
        
    }
    

}

/*
 
         \               /
          \__          _/
             \________/
             /|       \_
            ||  O  O   \\__
           |||   \/     \\\\_
          |||____________\\\\\
 
                LÅMP
*/
