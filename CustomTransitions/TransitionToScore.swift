import UIKit

class TransitionToScore: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animationDuration: TimeInterval = 1.0
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if presenting {
            
            // recupere les vc et place le toVC
            let fromVC = transitionContext.viewController(forKey: .from) as! InfinitePresentationViewController
            let toVC = transitionContext.viewController(forKey: .to) as! ScoreViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.addSubview(toView)
            toView.frame = CGRect(x: 0, y: fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
            
            
            // recupere les lignes de l'animations
            var leftLine = LineView()
            var infiniLine = LineView()
            for subview in fromView.subviews {
                if subview is LineView {
                    if subview.tag == 10 {
                        leftLine = subview as! LineView
                    } else if subview.tag == 20 {
                        infiniLine = subview as! LineView
                    }
                }
            }
            let originLeftLineFrame = leftLine.frame
            let originInfiniLineFrame = infiniLine.frame
            
            var toViewLine = LineView()
            for subview in toView.subviews {
                if subview is LineView {
                    toViewLine = subview as! LineView
                }
            }
            
            let changingColorLine = LineView()
            changingColorLine.isVertical = true
            changingColorLine.lineWidth = infiniLine.lineWidth
            changingColorLine.strokeColor = toViewLine.strokeColor
            changingColorLine.backgroundColor = UIColor.clear
            changingColorLine.frame = CGRect(x: toViewLine.frame.minX, y: fromView.frame.height, width: infiniLine.frame.width, height: 0)
            changingColorLine.alpha = 0
            fromView.addSubview(changingColorLine)
            
            
            let time1 = 0.6
            let time2 = 0.1
            let time3 = 0.3
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                // 1 : la ligne descend seule
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: time1, animations: {
                    
                    for subview in fromView.subviews {
                        if subview != leftLine && subview != infiniLine && subview != changingColorLine {
                            subview.center.y -= fromView.frame.height
                        }
                    }
                    
                    leftLine.frame = CGRect(x: leftLine.frame.minX, y: leftLine.frame.minY - fromView.frame.height, width: leftLine.frame.width, height: leftLine.frame.height)
                    infiniLine.frame = CGRect(x: toViewLine.frame.minX, y: infiniLine.frame.minY - fromView.frame.height, width: infiniLine.frame.width, height: 2*fromView.frame.height)
                    
                })
                
                // 2 : la ligne se décale et change de couleur
                UIView.addKeyframe(withRelativeStartTime: time1, relativeDuration: time2, animations: {
                    
                    infiniLine.frame = CGRect(x: toViewLine.frame.minX, y: 0, width: infiniLine.frame.width, height: fromView.frame.height)
                    changingColorLine.frame = CGRect(x: toViewLine.frame.minX, y: 0, width: infiniLine.frame.width, height: fromView.frame.height)
                    changingColorLine.alpha = 1
                    
                })
                
                // 3 : On fait monter le VC final
                UIView.addKeyframe(withRelativeStartTime: time1+time2, relativeDuration: time3, animations: {
                    toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                })
                
            }) { (_) in
                
                leftLine.frame = originLeftLineFrame
                infiniLine.frame = originInfiniLineFrame
                changingColorLine.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        } else {
            
            // recupere les vc et place le toVC
            let fromVC = transitionContext.viewController(forKey: .from) as! ScoreViewController
            let toVC = transitionContext.viewController(forKey: .to) as! InfinitePresentationViewController
            
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            transitionContext.containerView.addSubview(toView)
            toView.frame = CGRect(x: 0, y: -fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
            
            // recupere les lignes
            var scoreLine = LineView()
            for subview in fromView.subviews {
                if subview is LineView {
                    scoreLine = subview as! LineView
                }
            }
            let originScoreLineFrame = scoreLine.frame
            
            var leftLine = LineView()
            var infiniLine = LineView()
            for subview in toView.subviews {
                if subview is LineView {
                    if subview.tag == 10 {
                        leftLine = subview as! LineView
                    } else if subview.tag == 20 {
                        infiniLine = subview as! LineView
                    }
                }
            }
            let originLeftLineFrame = leftLine.frame
            let originInfiniLineFrame = infiniLine.frame
            let originPointOfInfiniLine = fromView.convert(CGPoint(x: originInfiniLineFrame.minX, y: originInfiniLineFrame.minY), from: toView)
            
            // Place correctement tous les éléments de la toView
            infiniLine.alpha = 0
            let originPointOfScoreLineInToVC = toView.convert(CGPoint(x: originScoreLineFrame.minX, y: originScoreLineFrame.minY), from: fromView)
            infiniLine.frame = CGRect(origin: originPointOfScoreLineInToVC, size: scoreLine.frame.size)
            leftLine.frame = CGRect(x: leftLine.frame.minX, y: leftLine.frame.minY - fromView.frame.height, width: leftLine.frame.width, height: leftLine.frame.height)
            
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
                
                // 1: Tous les textes descendent et la ligne commence à remonter
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                    for subview in fromView.subviews {
                        if !(subview is LineView) {
                            subview.center.y += fromView.frame.height
                        }
                    }
                })
                
                // 2-1: La ligne du score remonte et se décale
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.3, animations: {
                    scoreLine.frame = CGRect(x: originPointOfInfiniLine.x, y: originPointOfInfiniLine.y - toView.frame.height, width: scoreLine.frame.width, height: 2*toView.frame.height + 1.5*originInfiniLineFrame.height)
                    infiniLine.frame = CGRect(x: originInfiniLineFrame.minX, y: originInfiniLineFrame.minY - toView.frame.height, width: scoreLine.frame.width, height: 2*toView.frame.height + 1.5*originInfiniLineFrame.height)
                })
                
                // 2-2: La ligne change de couleur
                UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.2, animations: {
                    infiniLine.alpha = 1
                    scoreLine.alpha = 0
                })
                
                // 3: Les éléments de la toView redescendent
                UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
                    
                    toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                    
                    leftLine.frame = originLeftLineFrame
                    infiniLine.frame = originInfiniLineFrame
                    
                })
                
            }) { (_) in
                
                // réinitialise les lignes
                leftLine.frame = originLeftLineFrame
                infiniLine.frame = originInfiniLineFrame
                scoreLine.frame = originScoreLineFrame
                scoreLine.alpha = 1
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
            }
            
        }
        
    }
    
    
}
