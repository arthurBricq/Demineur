//
//  HistoryGameViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 12/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class HistoryGameViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var flagsLabel: UILabel!
    @IBOutlet weak var flagView: FlagViewDisplay!
    @IBOutlet weak var bombsLabel: UILabel!
    @IBOutlet weak var bombView: BombViewDisplay!
   
    
    var bonusChoiceView: BonusChoiceView?
    var game: OneGame = OneGame(gameTypeWithNoneCases: .square, n: 10, m: 10, z: 5, numberOfFlag: 5, isTimerAllowed: false, totalTime: 0, option1: false, option2: false, option1Time: 0, option2Frequency: 0, option3: false, option3Frequency: 0, option3Time: 0, noneCases: [], areNumbersShowed: true) // cette variable s'occupe de toute la partie à jouer.
    var gameIndex: Int = 1 // Avoir connaissance de l'indice du niveau
    
    var gameState = [[Int]].init()
    var gameTimer = CountingTimer()
    
    var viewOfGameSquare: ViewOfGameSquare?
    var viewOfGameHex: ViewOfGame_Hex?
    var viewOfGameTriangular: ViewOfGameTriangular?
    
    /// ACTION A RETIRER PAR LA SUITE
    @IBAction func returnToPresentation(_ sender: Any) {
        self.dismiss(animated: true , completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        transitioningDelegate = nil

        isTheGameStarted.delegate = self // Cela permet, via cette variable, d'appeller le VC qui s'occupe du jeu.
        
        startANewGame()
        
        /// Affichage de la taille disponible à l'ecran
        /**
        let p1 = clockView.frame.origin
        let h1 = clockView.frame.height
        let h11 = p1.y + h1
        let p2 = bonusChoiceView?.frame.origin
        let H = self.view.frame.height
        let h22 = H - p2!.y
        let usableHeigth = H - h11 - h22
        print("ANALYSE DE TAILLE")
        print("taille utilisable: \(usableHeigth)")
        print("h11:\(h11) & h22:\(h22) & H:\(H)")
        **/
     
        
        
        
        
        
        
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
    
    func startANewGame() {
        
        // instauration du timer sur l'écran
        if !game.isTimerAllowed {
            clockView.isHidden = true
            gameTimer.stop()
            gameTimer.delegate = nil
        } else {
            clockView.isHidden = false
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
        
        // Quelques détails relatif aux timer
        gameTimer.stop()
        clockView.pourcentage = 0.0
        isTheGameStarted.value = false
        updateFlags(numberOfFlags: game.numberOfFlag)
        
        // Tailles maximales occupées par la vue :
        let maxHeight = self.view.bounds.height * 0.65
        let multiplier: CGFloat = isItABigScreen() ? 0.98 : 0.92
        let maxWidth = game.gameType == .square ? self.view.bounds.width * multiplier : self.view.bounds.width * 0.95
        
        // print("pourcentage utile de la largeur: \(maxWidth/self.view.frame.width)")
        // print("taille utile pour la largueur: \(maxWidth)")
        
        removePrecendentViewOfGame()
        
        let color1: UIColor = colorForRGB(r: 52, g: 61, b: 70)
        game.colors = ColorSetForOneGame(openColor: colorForRGB(r: 192, g: 197, b: 206) , emptyColor: UIColor.white, strokeColor: color1, textColor: color1)
        
        // Ajouter les vues du jeu
        if game.gameType == .square {
            createANewSquareGameStepOne()
            
            let gameView = ViewOfGameSquare()
            //gameView.layer.borderWidth = 2.0
            //gameView.layer.borderColor = game.colors.strokeColor.cgColor
            let (width, height) = dimensionSquareTable(n: game.n, m: game.m, withMaximumWidth: maxWidth, withMaximumHeight: maxHeight)
            let viewSize = CGSize(width: width, height: height)
            let origin = CGPoint(x: self.view.center.x - width/2, y: self.view.center.y - height/2)
            gameView.frame = CGRect(origin: origin, size: viewSize)
            gameView.backgroundColor = UIColor.clear
            gameView.n = game.n
            gameView.m = game.m
            gameView.ratio = 2
            gameView.gameState = gameState
            gameView.delegate = self
            gameView.option1 = game.option1
            gameView.option1Time = game.option1Time
            gameView.option2 = game.option2
            gameView.option2frequency = game.option2Frequency
            gameView.isUserInteractionEnabled = true
            gameView.strokeColor = game.colors.strokeColor
            gameView.openColor = game.colors.openColor
            gameView.emptyColor = game.colors.emptyColor
            gameView.textColor = game.colors.textColor
            gameView.layer.masksToBounds = false
            gameView.numberOfFlags = game.numberOfFlag
            
            if game.option3 {
                gameView.option3Timer.start(timeInterval: TimeInterval(game.option3Time), id: "Option3")
                gameView.option3Frequency = game.option3Frequency
                gameView.option3Timer.delegate = gameView
            }
            
            viewOfGameSquare = gameView
            self.view.addSubview(viewOfGameSquare!)
            
        } else if game.gameType == .hexagonal {
            
            createANewHexGameStepOne() // première étape de la création
            
            let gameView = ViewOfGame_Hex()
            //gameView.layer.borderWidth = 2.0
            //gameView.layer.borderColor = UIColor.red.cgColor
            let center = self.view.center
            let (w,h) = dimensionHexTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let origin = CGPoint(x: center.x - w/2, y: center.y - h/2)
            gameView.frame = CGRect(origin: origin, size: CGSize.init(width: w, height: h))
            gameView.a = w / (sqrt(3) * CGFloat(game.m))
            gameView.m = game.m
            gameView.n = game.n
            gameView.gameState = gameState
            gameView.backgroundColor = UIColor.clear
            gameView.emptyColor = UIColor.white
            gameView.openColor = UIColor.lightGray.withAlphaComponent(0.2)
            gameView.strokeColor = UIColor.black
            gameView.lineWidth = 1.0
            gameView.delegate = self
            gameView.option1 = game.option1
            gameView.option1Time = game.option1Time
            gameView.option2 = game.option2
            gameView.option2frequency = game.option2Frequency
            gameView.isUserInteractionEnabled = true
            gameView.strokeColor = game.colors.strokeColor
            gameView.openColor = game.colors.openColor
            gameView.emptyColor = game.colors.emptyColor
            gameView.textColor = game.colors.textColor
            
            gameView.numberOfFlags = game.numberOfFlag
            
            if game.option3 {
                gameView.option3Timer.start(timeInterval: TimeInterval(game.option3Time), id: "Option3")
                gameView.option3Frequency = game.option3Frequency
                gameView.option3Timer.delegate = gameView
            }
            
            viewOfGameHex = gameView
            
            self.view.addSubview(viewOfGameHex!)
            
        } else if game.gameType == .triangular {
            createNewTriangularGameStepOne()
            
            let gameView = ViewOfGameTriangular()
            
            //gameView.layer.borderWidth = 2.0
            //gameView.layer.borderColor = UIColor.red.cgColor
            
            let center = self.view.center
            let (w,h) = dimensionTriangularTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let origin = CGPoint(x: center.x - w/2, y: center.y - h/2)
            
            gameView.frame = CGRect(origin: origin, size: CGSize.init(width: w, height: h))
            gameView.m = game.m
            gameView.n = game.n
            gameView.gameState = gameState
            gameView.backgroundColor = UIColor.clear
            gameView.emptyColor = game.colors.emptyColor
            gameView.openColor = game.colors.openColor
            gameView.strokeColor = game.colors.strokeColor
            gameView.textColor = game.colors.textColor
            
            gameView.lineWidth = 1.0
            gameView.delegateVC = self
            gameView.option1 = game.option1
            gameView.option1Time = game.option1Time
            gameView.option2 = game.option2
            gameView.option2frequency = game.option2Frequency
            gameView.isUserInteractionEnabled = true
            gameView.numberOfFlags = game.numberOfFlag
            
            viewOfGameTriangular = gameView
            
            if game.option3 {
                gameView.option3Timer.start(timeInterval: TimeInterval(game.option3Time), id: "Option3")
                gameView.option3Frequency = game.option3Frequency
                gameView.option3Timer.delegate = gameView
            }
            
            self.view.addSubview(viewOfGameTriangular!)
        }
    }
    
    /// retire tous les view of game qui sont présent sur l'écran. Il faut penser à rajouter une nouvelle vue avec 'startANewGame()' après faire l'appel de cette fonction.
    func removePrecendentViewOfGame()
    {
        
        if viewOfGameSquare != nil {
            viewOfGameSquare?.removeFromSuperview()
        }
        
        if viewOfGameHex != nil {
            viewOfGameHex?.removeFromSuperview()
        }
        
        if viewOfGameTriangular != nil {
            viewOfGameTriangular?.removeFromSuperview()
        }
        
    }
    
    func openTheBombs() {
        if game.gameType == .square {
            if viewOfGameSquare != nil {
                viewOfGameSquare!.returnAllTheCases()
            }
        } else if game.gameType == .hexagonal {
            if viewOfGameHex != nil {
                viewOfGameHex!.returnAllTheCases()
            }
        } else if game.gameType == .triangular {
            if viewOfGameTriangular != nil {
                viewOfGameTriangular!.returnAllTheCases()
            }
        }
    }
    
    
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        gameTimer.pause()
        
        if game.gameType == .square {
            viewOfGameSquare?.option3Timer.pause()
        } else if game.gameType == .hexagonal {
            viewOfGameHex?.option3Timer.pause()
        } else if game.gameType == .triangular {
            viewOfGameTriangular?.option3Timer.pause()
        }
        
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
    
}

// *********** Creation d'une nouvelle partie **************** //
extension HistoryGameViewController {
    
    ///// SQUARE
    func createANewSquareGameStepOne() {
        gameState = createEmptySquareGameState(n: game.n, m: game.m)
        positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameState)
    }
    
    func updateSquareGame(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsSquare(in: &gameState, numberOfBombs: game.z, withFirstTouched: (touch.x,touch.y))
        createNumbersToDisplaySquare(in: &gameState)
        viewOfGameSquare!.gameState = gameState
        viewOfGameSquare!.updateAllNumbers()
    }
    
    ///// HEX
    func createANewHexGameStepOne() {
        gameState = createEmptyHexGameState(n: game.n, m: game.m)
        positionNoneCaseHex(noneCases: game.noneCasesPosition, gameState: &gameState)
    }
    
    func updateHexGameState(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsHex(gameState: &gameState, z: game.z, withFirstTouched: (touch.x, touch.y))
        createNumbersToDisplayHex(gameState: &gameState)
        viewOfGameHex!.gameState = gameState // on actualise la nouvelle carte du jeu
        viewOfGameHex!.updateAllNumbers()
    }
    
    ///// TRIANGLE
    func createNewTriangularGameStepOne() {
        gameState = createEmptySquareGameState(n: game.n, m: game.m)
        positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameState)
    }
    
    func updateTriangularGameStepTwo(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsSquare(in: &gameState, numberOfBombs: game.z, withFirstTouched: (touch.x,touch.y), isTriangular: true)
        createNumbersToDisplayTriangle(in: &gameState)
        viewOfGameTriangular!.gameState = gameState
        viewOfGameTriangular!.updateAllNumbers()
    }
}

// Quand la partie est terminée
extension HistoryGameViewController: GameViewCanCallVC {
    
    func gameOver(win: Bool, didTapABomb: Bool) {
        gameTimer.pause()
        // finish the game
        
        
        if game.gameType == .hexagonal {
            viewOfGameHex!.isUserInteractionEnabled = false
            viewOfGameHex!.option3Timer.stop()
        } else if game.gameType == .square {
            viewOfGameSquare!.isUserInteractionEnabled = false
            viewOfGameSquare!.option3Timer.stop()
        } else if game.gameType == .triangular {
            viewOfGameTriangular!.isUserInteractionEnabled = false
            viewOfGameTriangular!.option3Timer.stop()
        }
        
        if win {
            Vibrate().vibrate(style: .heavy)
        } else {
            Vibrate().vibrate(style: .heavy)
        }
        
        if didTapABomb {
            addTheMessage()
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

// Pour le chronomètre
extension HistoryGameViewController: CountingTimerProtocol {
    
    func timerFires(id: String) {
        // In this case, the id does not matter at all.
        // This method is called each second.
        
        if id == "Clock" {
            
            if game.isTimerAllowed {
                let pourcentage: CGFloat = gameTimer.counter / CGFloat(game.totalTime) // ratio of time used.
                
                clockView.pourcentage = pourcentage // et actualisation via un didSet
                
                if pourcentage == 1 {
                    gameTimer.stop()
                    gameOver(win: false, didTapABomb: false)
                    openTheBombs()
                    
                    
                    // show all the bombs
                    for subview in view.subviews {
                        if subview is ViewOfGameSquare {
                            let gameView = subview as! ViewOfGameSquare
                            gameView.returnAllTheCases()
                        } else if subview is ViewOfGame_Hex {
                            let gameView = subview as! ViewOfGame_Hex
                            gameView.returnAllTheCases()
                        } else if subview is ViewOfGameTriangular {
                            let gameView = subview as! ViewOfGameTriangular
                            gameView.returnAllTheCases()
                        }
                    }
                    
                    
                }
            }
        }
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


/// BONUS
/// Actions des boutons bonus via une délégation.
extension HistoryGameViewController: BonusButtonsCanCallVC {
    func tempsTapped() { // il faut ajouter du temps
        
        if bonus.temps > 0 {
            bonus.addTemps(amount: -1)
            bonusChoiceView!.updateTheNumberLabels()
        } else {
            return
        }
        
        let timeLevel: Int = levelOfBonus.giveTheLevelOfBonus(forIndex: 0)
        let values: [CGFloat] = [15,30,45,60] // temps à rajouter
        gameTimer.counter -= values[timeLevel]
    }
    
    func drapeauTapped() { // il faut ajouter des drapeaux
        
        if bonus.drapeau > 0 {
            bonus.addDrapeau(amount: -1)
            bonusChoiceView!.updateTheNumberLabels()
        } else {
            return
        }
        
        let drapeauLevel = levelOfBonus.giveTheLevelOfBonus(forIndex: 1)
        let values: [Int] = [1,2,3] // drapeaux à ajouter
        // il faut le changer le nombre de drapeaux de la ViewOfGame (c'est elle qui s'en occupe)
        if game.gameType == .hexagonal {
            viewOfGameHex?.numberOfFlags += values[drapeauLevel]
        } else if game.gameType == .square {
            viewOfGameSquare?.numberOfFlags += values[drapeauLevel]
        } else if game.gameType == .triangular {
            viewOfGameTriangular?.numberOfFlags += values[drapeauLevel]
        }
        
    }
    
    
    
    //// A FAIRE ////
    func bombeTapped() { // il faut marquer des bombes
        
        if bonus.bombe > 0 {
            bonus.addBomb(amount: -1)
            bonusChoiceView!.updateTheNumberLabels()
        } else {
            return
        }
                
        switch levelOfBonus.bombe {
        case 0:
            // 50 % de chance
            let tmp = random(100)
            if tmp < 50 {
                // return
            }
            // marquer une bombe non marquée
            
            if game.gameType == .hexagonal {
                viewOfGameHex?.markARandomBomb()
            } else if game.gameType == .square {
                viewOfGameSquare?.markARandomBomb()
            } else if game.gameType == .triangular {
                viewOfGameTriangular?.markARandomBomb()
            }
            
        default:
            break
        }
        
        
        
    }
    
    func vieTapped() { // il faut rajouter une vie
        if bonus.vie > 0 {
            bonus.addVie(amount: -1)
            bonusChoiceView!.updateTheNumberLabels()
        } else {
            return
        }
    }
    
    
    
    //// A FAIRE ////
    func verificationTapped() { // il faut verifier les drapeaux posée
        if bonus.verification > 0 {
            bonus.addVerification(amount: -1)
            bonusChoiceView!.updateTheNumberLabels()
        } else {
            return
        }
        
        
        
    }
    
    
}

/// Pour passer au niveau suivant lorsqu'on termine un niveau, il faut un unwindSegue
extension HistoryGameViewController {
    @IBAction func unwindToHistoryGameViewController(segue: UIStoryboardSegue) {
        //
    }
}

// Gere les transitions vers les autres VC
extension HistoryGameViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented is WinLooseViewController {
            let transition = TransitionToWinLose()
            transition.animationDuration = 1.5
            return transition
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

/// PARTIE POP-OVER : permet de faire apparaitre le bon message à la fin de partie si le joueur tape sur une bombe.
extension HistoryGameViewController {
    
    /// Cette fonction ajoute le message approprié quand l'utilisateur tape sur une bombe.
    func addTheMessage() {
        if bonus.vie > 0 {
            // faire apparaitre le message qui demande une nouvelle chance
            messageOne()
        } else {
            
            if money.getCurrentValue() > 0 {
                messageTwo()
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
                vc.didTapABomb = true
                vc.precedentGameIndex = self.gameIndex
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    /// Faire apparaitre le message qui demande une nouvelle chance
    func messageOne() {
        
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
        heartLabel.text = String(bonus.vie)
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
            
            bonus.addVie(amount: -1)
            
            var viewToRemove: BombView?
            var viewOfGame: UIView?
            
            switch self.game.gameType {
            case .square:
                viewOfGame = self.viewOfGameSquare
            case .hexagonal:
                viewOfGame = self.viewOfGameHex
            case .triangular:
                viewOfGame = self.viewOfGameTriangular
            }
            
            for subview in viewOfGame!.subviews {
                if subview is SquareCase || subview is HexCase || subview is TriangularCase {
                    for subview2 in subview.subviews {
                        if subview2 is BombView {
                            viewToRemove = subview2 as? BombView
                        }
                    }
                }
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                heartLabel.alpha = 0
            }, completion: { (_) in
                heartLabel.text = String(bonus.vie)
                
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
                    
                    if self.game.gameType == .hexagonal {
                        self.viewOfGameHex!.isUserInteractionEnabled = true
                        if self.game.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game.option3Time), id: "Option3")
                        }
                    } else if self.game.gameType == .square {
                        self.viewOfGameSquare!.isUserInteractionEnabled = true
                        if self.game.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game.option3Time), id: "Option3")
                        }
                    } else if self.game.gameType == .triangular {
                        self.viewOfGameTriangular!.isUserInteractionEnabled = true
                        if self.game.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game.option3Time), id: "Option3")
                        }
                    }
                    
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
                vc.didTapABomb = true
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
    func messageTwo() {
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
        coinLabel.text = String(money.currentAmountOfMoney)
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
            money.addMoney(amount: -allBonus[4].prixAchat)
            
            var viewToRemove: BombView?
            var viewOfGame: UIView?
            
            switch self.game.gameType {
            case .square:
                viewOfGame = self.viewOfGameSquare
            case .hexagonal:
                viewOfGame = self.viewOfGameHex
            case .triangular:
                viewOfGame = self.viewOfGameTriangular
            }
            
            for subview in viewOfGame!.subviews {
                if subview is SquareCase || subview is HexCase || subview is TriangularCase {
                    for subview2 in subview.subviews {
                        if subview2 is BombView {
                            viewToRemove = subview2 as? BombView
                        }
                    }
                }
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                coinLabel.alpha = 0
            }, completion: { (_) in
                coinLabel.text = String(money.getCurrentValue())
                
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
                    
                    if self.game.gameType == .hexagonal {
                        self.viewOfGameHex!.isUserInteractionEnabled = true
                        if self.game.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game.option3Time), id: "Option3")
                        }
                    } else if self.game.gameType == .square {
                        self.viewOfGameSquare!.isUserInteractionEnabled = true
                        if self.game.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game.option3Time), id: "Option3")
                        }
                    } else if self.game.gameType == .triangular {
                        self.viewOfGameTriangular!.isUserInteractionEnabled = true
                        if self.game.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game.option3Time), id: "Option3")
                        }
                    }
                    
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
                vc.didTapABomb = true
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
        
        var toReturn: CGFloat = 100
        
        if game.gameType == .square {
            toReturn = viewOfGameSquare!.frame.width
        } else if game.gameType == .hexagonal {
            toReturn = viewOfGameHex!.frame.width
        } else if game.gameType == .triangular {
            toReturn = viewOfGameTriangular!.frame.width
        }
        
        return toReturn
        
    }
    
}

