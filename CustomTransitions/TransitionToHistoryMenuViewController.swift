//
//  TransitionToHistoryMenuViewController.swift
//  Demineur
//
//  Created by Marin on 16/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TransitionToHistoryPresentationViewController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animationDuration: TimeInterval = 1
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /*
        if presenting {
            
            // MARK: - ANIMATION ALLER
            
            let fromVC = transitionContext.viewController(forKey: .from) as! MenuViewController
            let toVC = transitionContext.viewController(forKey: .to) as! HistoryPresentationViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
            toVC.view.frame = CGRect(x: fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
            
            // MARK: - Crée les lignes pour l'animation
            let firstLine = LineView()
            firstLine.isVertical = false
            firstLine.strokeColor = colorForRGB(r: 66, g: 66, b: 66)
            firstLine.lineWidth = 1
            firstLine.tag = -1
            firstLine.backgroundColor = UIColor.clear
            
            let secondLine = LineView()
            secondLine.isVertical = true
            secondLine.strokeColor = colorForRGB(r: 66, g: 66, b: 66)
            secondLine.lineWidth = 1
            secondLine.tag = -2
            secondLine.backgroundColor = UIColor.clear
            
            let thirdLine = LineView()
            thirdLine.isVertical = false
            thirdLine.strokeColor = colorForRGB(r: 66, g: 66, b: 66)
            thirdLine.lineWidth = 1
            thirdLine.tag = -3
            thirdLine.backgroundColor = UIColor.clear
            
            // MARK: - On cherche le x et le y de départ
            
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
            
            
            // MARK: - On cherche le x et le y d'arrivée
            var finalPointFromView = CGPoint(x: 0, y: 0)
            var finalPointToView = CGPoint(x: 0, y: 0)
            
            for subview in toView.subviews {
                if subview.tag == 1 {
                    
                    guard let tableView = subview as? UITableView else {
                        return
                    }
                    
                    let lineWidth = firstLine.lineWidth
                    let cellHeight: CGFloat = 100
                    let correctiveConstant: CGFloat = isItABigScreen() ? -24 : 20
                    let point = tableView.frame.origin
                    finalPointToView = CGPoint(x: point.x + 2, y: point.y + cellHeight/2 - correctiveConstant - lineWidth/2)
                    finalPointFromView = CGPoint(x: point.x + 2 + fromView.frame.width, y: point.y + cellHeight/2 - correctiveConstant - lineWidth/2)
                    
                }
            }
            
            
            let decalementFromView = -fromView.bounds.width
            let endOfFirstLineOnX = 0.9*(fromView.frame.width-fromVC.mainLineLeadingConstraint.constant)
            
            // MARK: - Positionne les vues
            firstLine.frame = CGRect(x: x, y: y, width: 0, height: 1)
            secondLine.frame = CGRect(x: endOfFirstLineOnX, y: y, width: 1, height: 0)
            thirdLine.frame = CGRect(x: endOfFirstLineOnX, y: finalPointToView.y, width: 0, height: 2)
            fromView.addSubview(firstLine)
            fromView.addSubview(secondLine)
            fromView.addSubview(thirdLine)
            
            // MARK: - Les temps de l'animation
            let time1 = 0.2
            let time2 = 0.4
            let time3 = 0.2
            let time4 = 0.2
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                // MARK: - 1: La ligne part sur la droite
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: time1, animations: {
                    firstLine.frame = CGRect(x: x, y: y, width: 0.9*(fromView.frame.width - x), height: 1)
                })
                
                // MARK: - 2: La ligne continue seule sans le reste de la vue
                UIView.addKeyframe(withRelativeStartTime: time1, relativeDuration: time2, animations: {
                    firstLine.frame = CGRect(x: x+decalementFromView, y: y, width: 0.9*(fromView.frame.width - x - decalementFromView), height: 1)
                    
                    for subview in fromView.subviews {
                        if subview.tag > -1 || !(subview is LineView) {
                            subview.center.x = subview.center.x + decalementFromView
                        }
                    }
                    
                })
                
                // MARK: - 3: La ligne part à la verticale
                UIView.addKeyframe(withRelativeStartTime: time1+time2, relativeDuration: time3, animations: {
                    secondLine.frame = CGRect(x: endOfFirstLineOnX, y: finalPointToView.y, width: 1, height: y-finalPointToView.y)
                })
                
                // MARK: - 4: La ligne part à droite et la toVIew arrive de la gauche
                UIView.addKeyframe(withRelativeStartTime: time1+time2+time3, relativeDuration: time4, animations: {
                    thirdLine.frame = CGRect(x: endOfFirstLineOnX, y: finalPointToView.y, width: finalPointFromView.x - endOfFirstLineOnX, height: 1)
                    fromView.center.x = -fromView.bounds.width/2
                    toView.center.x = toView.bounds.width/2
                })
                
            }) { (_) in
                
                // MARK: - Repositionne la ligne qui reste au bon endroit
                thirdLine.removeFromSuperview()
                
                let tableView = toVC.tableView!
                let point = tableView.convert(CGPoint(x: 0, y: finalPointToView.y), from: toView)
                
                let line = LineView()
                line.frame = CGRect(x: point.x, y: point.y-1, width: finalPointToView.x, height: 3)
                line.lineWidth = 1
                line.isVertical = false
                line.strokeColor = colorForRGB(r: 66, g: 66, b: 66)
                line.backgroundColor = UIColor.clear
                
                tableView.addSubview(line)                
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            
        } else {
            
            // MARK: - ----------------
            // MARK: - ANIMATION RETOUR
            let fromVC = transitionContext.viewController(forKey: .from) as! HistoryPresentationViewController
            let toVC = transitionContext.viewController(forKey: .to) as! MenuViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.addSubview(toView)
            toVC.view.frame = CGRect(x: -fromView.bounds.width, y: 0, width: fromView.bounds.width, height: fromView.bounds.height)
            
            let tableView = fromVC.tableView!
            
            
            // MARK: - Récupère les lignes
            let firstLine = LineView()
            for subview in tableView.subviews {
                
                guard let line = subview as? LineView else { continue }
                
                let origin = fromView.convert(line.frame.origin, from: tableView)
                let size = line.frame.size
                
                firstLine.frame = CGRect(origin: origin, size: size)
                firstLine.lineWidth = line.lineWidth
                firstLine.isVertical = line.isVertical
                firstLine.strokeColor = line.strokeColor
                firstLine.backgroundColor = UIColor.clear
                firstLine.tag = -1
                
                line.removeFromSuperview()
            }
            fromView.addSubview(firstLine)
            
            var secondLine = LineView()
            var thirdLine = LineView()
            
            for subview in toView.subviews {
                if subview is LineView {
                    if subview.tag == -2 {
                        secondLine = subview as! LineView
                    } else if subview.tag == -1 {
                        thirdLine = subview as! LineView
                    }
                }
            }
            
            // MARK: - Calcul des points (par rapport à l'animation aller)
            
            // Intersection entre la première ligne et la ligne verticale
            let firstIntersection = fromView.convert(CGPoint(x:0.9*(toView.frame.width-toVC.mainLineLeadingConstraint.constant), y: firstLine.frame.minY), from: toView)
            let firstLineWidth = firstLine.frame.maxX - firstIntersection.x
            
            // Point final
            var finalPoint: CGPoint = CGPoint.zero
            var allY: [CGFloat] = [0, 0]
            for subview in toView.subviews {
                if subview is Letter && subview.tag == 1 {
                    guard let line = subview.subviews.first as? LineView else { return }
                    finalPoint.x = (fromView.convert(line.frame.origin, from: subview)).x + line.frame.width/2
                }
                if subview is UIButton && subview.tag == 1 {
                    allY[0] = subview.frame.maxY
                }
                if subview is UIButton && subview.tag == 2 {
                    allY[1] = subview.frame.minY
                }
            }
            finalPoint.y = (allY[0] + allY[1])/2
            
            
            // MARK: - Positionne les lignes
            firstLine.frame = CGRect(x: firstIntersection.x, y: firstLine.frame.minY, width: firstLineWidth, height: firstLine.frame.height)
            
            // MARK: - Les temps de l'animation
            let time1 = 0.3
            let time2 = 0.2
            let time3 = 0.2
            let time4 = 0.3
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                // MARK: - 1: Les éléments de la fromView partent sur la droite
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: time1, animations: {
                    
                    for subview in fromView.subviews {
                        subview.center.x += fromView.frame.width
                    }
                    secondLine.center.x += fromView.frame.width
                    thirdLine.center.x += fromView.frame.width
                    
                })
                
                // MARK: - 2: La première ligne disparait
                UIView.addKeyframe(withRelativeStartTime: time1, relativeDuration: time2, animations: {
                    
                    // Pour une raison inconnue, on ne peut pas mettre une largeur de 0 ici pour faire disparaitre la ligne, à la place dans la partie 3, l'alpha de cette ligne est mis à 0 et elle suit la descente de la ligne verticale pour ne pas qu'elle soit visible
                    firstLine.frame = CGRect(x: firstLine.frame.minX, y: firstLine.frame.minY, width: 1, height: firstLine.frame.height)
                    
                })
                
                // MARK: - 3: La ligne verticale disparait
                UIView.addKeyframe(withRelativeStartTime: time1+time2, relativeDuration: time3, animations: {
                    
                    firstLine.alpha = 0
                    firstLine.frame = CGRect(x: firstLine.frame.minX, y: secondLine.frame.maxY, width: 1, height: firstLine.frame.height)
                    
                    secondLine.frame = CGRect(x: secondLine.frame.minX, y: secondLine.frame.maxY, width: secondLine.frame.width, height: 0)
                    
                })
                
                // MARK: - 4: La toView arrive et la ligne disparait
                UIView.addKeyframe(withRelativeStartTime: time1+time2+time3, relativeDuration: time4, animations: {
                    
                    toView.center.x += fromView.frame.width
                    
                    thirdLine.frame = CGRect(x: finalPoint.x + fromView.frame.width, y: finalPoint.y, width: 0, height: thirdLine.frame.height)
                    
                })
                
            }) { (_) in
                
                firstLine.removeFromSuperview()
                secondLine.removeFromSuperview()
                thirdLine.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        */
    }
    
}
