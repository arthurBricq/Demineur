//
//  HistoryGameViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 12/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class HistoryGameViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var flagsLabel: UILabel!
    @IBOutlet weak var flagView: FlagViewDisplay!
    @IBOutlet weak var bombsLabel: UILabel!
    @IBOutlet weak var bombView: BombViewDisplay!
   
    // MARK: - VARIABLES
    override var prefersStatusBarHidden: Bool { return true }
    
    var bonusChoiceView: BonusChoiceView?
    var game: OneGame = OneGame(gameTypeWithNoneCases: .triangular, n: 10, m: 10, z: 5, numberOfFlag: 5, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true) // cette variable s'occupe de toute la partie à jouer.
    var gameIndex: Int = 1 // Avoir connaissance de l'indice du niveau
    /// Nombre de bombes qui ont été trouvées par l'utilisateur
    var numberOfBombs: Int = 0
    var gameState = [[Int]].init()
    var gameTimer = CountingTimer()
    var viewOfGame: ViewOfGame?
    
    // MARK: - FUNCTIONS
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transitioningDelegate = nil
        isTheGameStarted.delegate = self // Cela permet, via cette variable, d'appeller le VC qui s'occupe du jeu pour créer la partie
        startANewGame(animatedFromTheRight: false)
    }
    
    func addTheBonusChoiceView() {
        let screenW = self.view.frame.width
        let screenH = self.view.frame.height
        let dec_h: CGFloat = 20 // decalage horizontal
        let dec_v: CGFloat = isItABigScreen() ? 30 : 15 // decalage vertical
        let w = screenW - dec_h
        let h = w/6
        let size = CGSize(width: w, height: h)
        let origin = CGPoint(x: dec_h/2, y: screenH - h - dec_v)
        if bonusChoiceView != nil { bonusChoiceView?.removeFromSuperview() }
        bonusChoiceView = BonusChoiceView()
        bonusChoiceView!.backgroundColor = UIColor.clear
        bonusChoiceView!.progress = 0
        bonusChoiceView!.frame = CGRect(origin: origin, size: size)
        bonusChoiceView!.instantiateScrollView()
        bonusChoiceView!.vcDelegate = self
        self.view.addSubview(bonusChoiceView!)
    }
    
    func startANewGame(animatedFromTheRight: Bool) {
        // instauration du timer sur l'écran
        gameTimer.stop()
        if !game.isTimerAllowed {
            clockView.isHidden = true
            gameTimer.delegate = nil
        } else {
            clockView.isHidden = false
            clockView.pourcentage = 0.0
            gameTimer.delegate = self
            gameTimer.timeInterval = 1.0
        }
        
        // instauration des drapeaux et des bombes sur l'écran
        if !game.areNumbersShowed {
            flagsLabel.isHidden = true
            flagView.isHidden = true
            bombsLabel.isHidden = true
            bombView.isHidden = true
        } else {
            flagsLabel.isHidden = false
            flagView.isHidden = false
            bombsLabel.isHidden = false
            bombView.isHidden = false
        }
        
        // instauration de la bar des bonus
        addTheBonusChoiceView()
        
        // Quelques détails
        isTheGameStarted.value = false
        updateFlags(numberOfFlags: game.numberOfFlag)
        self.numberOfBombs = 0 
        
        // Tailles maximales occupées par la vue :
        let maxHeight = self.view.bounds.height * 0.65
        let multiplier: CGFloat = isItABigScreen() ? 0.98 : 0.92
        let maxWidth = game.gameType == .square ? self.view.bounds.width * multiplier : self.view.bounds.width * 0.95
        
        removePrecendentViewOfGame()
    
        let color1: UIColor = colorForRGB(r: 52, g: 61, b: 70)
        
        game.colors = ColorSetForOneGame(openColor: colorForRGB(r: 192, g: 197, b: 206) , emptyColor: UIColor.white, strokeColor: color1, textColor: color1)
        
        // Compute the frame for the view
        
        if game.gameType == .square {
            createANewSquareGameStepOne()
            let (width, height) = dimensionSquareTable(n: game.n, m: game.m, withMaximumWidth: maxWidth, withMaximumHeight: maxHeight)
            let viewSize = CGSize(width: width, height: height)
            let origin = animatedFromTheRight ? CGPoint(x: self.view.center.x - width/2 + self.view.frame.width, y: self.view.center.y - height/2) : CGPoint(x: self.view.center.x - width/2, y: self.view.center.y - height/2)
            viewOfGame = SquareViewOfGame(frame: CGRect(origin: origin, size: viewSize), game: game, gameState: &gameState)
            viewOfGame!.layer.borderWidth = 1.0
        } else if game.gameType == .hexagonal {
            createANewHexGameStepOne() // première étape de la création
            let center = self.view.center
            let (w,h) = dimensionHexTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let origin = animatedFromTheRight ? CGPoint(x: center.x - w/2 + self.view.frame.width, y: center.y - h/2) : CGPoint(x: center.x - w/2, y: center.y - h/2)
            viewOfGame = HexViewOfGame(frame: CGRect(origin: origin, size: CGSize.init(width: w, height: h)), game: game, gameState: &gameState)
        } else if game.gameType == .triangular {
            createNewTriangularGameStepOne()
            let center = self.view.center
            let (w,h) = dimensionTriangularTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let origin = animatedFromTheRight ? CGPoint(x: center.x - w/2 + self.view.frame.width, y: center.y - h/2) : CGPoint(x: center.x - w/2, y: center.y - h/2)
            viewOfGame = TriangleViewOfGame(frame: CGRect(origin: origin, size: CGSize.init(width: w, height: h)), game: game, gameState: &gameState)
        }
    
        
        // Set the properties of the view of game
        viewOfGame!.backgroundColor = UIColor.clear
        viewOfGame!.delegate = self
        viewOfGame!.layer.masksToBounds = false
        viewOfGame!.layer.borderColor = game.colors.strokeColor.cgColor
        viewOfGame!.numberOfFlags = game.numberOfFlag
        viewOfGame!.onPosingFlag = { (test: Bool) -> Void in
            self.numberOfBombs += test ? 1 : 0
        }
        self.view.addSubview(viewOfGame!)
        
        if animatedFromTheRight {
            UIView.animate(withDuration: 0.7) {
                self.viewOfGame?.center.x -= self.view.frame.width
            }
        }
    }
    
    /// retire tous les view of game qui sont présent sur l'écran. Il faut penser à rajouter une nouvelle vue avec 'startANewGame()' après faire l'appel de cette fonction.
    func removePrecendentViewOfGame() {
        viewOfGame?.removeFromSuperview()
    }
    
    func openTheBombs() {
        viewOfGame?.returnAllTheCases()
    }
    
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        // TODO: simplify this method
        gameTimer.pause()
        viewOfGame?.option3Timer.pause()
        viewOfGame?.pauseAllOption1Timers()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pauseVC = storyboard.instantiateViewController(withIdentifier: "Pause") as! PauseViewController
        pauseVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pauseVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pauseVC.pausedGameViewController = self
        self.present(pauseVC, animated: true, completion: nil)
    }

    func updateFlags(numberOfFlags: Int) {
        flagsLabel.text = numberOfFlags.description
        bombsLabel.text = game.z.description
    }
    
    // MARK: - Functions to create a new game

    func createANewSquareGameStepOne() {
        gameState = createEmptySquareGameState(n: game.n, m: game.m)
        positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameState)
    }
    
    func updateSquareGame(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsSquare(in: &gameState, numberOfBombs: game.z, withFirstTouched: (touch.x,touch.y))
        createNumbersToDisplaySquare(in: &gameState)
        viewOfGame!.gameState = gameState
    }
    
    func createANewHexGameStepOne() {
        gameState = createEmptyHexGameState(n: game.n, m: game.m)
        positionNoneCaseHex(noneCases: game.noneCasesPosition, gameState: &gameState)
    }
    
    func updateHexGameState(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsHex(gameState: &gameState, z: game.z, withFirstTouched: (touch.x, touch.y))
        createNumbersToDisplayHex(gameState: &gameState)
        viewOfGame!.gameState = gameState
    }
   
    func createNewTriangularGameStepOne() {
        gameState = createEmptySquareGameState(n: game.n, m: game.m)
        positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameState)
    }
    
    func updateTriangularGameStepTwo(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsSquare(in: &gameState, numberOfBombs: game.z, withFirstTouched: (touch.x,touch.y), isTriangular: true)
        createNumbersToDisplayTriangle(in: &gameState)
        viewOfGame!.gameState = gameState
    }
    
}


extension HistoryGameViewController: variableCanCallGameVC {
    
    /// cette fonction est appelée lorsque l'utilisateur tape sur la première case : cela apelle cette fonction immédiatement avec le touches began, puis la partie commence comme il le faut grâce au touchesEnded.
    func createTheGame(withFirstTouched touch: (x: Int, y: Int)) {
        if game.gameType == .hexagonal {
            updateHexGameState(withFirstTouched: (touch.x,touch.y))
        } else if game.gameType == .square {
            updateSquareGame(withFirstTouched: (touch.x,touch.y))
        } else if game.gameType == .triangular {
            updateTriangularGameStepTwo(withFirstTouched: (touch.x,touch.y))
        }
        
        bonusChoiceView!.activateBonusButtons()
        gameTimer.start(timeInterval: 1.0, id: "Clock")
        
    }
}

// MARK: - Protocol pour les gameViews (permet de terminer la partie, entre autre)
extension HistoryGameViewController: GameViewCanCallVC {
    
    func gameOver(win: Bool, didTapABomb: Bool, didTimeEnd: Bool) {
        
        Vibrate().vibrate(style: .heavy)
        
        gameTimer.pause()
        
        viewOfGame!.isUserInteractionEnabled = false
        viewOfGame!.option3Timer.stop()
        viewOfGame!.pauseAllOption1Timers()
    
        if didTapABomb || didTimeEnd {
            addTheMessage(didTapABomb: didTapABomb)
        } else {
            gameTimer.stop()
            
            if !win {
                openTheBombs()
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WinLooseVC") as! WinLooseViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.precedentViewController = self
            vc.win = win
            vc.transitioningDelegate = self
            vc.didTapABomb = didTapABomb
            vc.precedentGameIndex = gameIndex
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func updateFlagsDisplay(numberOfFlags: Int) {
        updateFlags(numberOfFlags: numberOfFlags)
    }
    
}

// MARK: - Pour le chronomètre
extension HistoryGameViewController: CountingTimerProtocol {
    
    func timerFires(id: String) {
        // In this case, the id does not matter at all.
        // This method is called each second.
        
        if id == "Clock" {
            
            if game.isTimerAllowed {
                let pourcentage: CGFloat = gameTimer.counter / CGFloat(game.totalTime) // ratio of time used.
                
                clockView.pourcentage = pourcentage // et actualisation via un didSet
                
                if pourcentage == 1 {
                    gameTimer.pause()
                    gameOver(win: false, didTapABomb: false, didTimeEnd: true)
                }
            }
        }
    }
}


/// BONUS
// MARK: - Actions des boutons bonus via une délégation

extension HistoryGameViewController: BonusButtonsCanCallVC {
    func tempsTapped() { // il faut ajouter du temps
        if dataManager.tempsQuantity > 0 {
            dataManager.tempsQuantity -= 1
            bonusChoiceView!.updateTheNumberLabels()
            let timeLevel: Int = dataManager.tempsLevel
            let values: [CGFloat] = [15,30,45,60] // temps à rajouter
            gameTimer.counter -= values[timeLevel]
        }
    }
    
    func drapeauTapped() { // il faut ajouter des drapeaux
        if dataManager.drapeauQuantity > 0 {
            dataManager.drapeauQuantity -= 1
            bonusChoiceView!.updateTheNumberLabels()
            let drapeauLevel = dataManager.drapeauLevel
            let values: [Int] = [1,2,3] // drapeaux à ajouter
            // il faut le changer le nombre de drapeaux de la ViewOfGame (c'est elle qui s'en occupe)
            viewOfGame!.numberOfFlags += values[drapeauLevel]
        }
    }
    
    func bombeTapped() { // il faut marquer des bombes
        if dataManager.bombeQuantity > 0 {
            dataManager.bombeQuantity -= 1
            bonusChoiceView!.updateTheNumberLabels()
            viewOfGame!.markARandomBomb()
        }
    }
    
    func vieTapped() { // il faut rajouter une vie
        if dataManager.vieQuantity > 0 {
            dataManager.vieQuantity -= 1
            bonusChoiceView!.updateTheNumberLabels()
        }
    }
    
    func verificationTapped() { // il faut verifier les drapeaux posée
        if dataManager.verificationQuantity > 0 {
            dataManager.verificationQuantity -= 1
            bonusChoiceView!.updateTheNumberLabels()
            viewOfGame!.verificationBonusFunc()
        }
    }
    
}

// MARK: - Gere les transitions
extension HistoryGameViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented is WinLooseViewController {
            let transition = TransitionToWinLose()
            transition.animationDuration = 1.5
            return transition
        }
        return nil
    }
    
    @IBAction func unwindToHistoryGameViewController(segue: UIStoryboardSegue) {}
    
    func animateNextLevel() {
        
        UIView.animateKeyframes(withDuration: 1, delay: 0.3, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                for subview in self.view.subviews {
                    if subview is ClockView || subview.tag == -10 {
                        subview.alpha = 0
                    }
                }
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7, animations: {
                self.viewOfGame!.center.x -= self.view.frame.width
            })
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.3, animations: {
                for subview in self.view.subviews {
                    if subview is ClockView || subview.tag == -10 {
                        subview.alpha = 1
                    }
                }
            })
            self.removePrecendentViewOfGame()
            self.startANewGame(animatedFromTheRight: true)
            
        }
        
    }
}

// MARK: - POP-OVER : permet de faire apparaitre le bon message à la fin de partie si le joueur tape sur une bombe.
extension HistoryGameViewController {
    
    /// Cette fonction ajoute le message approprié quand l'utilisateur tape sur une bombe.
    func addTheMessage(didTapABomb: Bool) {
        if dataManager.vieQuantity > 0 {
            // faire apparaitre le message qui demande une nouvelle chance
            messageOne(didTapABomb: didTapABomb)
        } else {
            if dataManager.money > 0 {
                messageTwo(didTapABomb: didTapABomb)
            } else {
                self.gameTimer.stop()
                self.openTheBombs()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WinLooseVC") as! WinLooseViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                vc.precedentViewController = self
                vc.win = false
                vc.transitioningDelegate = self
                vc.didTapABomb = didTapABomb
                vc.precedentGameIndex = self.gameIndex
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    /// Faire apparaitre le message qui demande une nouvelle chance
    private func messageOne(didTapABomb: Bool) {
        
        var blurEffect: UIBlurEffect
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.frame //your view that have any objects
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
                for subview in self.viewOfGame!.subviews {
                    if subview is SquareCase || subview is HexCase || subview is TriangularCase {
                        for subview2 in subview.subviews {
                            if subview2 is BombView {
                                viewToRemove = subview2 as? BombView
                            }
                        }
                    }
                }
            } else {
                self.gameTimer.counter = 3*self.game.totalTime/4
                self.clockView.pourcentage = 0.75
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
                    self.gameTimer.play()
                    self.viewOfGame?.isUserInteractionEnabled = true
                    if self.game.option3 {
                        self.viewOfGame!.option3Timer.start(timeInterval: TimeInterval(self.game.option3Time), id: "Option3")
                    }
                    self.viewOfGame?.unPauseAllOption1Timers()
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
                self.gameTimer.stop()
                self.openTheBombs()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WinLooseVC") as! WinLooseViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                vc.precedentViewController = self
                vc.win = false
                vc.transitioningDelegate = self
                vc.didTapABomb = didTapABomb
                vc.precedentGameIndex = self.gameIndex
                self.present(vc, animated: true, completion: nil)
            })
            
        }
        no.frame = CGRect(x: yes.frame.maxX+separator, y: heart.frame.maxY + verticalSeparator, width: buttonsWidth, height: buttonsHeight)
        message.addSubview(no)
        
        // Positionnnement de la vue
        let height: CGFloat = 2*topSpace + label.bounds.height + heart.frame.height + yes.frame.height + 2*verticalSeparator
        let x = self.view.frame.width/2 - width/2
        let y = self.view.frame.height/2 - height/2 - 50
        message.frame = CGRect(x: x, y: y, width: width, height: height)
        
        blurView.contentView.addSubview(message)
        self.view.addSubview(blurView)
        UIView.animate(withDuration: 0.5, delay: 0.6, options: [], animations: {
            blurView.alpha = 0.8
        }, completion: nil)
    }
    
    /// Faire apparaitre la demande d'achat de vie pour une nouvelle chance
    func messageTwo(didTapABomb: Bool) {
        var blurEffect: UIBlurEffect
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.frame //your view that have any objects
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
                for subview in self.viewOfGame!.subviews {
                    if subview is SquareCase || subview is HexCase || subview is TriangularCase {
                        for subview2 in subview.subviews {
                            if subview2 is BombView {
                                viewToRemove = subview2 as? BombView
                            }
                        }
                    }
                }
            } else {
                self.gameTimer.counter = 3*self.game.totalTime/4
                self.clockView.pourcentage = 0.75
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
                    self.gameTimer.play()
                    self.viewOfGame!.isUserInteractionEnabled = true
                    if self.game.option3 {
                        self.viewOfGame!.option3Timer.start(timeInterval: TimeInterval(self.game.option3Time), id: "Option3")
                    }
                    self.viewOfGame!.unPauseAllOption1Timers()
                    
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
                self.gameTimer.stop()
                self.openTheBombs()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WinLooseVC") as! WinLooseViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                vc.precedentViewController = self
                vc.win = false
                vc.transitioningDelegate = self
                vc.didTapABomb = didTapABomb
                vc.precedentGameIndex = self.gameIndex
                self.present(vc, animated: true, completion: nil)
            })
            
        }
        no.frame = CGRect(x: buttonToBuy.frame.maxX+separator, y: label.frame.maxY + verticalSeparator, width: buttonNoWidth, height: buttonsHeight)
        message.addSubview(no)
        
        // Positionnnement de la vue
        let height: CGFloat = 2*topSpace + label.bounds.height /*+ heart.frame.height*/ + no.frame.height + 2*verticalSeparator
        let x = self.view.frame.width/2 - width/2
        let y = self.view.frame.height/2 - height/2 - 50
        message.frame = CGRect(x: x, y: y, width: width, height: height)
        
        blurView.contentView.addSubview(message)
        self.view.addSubview(blurView)
        UIView.animate(withDuration: 0.5, delay: 0.6, options: [], animations: {
            blurView.alpha = 0.8
        }, completion: nil)
    }
    
    /// Retourne la largeur que doit avoir le popover pour etre exactement à la taille des parties
    func widthForThePopover() -> CGFloat {
        return viewOfGame!.frame.width
    }
}
