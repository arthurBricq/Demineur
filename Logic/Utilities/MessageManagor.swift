//
//  MessageManagor.swift
//  Demineur
//
//  Created by Arthur BRICQ on 27/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

typealias FunctionToFinishGameType = (_ didTapABomb: Bool) -> Void

/// This class is in charge of presenting the message on the screen when the user taps on a bomb. There are two messages: first asking if the user wants to use a life, or if the user wants to buy a life, and then finish the game
class MessageManagor {
    
    var viewOfGame: ViewOfGame
    var clockView: ClockView?
    var gameTimer: CountingTimer?
    var superView: UIView
    var functionToFinishGame: (Bool)->Void
    
    init(viewOfGame: ViewOfGame, superView: UIView, clockView: ClockView?, functionToFinishGame: @escaping FunctionToFinishGameType) {
        self.viewOfGame = viewOfGame
        self.superView = superView
        self.functionToFinishGame = functionToFinishGame
        self.gameTimer = viewOfGame.gameTimer
        self.clockView = clockView
    }
    
    /// Cette fonction ajoute le message approprié quand l'utilisateur tape sur une bombe.
    func addTheMessage(didTapABomb: Bool) {
        print("créatio d'un message")
        if dataManager.vieQuantity > 0 {
            // faire apparaitre le message qui demande une nouvelle chance
            messageOne(didTapABomb: didTapABomb)
        } else {
            if dataManager.money > 0 {
                messageTwo(didTapABomb: didTapABomb)
            } else {
                functionToFinishGame(didTapABomb)
            }
        }
    }
    
    /// Faire apparaitre le message qui demande une nouvelle chance
    private func messageOne(didTapABomb: Bool) {
        
        var blurEffect: UIBlurEffect
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = superView.frame //your view that have any objects
        blurView.alpha = 0
        blurView.tag = -2
        
        let message = UIView()
        
        // Details sur le layer
        message.backgroundColor = UIColor.white
        message.layer.borderColor = UIColor.gray.cgColor
        message.layer.cornerRadius = 5
        message.layer.borderWidth = 2.0
        
        let topSpace: CGFloat = 8
        let decH: CGFloat = 10
        let verticalSeparator: CGFloat = 15
        let width = widthForThePopover() - decH
        let heartCote: CGFloat = width/10
        
        // Ajout du nombre de coeurs
        let secondHeart = HeartView()
        secondHeart.backgroundColor = UIColor.clear
        secondHeart.frame = CGRect(x: width - heartCote, y:  -heartCote - 5, width: heartCote, height: heartCote)
        message.addSubview(secondHeart)
        
        let heartLabel = UILabel()
        heartLabel.numberOfLines = 1
        heartLabel.textAlignment = .right
        heartLabel.text = String(dataManager.vieQuantity)
        heartLabel.font = UIFont(name: "PingFangSC-Regular", size: 30)
        let diffHeight: CGFloat = heartLabel.font.lineHeight - heartCote
        heartLabel.frame = CGRect(x: 0, y: secondHeart.frame.minY - diffHeight/2, width: width - heartCote - 10, height: heartLabel.font.lineHeight)
        message.addSubview(heartLabel)
        
        // Population de la vue
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 25)
        label.numberOfLines = 0
        label.text = "Souhaitez-vous utiliser une vie ?"
        let labelW = width - 15
        let labelH = label.text?.heightWithConstrainedWidth(width: labelW, font: label.font)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.frame = CGRect(x: (width-labelW)/2, y: topSpace, width: labelW, height: labelH!)
        message.addSubview(label)
        
        let heart = HeartView()
        heart.frame = CGRect(x: width/2 - heartCote/2, y: label.frame.maxY + verticalSeparator, width: heartCote, height: heartCote)
        heart.backgroundColor = UIColor.clear
        message.addSubview(heart)
        
        let buttonsWidth: CGFloat = width/3
        let buttonsHeight: CGFloat = buttonsWidth/2
        let separator: CGFloat = buttonsWidth/2
        
        let yes = YesNoButton()
        yes.isYes = true
        yes.tappedFunc = {
            
            dataManager.vieQuantity -= 1
            
            var viewToRemove: BombView?
            
            if didTapABomb {
                for subview in self.viewOfGame.subviews {
                    if subview is SquareCase || subview is HexCase || subview is TriangularCase {
                        for subview2 in subview.subviews {
                            if subview2 is BombView {
                                viewToRemove = subview2 as? BombView
                            }
                        }
                    }
                }
            } else {
                self.gameTimer?.counter = 3*self.viewOfGame.game!.totalTime/4
                self.clockView?.pourcentage = 0.75
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                heartLabel.alpha = 0
            }, completion: { (_) in
                heartLabel.text = String(dataManager.vieQuantity)
                
                UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [], animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15, animations: {
                        heartLabel.alpha = 1
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.55, animations: {
                        blurView.alpha = 0
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
                        viewToRemove?.alpha = 0
                    })
                    
                }, completion: { (_) in
                    
                    blurView.removeFromSuperview()
                    viewToRemove?.removeFromSuperview()
                    self.gameTimer?.play()
                    self.viewOfGame.isUserInteractionEnabled = true
                    if self.viewOfGame.game!.option3 {
                        self.viewOfGame.option3Timer.start(timeInterval: TimeInterval(self.viewOfGame.game!.option3Time), id: "Option3")
                    }
                    self.viewOfGame.unPauseAllOption1Timers()
                })
                
            })
            
        }
        yes.frame = CGRect(x: width/2 - buttonsWidth - separator/2, y: heart.frame.maxY + verticalSeparator, width: buttonsWidth, height: buttonsHeight)
        message.addSubview(yes)
        
        let no = YesNoButton()
        no.isYes = false
        no.tappedFunc = {
            
            UIView.animate(withDuration: 0.5, animations: {
                blurView.alpha = 0
            }, completion: { (_) in
                blurView.removeFromSuperview()
                self.functionToFinishGame(didTapABomb)
            })
            
        }
        no.frame = CGRect(x: yes.frame.maxX+separator, y: heart.frame.maxY + verticalSeparator, width: buttonsWidth, height: buttonsHeight)
        message.addSubview(no)
        
        // Positionnnement de la vue
        let height: CGFloat = 2*topSpace + label.bounds.height + heart.frame.height + yes.frame.height + 2*verticalSeparator
        let x = self.superView.frame.width/2 - width/2
        let y = self.superView.frame.height/2 - height/2 - 50
        message.frame = CGRect(x: x, y: y, width: width, height: height)
        blurView.contentView.addSubview(message)
        self.superView.addSubview(blurView)
        UIView.animate(withDuration: 0.5, delay: 0.6, options: [], animations: {
            blurView.alpha = 0.8
        }, completion: nil)
    }
    
    /// Faire apparaitre la demande d'achat de vie pour une nouvelle chance
    private func messageTwo(didTapABomb: Bool) {
        var blurEffect: UIBlurEffect
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.superView.frame //your view that have any objects
        blurView.alpha = 0
        blurView.tag = -2
        
        let message = UIView()
        
        // Details sur le layer
        message.backgroundColor = UIColor.white
        message.layer.borderColor = UIColor.gray.cgColor
        message.layer.cornerRadius = 5
        message.layer.borderWidth = 2.0
        
        let topSpace: CGFloat = 8
        let decH: CGFloat = 10
        let verticalSeparator: CGFloat = 15
        let width = widthForThePopover() - decH
        let coinCote: CGFloat = width/10
        
        // Ajout du nombre de pieces
        let coinView = PieceView()
        coinView.backgroundColor = UIColor.clear
        coinView.frame = CGRect(x: width - coinCote, y: -coinCote - 5, width: coinCote, height: coinCote)
        message.addSubview(coinView)
        
        let coinLabel = UILabel()
        coinLabel.numberOfLines = 1
        coinLabel.textAlignment = .right
        coinLabel.text = String(dataManager.money)
        coinLabel.font = UIFont(name: "PingFangSC-Regular", size: 26)
        let diffHeight: CGFloat = coinLabel.font.lineHeight - coinCote
        coinLabel.frame = CGRect(x: 0, y: coinView.frame.minY - diffHeight/2, width: width - coinCote, height: coinLabel.font.lineHeight)
        message.addSubview(coinLabel)
        
        // Population de la vue
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 25)
        label.numberOfLines = 0
        label.text = "Souhaitez-vous acheter une vie ?"
        let labelW = width - 15
        let labelH = label.text?.heightWithConstrainedWidth(width: labelW, font: label.font)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.frame = CGRect(x: (width-labelW)/2, y: topSpace, width: labelW, height: labelH!)
        message.addSubview(label)
        
        let buttonToBuyWidth: CGFloat = width/3
        let buttonsHeight: CGFloat = buttonToBuyWidth/3
        let buttonNoWidth: CGFloat = buttonsHeight*2
        let separator: CGFloat = buttonToBuyWidth/2
        
        let buttonToBuy = AchatBoutiqueBouton()
        buttonToBuy.prix = String(allBonus[4].prixAchat)
        buttonToBuy.frame = CGRect(x: width/2 - buttonToBuyWidth/2 - buttonNoWidth/2 - separator/2, y: label.frame.maxY + verticalSeparator, width: buttonToBuyWidth, height: buttonsHeight)
        buttonToBuy.tappedFuncIfEnoughMoney = {
            coinView.playParticleAnimation()
            dataManager.money -= allBonus[4].prixAchat
            
            var viewToRemove: BombView?
            
            if didTapABomb {
                for subview in self.viewOfGame.subviews {
                    if subview is SquareCase || subview is HexCase || subview is TriangularCase {
                        for subview2 in subview.subviews {
                            if subview2 is BombView {
                                viewToRemove = subview2 as? BombView
                            }
                        }
                    }
                }
            } else {
                self.gameTimer?.counter = 3*self.viewOfGame.game!.totalTime/4
                self.clockView?.pourcentage = 0.75
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                coinLabel.alpha = 0
            }, completion: { (_) in
                coinLabel.text = String(dataManager.money)
                
                UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [], animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15, animations: {
                        coinLabel.alpha = 1
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.55, animations: {
                        blurView.alpha = 0
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
                        viewToRemove?.alpha = 0
                    })
                    
                }, completion: { (_) in
                    
                    blurView.removeFromSuperview()
                    viewToRemove?.removeFromSuperview()
                    self.gameTimer?.play()
                    self.viewOfGame.isUserInteractionEnabled = true
                    if self.viewOfGame.game!.option3 {
                        self.viewOfGame.option3Timer.start(timeInterval: TimeInterval(self.viewOfGame.game!.option3Time), id: "Option3")
                    }
                    self.viewOfGame.unPauseAllOption1Timers()
                    
                })
            })
        }
        message.addSubview(buttonToBuy)
        
        let no = YesNoButton()
        no.isYes = false
        no.tappedFunc = {
            
            UIView.animate(withDuration: 0.5, animations: {
                blurView.alpha = 0
            }, completion: { (_) in
                blurView.removeFromSuperview()
                self.functionToFinishGame(didTapABomb)
            })
            
        }
        no.frame = CGRect(x: buttonToBuy.frame.maxX+separator, y: label.frame.maxY + verticalSeparator, width: buttonNoWidth, height: buttonsHeight)
        message.addSubview(no)
        
        // Positionnnement de la vue
        let height: CGFloat = 2*topSpace + label.bounds.height /*+ heart.frame.height*/ + no.frame.height + 2*verticalSeparator
        let x = self.superView.frame.width/2 - width/2
        let y = self.superView.frame.height/2 - height/2 - 50
        message.frame = CGRect(x: x, y: y, width: width, height: height)
        
        blurView.contentView.addSubview(message)
        self.superView.addSubview(blurView)
        UIView.animate(withDuration: 0.5, delay: 0.6, options: [], animations: {
            blurView.alpha = 0.8
        }, completion: nil)
    }
    
    /// Retourne la largeur que doit avoir le popover pour etre exactement à la taille des parties
    private func widthForThePopover() -> CGFloat {
        return superView.frame.width*0.8
    }
    
    
    
}
