//
//  EndGameCoinAnimationManager.swift
//  Demineur
//
//  Created by Marin on 26/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

/// This class deals with the animation of the coins at the end of a game
class EndGameCoinAnimationManager: NSObject {
    
    var gameView: ViewOfGame
    let coinsEarnedPerBomb: Int = 10
    
    init(gameViewToAnimate: ViewOfGame) {
        self.gameView = gameViewToAnimate
    }
    
    /// This function will return an array of all the bombs correctly marked in order to animate them
    private func returnAllCorrectlyMarkedBombs() -> [Case] {
        
        var correctlyMarkedBombs: [Case] = []
        
        for lineOfCasesTested in gameView.cases {
            
            for caseTested in lineOfCasesTested {
                
                if (caseTested.caseState == .marked || caseTested.caseState == .markedByComputer) && (gameView.gameState[caseTested.i][caseTested.j] == -1) {
                    correctlyMarkedBombs.append(caseTested)
                }
                
            }
            
        }
        
        return correctlyMarkedBombs
        
    }
    
    /// This function will animate the case that it has as a parameter. It creates a message with the coins earned and makes it move
    private func animateOneCase(toAnimate: Case, delayTime: Double) {
        
        delay(seconds: delayTime) {
            let randomXTranslation = (CGFloat(random(Int(toAnimate.frame.width))) - toAnimate.frame.width/2)
            let msgToAnimate = self.returnMessageWithCoinsEarned(rect: CGRect(x: toAnimate.frame.midX + randomXTranslation - 80/2, y: toAnimate.frame.minY - 10, width: 80, height: 30))
            msgToAnimate.backgroundColor = UIColor.clear
            msgToAnimate.alpha = 0
            self.gameView.addSubview(msgToAnimate)
            
            UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [], animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    msgToAnimate.alpha = 1
                    msgToAnimate.frame = CGRect(x: toAnimate.frame.midX + randomXTranslation - 80/2, y: toAnimate.frame.minY - 15, width: 80, height: 30)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.6, animations: {
                    msgToAnimate.frame = CGRect(x: toAnimate.frame.midX + randomXTranslation - 80/2, y: toAnimate.frame.minY - 30, width: 80, height: 30)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                    msgToAnimate.alpha = 0
                    msgToAnimate.frame = CGRect(x: toAnimate.frame.midX + randomXTranslation - 80/2, y: toAnimate.frame.minY - 35, width: 80, height: 30)
                })
                
            }) { (_) in
                msgToAnimate.removeFromSuperview()
                dataManager.money += self.coinsEarnedPerBomb
            }
        }
        
        
    }
    
    /// This function creates the message showing the coins earned
    private func returnMessageWithCoinsEarned(rect: CGRect) -> UIView {
        
        let message: UIView = UIView(frame: rect)
        
        let text = "+\(coinsEarnedPerBomb)"
        let font = UIFont(name: "PingFangSC-Regular", size: 20)!
        let lblWidth: CGFloat = (2/3)*rect.width
        let lblHeight = rect.height
        let lbl = UILabel(frame: CGRect(x: 0, y: rect.height/2 - lblHeight/2, width: lblWidth, height: lblHeight))
        lbl.text = text
        lbl.font = font
        lbl.textColor = UIColor(red: 204/255, green: 163/255, blue: 0/255, alpha: 1)
        message.addSubview(lbl)
        
        let coinView = PieceView(frame: CGRect(x: text.width(withConstrainedHeight: lblHeight, font: font), y: 0, width: rect.height, height: rect.height))
        coinView.backgroundColor = UIColor.clear
        message.addSubview(coinView)
        
        return message
        
    }
    
    /// This function get all the cases that have bombs and make the animation to earn money
    public func animateTheEarnings(completion: @escaping ()->Void) {
        
        var casesToAnimate = returnAllCorrectlyMarkedBombs()
        var casesToAnimateOrderedRandomly: [Case] = []
        
        while casesToAnimate.count != 0 {
            let randomIndex = random(casesToAnimate.count)
            casesToAnimateOrderedRandomly.append(casesToAnimate.remove(at: randomIndex))
        }
        
        for (i,caseToAnimate) in casesToAnimateOrderedRandomly.enumerated() {
            self.animateOneCase(toAnimate: caseToAnimate, delayTime: 0.5*Double(i))
        }
        
        delay(seconds: Double(casesToAnimateOrderedRandomly.count) * 0.5 + 0.5) {
            completion()
        }
        
    }
    
}
