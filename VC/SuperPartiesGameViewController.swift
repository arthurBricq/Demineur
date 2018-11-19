//
//  SuperPartiesGameViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 30/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.


import UIKit



/*
 
 Disposition of boxes:
 - The widht is the limiting dimension of the of those games
 - It means game has to be on a vertical scale, as the horizontal number of case is 'fixed'
 - It also means that the value of m is predefined (see in the SuperPartiesPresentationViewController)
 
 
 When exiting this view controller, saves the current game (characterized by n,m,z and gametype) to coreData so that we can get it back.
 For now, assume that the only one way to quit the game are:
- when using the pause menu --> just save
 - when winning --> must save the progress and delete the current game
 - when loosing --> must delete the current game
 
 
 */

class SuperPartiesGameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var flagsLabel: UILabel!
    @IBOutlet weak var flagView: FlagViewDisplay!
    @IBOutlet weak var bombsLabel: UILabel!
    @IBOutlet weak var bombView: BombViewDisplay!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Variables
    override var prefersStatusBarHidden: Bool { return true }
    var game: OneGame?
    var superPartieGame: SuperPartieGame?
    var gameState = [[Int]].init() {
        didSet {
            print(gameState)
        }
    }
    var viewOfGameSquare: ViewOfGameSquare?
    var viewOfGameHex: ViewOfGame_Hex?
    var viewOfGameTriangular: ViewOfGameTriangular?
    var numberOfBombs: Int = 0

    // MARK: - Actions
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        
        if game!.gameType == .square {
            viewOfGameSquare?.option3Timer.pause()
            viewOfGameSquare?.pauseAllOption1Timers()
        } else if game!.gameType == .hexagonal {
            viewOfGameHex?.option3Timer.pause()
            viewOfGameHex?.pauseAllOption1Timers()
        } else if game!.gameType == .triangular {
            viewOfGameTriangular?.option3Timer.pause()
            viewOfGameTriangular?.pauseAllOption1Timers()
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pauseVC = storyboard.instantiateViewController(withIdentifier: "Pause") as! PauseViewController
        pauseVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pauseVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pauseVC.pausedGameViewController = self
        self.present(pauseVC, animated: true, completion: nil)
        
    }

    
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instaurer les details techniques
        transitioningDelegate = nil
        isTheGameStarted.delegate = self
        startANewGame(animatedFromTheRight: false)
        
        // Scroll View settings
        // (zoom scales are setUp inside the function "startANewGame")
        scrollView.delegate = self
        scrollView.layer.zPosition = -1 // permet de placer la vue du jeu derrières l'interface
        scrollView.bounces = true // permet de faire rebondir sur les dépassements
        scrollView.clipsToBounds = false // Permet de faire dépasser le jeu sur tout l'écran de l'iphone
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateScrollViewDisplay()
    }
    
    public func saveGameToCoreData() {
        // Get the flags position
        // get the game state
        do {
            try AppDelegate.viewContext.save()
        } catch {
            print("ERROR: saving to core data ")
        }
    }
    
    public func deleteTheGameFromCoreData() {
        AppDelegate.viewContext.delete(superPartieGame!)
    }
    
    public func recordGameIsWonToCoreData() {
        deleteTheGameFromCoreData()
        // now save the new progress
        switch game!.gameType {
        case .square: dataManager.currentSuperPartiesLevels.square += 1
        case .hexagonal: dataManager.currentSuperPartiesLevels.hex += 1
        case .triangular: dataManager.currentSuperPartiesLevels.triangle += 1
        }
    }
    
    func startANewGame(animatedFromTheRight: Bool) {
        
        // instauration des drapeaux et des bombes sur l'écran
        if !game!.areNumbersShowed {
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
        
        // Quelques détails relatif aux timer et aux comptage
        isTheGameStarted.value = false
        updateFlags(numberOfFlags: game!.numberOfFlag)
        self.numberOfBombs = 0
        
        removePrecendentViewOfGame()
        
        let color1: UIColor = colorForRGB(r: 52, g: 61, b: 70)
        game!.colors = ColorSetForOneGame(openColor: colorForRGB(r: 192, g: 197, b: 206) , emptyColor: UIColor.white, strokeColor: color1, textColor: color1)
        
        switch game!.gameType {
        case .square:
            
            createANewSquareGameStepOne()
            
            /// Prenons 50 comme 1 côté d'un carré
            let cote: Int = 50
            let gameView = ViewOfGameSquare()
            gameView.n = game!.n
            gameView.m = game!.m
            gameView.z = game!.z
            gameView.ratio = 2
            gameView.frame = CGRect(x: 0, y: 0, width: cote*gameView.m, height: cote*gameView.n)
            gameView.gameState = gameState
            gameView.strokeColor = game!.colors.strokeColor
            gameView.openColor = game!.colors.openColor
            gameView.emptyColor = game!.colors.emptyColor
            gameView.textColor = game!.colors.textColor
            gameView.option1 = game!.option1
            gameView.option1Time = game!.option1Time
            gameView.option2 = game!.option2
            gameView.option2frequency = game!.option2Frequency
            gameView.layer.masksToBounds = false
            gameView.numberOfFlags = game!.numberOfFlag
            // Delegation
            gameView.delegate = self
            gameView.onPosingFlag = { (test: Bool) -> Void in
                if test {
                    // Incrémenter le nombre de bombes
                    self.numberOfBombs += 1
                }
            }
            
            viewOfGameSquare = gameView
            
            
            
            self.scrollView.addSubview(gameView)
            
            if game!.option3 {
                gameView.option3Timer.start(timeInterval: TimeInterval(game!.option3Time), id: "Option3")
                gameView.option3Frequency = game!.option3Frequency
                gameView.option3Timer.delegate = gameView
            }
            
            if animatedFromTheRight {
                UIView.animate(withDuration: 0.7) {
                    self.viewOfGameSquare?.center.x -= self.view.frame.width
                }
            }
            
        case .hexagonal:
            
            createANewHexGameStepOne() // première étape de la création
            
            let gameView = ViewOfGame_Hex()
            let a: CGFloat = 30
            let w: CGFloat = sqrt(3)*a // cote de 1 cube
            
            gameView.frame = CGRect(x: 0, y: 0, width: CGFloat(game!.m)*w , height: 3/2*a*CGFloat(game!.n))
            scrollView.contentSize = gameView.frame.size
            
            print("taille de la scroll")
            print(gameView.frame)
            
            gameView.a = a
            gameView.m = game!.m
            gameView.n = game!.n
            gameView.gameState = gameState
            gameView.backgroundColor = UIColor.clear
            gameView.emptyColor = UIColor.white
            gameView.openColor = UIColor.lightGray.withAlphaComponent(0.2)
            gameView.strokeColor = UIColor.black
            gameView.lineWidth = 1.0
            gameView.delegate = self
            gameView.option1 = game!.option1
            gameView.option1Time = game!.option1Time
            gameView.option2 = game!.option2
            gameView.option2frequency = game!.option2Frequency
            gameView.strokeColor = game!.colors.strokeColor
            gameView.openColor = game!.colors.openColor
            gameView.emptyColor = game!.colors.emptyColor
            gameView.textColor = game!.colors.textColor
            gameView.onPosingFlag = { (test: Bool) -> Void in
                if test {
                    // Incrémenter le nombre de bombes
                    self.numberOfBombs += 1
                }
            }
            
            gameView.numberOfFlags = game!.numberOfFlag
            
            if game!.option3 {
                gameView.option3Timer.start(timeInterval: TimeInterval(game!.option3Time), id: "Option3")
                gameView.option3Frequency = game!.option3Frequency
                gameView.option3Timer.delegate = gameView
            }
            
            viewOfGameHex = gameView
            self.scrollView.addSubview(viewOfGameHex!)
            
            if animatedFromTheRight {
                UIView.animate(withDuration: 0.7) {
                    self.viewOfGameHex?.center.x -= self.view.frame.width
                }
            }
        case .triangular:
            createNewTriangularGameStepOne()
            
            let gameView = ViewOfGameTriangular()
            let cote: CGFloat = 40 // cote d'un triangle
            let hauteur = cote * sqrt(3) / 2
            
            
            gameView.frame = CGRect(origin: CGPoint.zero, size: CGSize.init(width: CGFloat(game!.m+1)*cote/2, height: hauteur * CGFloat(game!.n)))
            
            gameView.m = game!.m
            gameView.n = game!.n
            gameView.gameState = gameState
            gameView.backgroundColor = UIColor.clear
            gameView.emptyColor = game!.colors.emptyColor
            gameView.openColor = game!.colors.openColor
            gameView.strokeColor = game!.colors.strokeColor
            gameView.textColor = game!.colors.textColor
            
            gameView.lineWidth = 1.0
            gameView.delegateVC = self
            gameView.option1 = game!.option1
            gameView.option1Time = game!.option1Time
            gameView.option2 = game!.option2
            gameView.option2frequency = game!.option2Frequency
            gameView.numberOfFlags = game!.numberOfFlag
            gameView.onPosingFlag = { (test: Bool) -> Void in
                if test {
                    // Incrémenter le nombre de bombes
                    self.numberOfBombs += 1
                }
            }
            viewOfGameTriangular = gameView
            
            self.scrollView.addSubview(viewOfGameTriangular!)
            
            if game!.option3 {
                gameView.option3Timer.start(timeInterval: TimeInterval(game!.option3Time), id: "Option3")
                gameView.option3Frequency = game!.option3Frequency
                gameView.option3Timer.delegate = gameView
            }
            
            if animatedFromTheRight {
                UIView.animate(withDuration: 0.7) {
                    self.viewOfGameTriangular?.center.x -= self.view.frame.width
                }
            }
        
        }
        
    }
    
    /// This function restarts the current game
    func restartTheGame() {
        removePrecendentViewOfGame()
        startANewGame(animatedFromTheRight: false)
    }
   
    /// Permet d'actualiser l'ecran durant une partie. 
    func updateFlags(numberOfFlags: Int) {
        flagsLabel.text = numberOfFlags.description
        bombsLabel.text = game!.z.description
    }
    
    func updateScrollViewDisplay() {
        // Terminer d'actualiser la scrollView
        switch game!.gameType {
        case .square:
            scrollView.contentSize = viewOfGameSquare!.frame.size
        case .hexagonal:
            scrollView.contentSize = viewOfGameHex!.frame.size
        case .triangular:
            scrollView.contentSize = viewOfGameTriangular!.frame.size
        }
        // Set the zooming scale
        /*
         We have the critical value of n
         We have the content size of the scroll view
         We have the size of the scroll view
        */
        
        let widthOfScrollView = scrollView.frame.width
        let widhtOfGameView = scrollView.contentSize.width
        
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = widthOfScrollView/widhtOfGameView
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
        if game!.gameType == .square {
            if viewOfGameSquare != nil {
                viewOfGameSquare!.returnAllTheCases()
            }
        } else if game!.gameType == .hexagonal {
            if viewOfGameHex != nil {
                viewOfGameHex!.returnAllTheCases()
            }
        } else if game!.gameType == .triangular {
            if viewOfGameTriangular != nil {
                viewOfGameTriangular!.returnAllTheCases()
            }
        }
    }
    
}



// MARK: - Creation d'une nouvelle partie
// Ces fontions vont modifier le gameState, qui sera ensuite envoyé aux gameView.
extension SuperPartiesGameViewController {
    
    ///// SQUARE
    /// Cette fonction est appelée au tout début d'une partie, avant que le joueur ne tape sur l'ecran pour ouvrir la premiere case.
    func createANewSquareGameStepOne() {
        gameState = createEmptySquareGameState(n: game!.n, m: game!.m)
        positionNoneCaseSquare(noneCases: game!.noneCasesPosition, in: &gameState)
        // Opening the first case of the game here
    }
    
    /// Cette fonction est appelée après que le joueur est tapé sur le première case qu'il souhaite ouvrir.
    func updateSquareGame(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsSquare(in: &gameState, numberOfBombs: game!.z, withFirstTouched: (touch.x,touch.y))
        createNumbersToDisplaySquare(in: &gameState)
        viewOfGameSquare!.gameState = gameState
        viewOfGameSquare!.updateAllNumbers()
    }
    
    ///// HEX
    func createANewHexGameStepOne() {
        gameState = createEmptyHexGameState(n: game!.n, m: game!.m)
        positionNoneCaseHex(noneCases: game!.noneCasesPosition, gameState: &gameState)
    }
    
    func updateHexGameState(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsHex(gameState: &gameState, z: game!.z, withFirstTouched: (touch.x, touch.y))
        createNumbersToDisplayHex(gameState: &gameState)
        viewOfGameHex!.gameState = gameState // on actualise la nouvelle carte du jeu
        viewOfGameHex!.updateAllNumbers()
    }
    
    ///// TRIANGLE
    func createNewTriangularGameStepOne() {
        gameState = createEmptySquareGameState(n: game!.n, m: game!.m)
        positionNoneCaseSquare(noneCases: game!.noneCasesPosition, in: &gameState)
    }
    
    func updateTriangularGameStepTwo(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsSquare(in: &gameState, numberOfBombs: game!.z, withFirstTouched: (touch.x,touch.y), isTriangular: true)
        createNumbersToDisplayTriangle(in: &gameState)
        viewOfGameTriangular!.gameState = gameState
        viewOfGameTriangular!.updateAllNumbers()
    }
    
    
}

// MARK: - Délégation pour le gameView (fin de la partie)
extension SuperPartiesGameViewController: GameViewCanCallVC {
    
    func gameOver(win: Bool, didTapABomb: Bool, didTimeEnd: Bool) {
        
        Vibrate().vibrate(style: .heavy)
        
        if game!.gameType == .hexagonal {
            viewOfGameHex!.isUserInteractionEnabled = false
            viewOfGameHex!.option3Timer.stop()
            viewOfGameHex?.pauseAllOption1Timers()
        } else if game!.gameType == .square {
            viewOfGameSquare!.isUserInteractionEnabled = false
            viewOfGameSquare!.option3Timer.stop()
            viewOfGameSquare?.pauseAllOption1Timers()
        } else if game!.gameType == .triangular {
            viewOfGameTriangular!.isUserInteractionEnabled = false
            viewOfGameTriangular!.option3Timer.stop()
            viewOfGameTriangular?.pauseAllOption1Timers()
        }
        
        if didTapABomb || didTimeEnd {
            addTheMessage(didTapABomb: didTapABomb)
        } else {
            
            
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
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    func updateFlagsDisplay(numberOfFlags: Int) {
        updateFlags(numberOfFlags: numberOfFlags)
    }
    
}



// MARK: - Délégation pour les variables (commencer une partie)
extension SuperPartiesGameViewController: variableCanCallGameVC {
    
    /// cette fonction est appelée lorsque l'utilisateur tape sur la première case : cela apelle cette fonction immédiatement avec le touches began, puis la partie commence comme il le faut grâce au touchesEnded.
    func createTheGame(withFirstTouched touch: (x: Int, y: Int)) {
        
        if game!.gameType == .hexagonal {
            updateHexGameState(withFirstTouched: (touch.x,touch.y))
        } else if game!.gameType == .square {
            updateSquareGame(withFirstTouched: (touch.x,touch.y))
        } else if game!.gameType == .triangular {
            updateTriangularGameStepTwo(withFirstTouched: (touch.x,touch.y))
        }
        
        // TODO : Activate the bonus bar
        
    }
}


// MARK: - Scroll View
extension SuperPartiesGameViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        if game!.gameType == .square {
            return viewOfGameSquare
        } else if game!.gameType == .triangular {
            return viewOfGameTriangular
        } else {
            return viewOfGameHex!
        }
    }
}

// MARK: - Gere les transitions
extension SuperPartiesGameViewController: UIViewControllerTransitioningDelegate {
    
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
                switch self.game!.gameType {
                case .square:
                    self.viewOfGameSquare?.center.x -= self.view.frame.width
                case .hexagonal:
                    self.viewOfGameHex?.center.x -= self.view.frame.width
                case .triangular:
                    self.viewOfGameTriangular?.center.x -= self.view.frame.width
                }
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

// MARK: - PARTIE POP-OVER : permet de faire apparaitre le bon message à la fin de partie si le joueur tape sur une bombe.
extension SuperPartiesGameViewController {
    
    /// Cette fonction ajoute le message approprié quand l'utilisateur tape sur une bombe.
    func addTheMessage(didTapABomb: Bool) {
        if dataManager.vieQuantity > 0 {
            // faire apparaitre le message qui demande une nouvelle chance
            messageOne(didTapABomb: didTapABomb)
        } else {
            if dataManager.money > 0 {
                messageTwo(didTapABomb: didTapABomb)
            } else {
                self.openTheBombs()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WinLooseVC") as! WinLooseViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                vc.precedentViewController = self
                vc.win = false
                vc.transitioningDelegate = self
                vc.didTapABomb = didTapABomb
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    /// Faire apparaitre le message qui demande une nouvelle chance
    func messageOne(didTapABomb: Bool) {
        
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
        let verticalSeparator: CGFloat = 15
        let width = self.view.frame.width * 0.8
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
            var viewOfGame: UIView?
            
            switch self.game!.gameType {
            case .square:
                viewOfGame = self.viewOfGameSquare
            case .hexagonal:
                viewOfGame = self.viewOfGameHex
            case .triangular:
                viewOfGame = self.viewOfGameTriangular
            }
            
            if didTapABomb {
                for subview in viewOfGame!.subviews {
                    if subview is SquareCase || subview is HexCase || subview is TriangularCase {
                        for subview2 in subview.subviews {
                            if subview2 is BombView {
                                viewToRemove = subview2 as? BombView
                            }
                        }
                    }
                }
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
                    
                    if self.game!.gameType == .hexagonal {
                        self.viewOfGameHex!.isUserInteractionEnabled = true
                        if self.game!.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game!.option3Time), id: "Option3")
                        }
                        self.viewOfGameHex?.unPauseAllOption1Timers()
                    } else if self.game!.gameType == .square {
                        self.viewOfGameSquare!.isUserInteractionEnabled = true
                        if self.game!.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game!.option3Time), id: "Option3")
                        }
                        self.viewOfGameSquare?.unPauseAllOption1Timers()
                    } else if self.game!.gameType == .triangular {
                        self.viewOfGameTriangular!.isUserInteractionEnabled = true
                        if self.game!.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game!.option3Time), id: "Option3")
                        }
                        self.viewOfGameTriangular?.unPauseAllOption1Timers()
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
                self.openTheBombs()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WinLooseVC") as! WinLooseViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                vc.precedentViewController = self
                vc.win = false
                vc.transitioningDelegate = self
                vc.didTapABomb = didTapABomb
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
        let width = self.view.frame.width * 0.8
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
            var viewOfGame: UIView?
            
            switch self.game!.gameType {
            case .square:
                viewOfGame = self.viewOfGameSquare
            case .hexagonal:
                viewOfGame = self.viewOfGameHex
            case .triangular:
                viewOfGame = self.viewOfGameTriangular
            }
            
            if didTapABomb {
                for subview in viewOfGame!.subviews {
                    if subview is SquareCase || subview is HexCase || subview is TriangularCase {
                        for subview2 in subview.subviews {
                            if subview2 is BombView {
                                viewToRemove = subview2 as? BombView
                            }
                        }
                    }
                }
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
                    
                    if self.game!.gameType == .hexagonal {
                        self.viewOfGameHex!.isUserInteractionEnabled = true
                        if self.game!.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game!.option3Time), id: "Option3")
                        }
                        self.viewOfGameHex?.unPauseAllOption1Timers()
                    } else if self.game!.gameType == .square {
                        self.viewOfGameSquare!.isUserInteractionEnabled = true
                        if self.game!.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game!.option3Time), id: "Option3")
                        }
                        self.viewOfGameSquare?.unPauseAllOption1Timers()
                    } else if self.game!.gameType == .triangular {
                        self.viewOfGameTriangular!.isUserInteractionEnabled = true
                        if self.game!.option3 {
                            self.viewOfGameHex!.option3Timer.start(timeInterval: TimeInterval(self.game!.option3Time), id: "Option3")
                        }
                        self.viewOfGameTriangular?.unPauseAllOption1Timers()
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
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WinLooseVC") as! WinLooseViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                vc.precedentViewController = self
                vc.win = false
                vc.transitioningDelegate = self
                vc.didTapABomb = didTapABomb
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
        
        if game!.gameType == .square {
            toReturn = viewOfGameSquare!.frame.width
        } else if game!.gameType == .hexagonal {
            toReturn = viewOfGameHex!.frame.width
        } else if game!.gameType == .triangular {
            toReturn = viewOfGameTriangular!.frame.width
        }
        
        return toReturn
        
    }
    
}

// TODO: add extensions for the bonus bar
