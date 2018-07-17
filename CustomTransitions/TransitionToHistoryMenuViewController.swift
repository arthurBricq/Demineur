//
//  TransitionToHistoryMenuViewController.swift
//  Demineur
//
//  Created by Marin on 16/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TransitionToHistoryMenuViewController: NSObject, UIViewControllerAnimatedTransitioning {
    
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
            
            let firstLine = LineView()
            firstLine.isVertical = false
            firstLine.strokeColor = colorForRGB(r: 66, g: 66, b: 66)
            firstLine.lineWidth = 1
            firstLine.tag = -1
            
            let secondLine = LineView()
            secondLine.isVertical = true
            secondLine.strokeColor = colorForRGB(r: 66, g: 66, b: 66)
            secondLine.lineWidth = 1
            secondLine.tag = -1
            
            let thirdLine = LineView()
            thirdLine.isVertical = false
            thirdLine.strokeColor = colorForRGB(r: 66, g: 66, b: 66)
            thirdLine.lineWidth = 1
            thirdLine.tag = -1
            
            
            // On cherche le x et le y de départ
            var x: CGFloat = 0
            var allY: [CGFloat] = [0, 0]
            for subview in fromView.subviews {
                
                if subview is Letter && subview.tag == 1 {
                    guard let line = subview.subviews.first as? LineView else { return }
                    x = (fromView.convert(line.frame.origin, from: subview)).x + line.frame.width/2
                }
                
                if subview is UIButton && subview.tag == 1 {
                    allY[0] = subview.frame.maxY
                }
                if subview is UIButton && subview.tag == 2 {
                    allY[1] = subview.frame.minY
                }
                
            }
            let y = (allY[0] + allY[1])/2
            
            
            // on cherche le x et le y d'arrivée
            var finalPointFromView = CGPoint(x: 0, y: 0)
            var finalPointToView = CGPoint(x: 0, y: 0)
            
            for subview in toView.subviews {
                if subview.tag == 1 {
                    
                    guard let tableView = subview as? UITableView else {
                        return
                    }
                    
                    let lineWidth = firstLine.lineWidth
                    let cellHeight: CGFloat = 100
                    let safeAreaHeight: CGFloat = isItABigScreen() ? -24 : 20
                    let point = tableView.frame.origin
                    print(tableView.frame.origin)
                    finalPointToView = CGPoint(x: point.x + 5, y: point.y + cellHeight/2 - safeAreaHeight - lineWidth/2)
                    finalPointFromView = CGPoint(x: point.x + 5 + fromView.frame.width, y: point.y + cellHeight/2 - safeAreaHeight - lineWidth/2)
                    
                }
            }
            
            
            let decalementFromView = -fromView.bounds.width
            let endOfFirstLineOnX = 0.9*(fromView.frame.width-fromVC.mainLineLeadingConstraint.constant)
            
            
            firstLine.frame = CGRect(x: x, y: y, width: 0, height: 1)
            secondLine.frame = CGRect(x: endOfFirstLineOnX, y: y, width: 1, height: 0)
            thirdLine.frame = CGRect(x: endOfFirstLineOnX, y: finalPointToView.y, width: 0, height: 1)
            fromView.addSubview(firstLine)
            fromView.addSubview(secondLine)
            fromView.addSubview(thirdLine)
            
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                    firstLine.frame = CGRect(x: x, y: y, width: 0.9*(fromView.frame.width - x), height: 1)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.4, animations: {
                    firstLine.frame = CGRect(x: x+decalementFromView, y: y, width: 0.9*(fromView.frame.width - x - decalementFromView), height: 1)
                    
                    for subview in fromView.subviews {
                        if subview.tag != -1 {
                            subview.center.x = subview.center.x + decalementFromView
                        }
                    }
                    
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.2, animations: {
                    secondLine.frame = CGRect(x: endOfFirstLineOnX, y: finalPointToView.y, width: 1, height: y-finalPointToView.y)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                    thirdLine.frame = CGRect(x: endOfFirstLineOnX, y: finalPointToView.y, width: finalPointFromView.x - endOfFirstLineOnX, height: 1)
                    fromView.center.x = -fromView.bounds.width/2
                    toView.center.x = toView.bounds.width/2
                })
                
            }) { (_) in
                
                firstLine.removeFromSuperview()
                secondLine.removeFromSuperview()
                thirdLine.removeFromSuperview()
                
                let tableView = toVC.tableView!
                let point = tableView.convert(CGPoint(x: 0, y: finalPointToView.y), from: toView)
                thirdLine.frame = CGRect(x: point.x, y: point.y, width: finalPointToView.x, height: 1)
                
                tableView.addSubview(thirdLine)
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            
        } else {
            
            let fromVC = transitionContext.viewController(forKey: .from) as! HistoryPresentationViewController
            let toVC = transitionContext.viewController(forKey: .to) as! MenuViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toVC.view.frame = CGRect(x: -fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
            
            var line = LineView()
            
            let tableView = fromVC.tableView!
            
            for subview in tableView.subviews {
                guard let view = subview as? LineView else { continue }
                line = view
            }
            
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                    line.alpha = 0
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.85, animations: {
                    fromView.center.x = fromView.bounds.width*1.5
                    toView.center.x = toView.bounds.width/2
                })
                
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
}
