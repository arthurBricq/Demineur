//
//  InfiniteGameViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 20/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//


import UIKit

class InfiniteGameViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var bombCounterLabel: UILabel!
    @IBOutlet weak var bombView: BombViewDisplay!
    @IBOutlet weak var flagCounterLabel: UILabel!
    @IBOutlet weak var flagView: FlagViewDisplay!
    @IBOutlet weak var pauseButton: PauseButton!
    
    // MARK: - VARIABLES
    
    var blockingView: UIView? = UIView()
    // Cette variable s'occupe de contenir les parties du jeu comme ses subview
    var containerView = UIView()
    var sectionIndex: Int = 0
    var gameIndex: Int = 1
    // Is the number of correct flags put
    var numberOfBombs: Int = 0
    // Is the current level
    var level: Int = 1
    var emptyGameState = [[Int]].init()
    var gameState = [[Int]].init()
    var currentSection = Section(simpleHexGameWith: (11,9))
//    var gameTimer = CountingTimer()
    var animationTimer = CountingTimer()
    // This variable is used in order to call only once the function 'currentGameIsFinished'. Indeed, it is called many times for a very strange reason.
    var hasToFinishTheGame: Bool = true
    
    var bonusChoiceView: BonusChoiceView?
    var messageManager: MessageManagor?
    var gameManager = InfiniteGameManager() // permet de s'occuper de la logique du mode infinie.
    
    
    // MARK: - ACTIONS
    
    /*@IBAction func buttonReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newsectionbutton(_ sender: Any) {
        sectionIndex += 1
        startNewSection()
    }*/
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        // Pause the game
        getCurrentViewOfGame().pauseTimers()
        // Open the pause menu
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pauseVC = storyboard.instantiateViewController(withIdentifier: "Pause") as! PauseViewController
        pauseVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pauseVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pauseVC.pausedGameViewController = self
        self.present(pauseVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Fonctions pour le déroulement d'une partie
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Set the container view
        let containerWidth = self.view.frame.width*0.95
        let containerHeight = self.view.frame.height * (isItABigScreen() ? 0.7 : 0.8 )
        let ox = view.frame.width/2 - containerWidth/2
        let oy = (isItABigScreen() ? 0.16 : 0.10) * view.frame.height
        containerView.frame = CGRect(x: ox, y: oy, width: containerWidth, height: containerHeight)
        containerView.backgroundColor = UIColor.clear
        containerView.layer.borderColor = UIColor.red.cgColor
        containerView.layer.borderWidth = 0.0
        self.view.addSubview(containerView)
        
        setColors()
        
    }
    
    func setColors() {
        self.view.backgroundColor = Color.getColor(index: 0)
        bombCounterLabel.textColor = Color.getColor(index: 3)
        bombCounterLabel.setNeedsDisplay()
        flagCounterLabel.textColor = Color.getColor(index: 3)
        flagCounterLabel.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clockView.alpha = 0
        isTheGameStarted.delegate = self
        startNewSection()
        addTheBonusChoiceView()
        // Set the message managor (to be updated)
        messageManager = MessageManagor(viewOfGame: containerView.subviews.last as! ViewOfGame, superView: self.view, clockView: clockView, functionToFinishGame: { (didTapABomb) in
                self.endOfInfiniteGame(didTapABomb: didTapABomb)
        })
    }
    
    public func getCurrentViewOfGame() -> ViewOfGame {
        return containerView.subviews[containerView.subviews.count-1] as! ViewOfGame
    }
    
    
    /**
     Cette fonction permet de remettre à zero la partie infinie, en initiant la section à la première section
    */
    func restartTheGame() {
        clockView.alpha = 0
        gameIndex = 1
        gameManager.iterators = InfiniteIterators() // remettre les iterateurs à 0
        sectionIndex = 0
        level = 1
        numberOfBombs = 0
        containerView.subviews.last?.removeFromSuperview()
        containerView.subviews.last?.removeFromSuperview()
        startNewSection()
    }
    
    /**
     Cette fonction doit-être appelée quand on commence une nouvelle section
     */
    func startNewSection() {
        
        // reinitialise toutes les données
        clockView.pourcentage = 0.0
        isTheGameStarted.value = false
        hasToFinishTheGame = true
        
        // On change de section
        if sectionIndex == 0 {
            currentSection = gameManager.nextSection(forLastRemplissement: 0.05, forSectionIndex: sectionIndex)
        } else {
            let remplissement = CGFloat(currentSection.z0)/(CGFloat(currentSection.n)*CGFloat(currentSection.m))
            currentSection = gameManager.nextSection(forLastRemplissement: remplissement, forSectionIndex: sectionIndex)
        }
        
        // Actualisation des couleurs des parties courantes
        let color1 = Color.getColor(index: 0)
        let color2 = Color.getColor(index: 4)
        let color3 = Color.getColor(index: 5)
        let color4 = Color.getColor(index: 6)
        let color5 = Color.getColor(index: 7)
        let color6 = Color.getColor(index: 8)
        currentSection.game1?.colors = ColorSetForOneGame(openColor: color2, emptyColor: color1, strokeColor: Color.getColor(index: 2), textColor: Color.getColor(index: 3))
        currentSection.game2?.colors = ColorSetForOneGame(openColor: color3, emptyColor: color2, strokeColor: Color.getColor(index: 2), textColor: Color.getColor(index: 3))
        currentSection.game3?.colors = ColorSetForOneGame(openColor: color4, emptyColor: color3, strokeColor: Color.getColor(index: 2), textColor: Color.getColor(index: 3))
        currentSection.game4?.colors = ColorSetForOneGame(openColor: color5, emptyColor: color4, strokeColor: Color.getColor(index: 2), textColor: Color.getColor(index: 3))
        currentSection.game5?.colors = ColorSetForOneGame(openColor: color6, emptyColor: color5, strokeColor: Color.getColor(index: 2), textColor: Color.getColor(index: 3))
        
        // si c'est la première section, on ne fait pas d'animations et on lance la partie immédiatemment
        if sectionIndex == 0 {
            
            addANewGame(game: currentSection.game1!) // First element on the top
            addANewGame(game: currentSection.game2!) // Second game is put below
            updateDisplaysOnNewGame()
            
            // TODO: put the next block inside method
            blockingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlockingView(_:)))
            blockingView?.addGestureRecognizer(tapGesture)
            let message = MessageEndOfSection()
            message.circleColor = Color.rgb(242, 180, 37)
            message.textColor = Color.rgb(255, 255, 255)
            message.fontSizeNumber = 60
            message.fontSizeLevel = 14
            message.backgroundColor = UIColor.clear
            message.sectionIndex = 1
            let size: CGSize = CGSize(width: 200, height: 200)
            let origin: CGPoint = CGPoint(x: (self.view.bounds.width-size.width)/2, y: (self.view.bounds.height-size.height)/2)
            message.frame = CGRect(origin: origin, size: size)
            self.view.addSubview(message)
            blockingView?.addSubview(message)
            view.addSubview(blockingView!)
            
        } else { // (It is not the first section)
            // on supprime la partie courrante
            containerView.isUserInteractionEnabled = true
            containerView.subviews[containerView.subviews.count-1].removeFromSuperview()
            animateNewSection()
            containerView.isUserInteractionEnabled = true
        }
        
        // met à jour les affichages, etc. et lance la partie
        containerView.subviews.first?.isUserInteractionEnabled = false
    }
    
    @objc func tapBlockingView(_ sender: UITapGestureRecognizer) {
        
        let message = blockingView?.subviews.last
        let exitAnimation = CABasicAnimation(keyPath: "position.x")
        exitAnimation.duration = 0.5
        exitAnimation.toValue = -(message?.bounds.width)!
        exitAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.73, 0.71, 0.92, 0.76)
        exitAnimation.fillMode = CAMediaTimingFillMode.forwards
        exitAnimation.isRemovedOnCompletion = false
        exitAnimation.beginTime = CACurrentMediaTime()+0.2
        exitAnimation.delegate = self
        exitAnimation.setValue("FirstMessageAnimation", forKey: "name")
        message!.layer.add(exitAnimation, forKey: nil)
        
    }
    
    /**
     Cette fonction est appelée quand une nouvelle partie actuelle doit commencer ;
     Elle doit retourné la partie qui sera caché sous la partie courante.
     */
    func nextGameToAdd() -> OneGame {
        if gameIndex == 1 {
            return currentSection.game3!
        } else if gameIndex == 2 {
            return currentSection.game4!
        } else {
            return currentSection.game5!
        }
    }
    
    /// This function has to be called each time the viewOfGame reference is modified, to let know the different object dealing with it.
    func updateViewOfGamesReferences() {
        bonusChoiceView!.viewOfGame = (containerView.subviews.last as! ViewOfGame)
        messageManager!.viewOfGame = (containerView.subviews.last as! ViewOfGame)
    }
    
    /**
     Cette fonction est appelée quand la partie actuelle est terminée.
     Son rôle est de faire disparaitre l'ancienne vue et de faire apparaitre la nouvelle afin de passer à la partie suivante.
     */
    func currentGameIsFinished() {

        
        getCurrentViewOfGame().stopTimers()

        if gameIndex != 5 {
            animateNewLevel()
        }
        
        UIView.animate(withDuration: 2.0, animations: {
            self.containerView.subviews.last?.alpha = 0.0
        }) { (tmp) in
            if self.gameIndex == 5 {
                self.sectionIndex += 1
                self.startNewSection()
            } else {
                self.containerView.subviews.last?.removeFromSuperview()
                self.reloadTheGames()
            }
        }
        
    }
    
    /**
     Cette fonction est appelée après la disparition de la vue courrante.
     */
    func reloadTheGames() {
        // Reset the game setting
        isTheGameStarted.value = false
        addANewGame(game: nextGameToAdd())
        // Update the viewOfgame of the bonus bar view (for bonus action)
        updateViewOfGamesReferences()
        gameIndex += 1
        updateDisplaysOnNewGame()
        bonusChoiceView!.isTimerOn = currentGame().isTimerAllowed
        updateUserInteractionProperty()
        hasToFinishTheGame = true
    }
    
    /// Cette fonction termine totalement la partie et lance le prochain VC qui est un message de fin de partie.
    func endOfInfiniteGame(didTapABomb: Bool) {
        getCurrentViewOfGame().stopTimers()
        
        let animationOfCoinManager = EndGameCoinAnimationManager(gameViewToAnimate: getCurrentViewOfGame())
        animationOfCoinManager.animateTheEarnings {
            
            self.openTheBombs()
            // Il faut compter le nombre de drapeaux et le niveau final atteint, pour sauvegarder les données dans la base de données.
            // La variable 'level' est déjà upadter à chaque changement de niveau
            // Pour la variable 'numberOfBombs', on utilise des closures dénomées 'onPosingFlag(isFlagCorrect: Bool)' qui vont être donnée aux gameView et qui update la variable 'numberOfBombs'.
            
            
            // Adding the new local score
            let newScore = LocalScore(context: AppDelegate.viewContext)
            newScore.level = Int32(self.level)
            newScore.numberOfBombs = Int32(self.numberOfBombs)
            do { try AppDelegate.viewContext.save() }
            catch { print("ERROR: saving core data ") }
            // And push it to the game center
            newScore.publishScore()
            // Closing the page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WinLooseVC") as! WinLooseViewController
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.precedentViewController = self
            vc.win = false
            vc.transitioningDelegate = self
            vc.didTapABomb = didTapABomb
            vc.amountOfBombsFound = Int(newScore.numberOfBombs)
            vc.precedentGameIndex = self.gameIndex
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - Fonctions qui ajoutent les parties
    
    // Returns the CGRect to use to create a new ViewOfGame, used by the function 'addANewGame'
    private func frameForGame(game: OneGame) -> CGRect {
        switch game.gameType {
        case .square:
            let maxWidth = self.containerView.frame.width
            let maxHeight = self.containerView.frame.height
            let (width, height) = dimensionSquareTable(n: game.n, m: game.m, withMaximumWidth: maxWidth, withMaximumHeight: maxHeight)
            let origin = CGPoint(x: self.containerView.frame.width/2 - width/2, y: self.containerView.frame.height/2 - height/2)
            let viewSize = CGSize(width: width, height: height)
            return CGRect(origin: origin, size: viewSize)
        case .hexagonal:
            let maxWidth = self.containerView.frame.width
            let maxHeight = self.containerView.frame.height
            let (width, height) = dimensionHexTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let viewSize = CGSize(width: width, height: height)
            let origin = CGPoint(x: self.containerView.frame.width/2 - width/2, y: self.containerView.frame.height/2 - height/2)
            return CGRect(origin: origin, size: viewSize)
        case .triangular:
            let maxWidth = self.containerView.bounds.width
            let maxHeight = self.containerView.bounds.height
            let (w,h) = dimensionTriangularTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let origin = CGPoint(x: self.containerView.frame.width/2 - w/2, y: self.containerView.frame.height/2 - h/2)
            return CGRect(origin: origin, size: CGSize.init(width: w, height: h))
        }
    }
    
    // This function add a ViewOfGame as the first element of the containerView, with the specified game inside it.
    func addANewGame(game: OneGame, isFirst: Bool = false) {
        let frame = frameForGame(game: game)
        let viewOfGame: ViewOfGame
        switch game.gameType {
        case .square:
            var gameState = createEmptySquareGameState(n: game.n, m: game.m)
            positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameState)
            viewOfGame = SquareViewOfGame(frame: frame, game: game, gameState: &gameState)
            viewOfGame.layer.borderWidth = 1.0
            viewOfGame.layer.borderColor = UIColor.black.cgColor
        case .hexagonal:
            var gameState = createEmptyHexGameState(n: game.n, m: game.m)
            positionNoneCaseHex(noneCases: game.noneCasesPosition, gameState: &gameState)
            viewOfGame = HexViewOfGame(frame: frame, game: game, gameState: &gameState)
        case .triangular:
            var gameState = createEmptySquareGameState(n: game.n, m: game.m)
            positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameState)
            viewOfGame = TriangleViewOfGame(frame: frame, game: game, gameState: &gameState)
        }
        viewOfGame.numberOfRemainingFlags = game.numberOfFlag
        viewOfGame.delegate = self
        viewOfGame.backgroundColor = UIColor.clear
        viewOfGame.layer.zPosition = 0 ;
        viewOfGame.onPosingFlag = { (test: Bool) -> Void in
            self.numberOfBombs += test ? 1 : 0
        }
        viewOfGame.onUnposingFlag = { (test: Bool) -> Void in
            self.numberOfBombs -= test ? 1 : 0
        }
        
        self.containerView.insertSubview(viewOfGame, at: 0)
    }
    
    /**
     Cette fonction permet simplement d'activer la première vue et de desactiver la deuxième vue.
     L'utilisateur ne peut donc taper uniquement sur la première case.
     */
    func updateUserInteractionProperty() {
        containerView.subviews.first?.isUserInteractionEnabled = false
        containerView.subviews.last?.isUserInteractionEnabled = true
    }
    
    func openTheBombs() {
        let currentViewOfGame = containerView.subviews.last as! ViewOfGame
        currentViewOfGame.returnAllTheCases()
    }
    
    func updateDisplaysOnNewGame() {
        let numberOfFlags = currentGame().numberOfFlag
        // met à jour les labels
        self.bombCounterLabel.text = self.currentGame().z.description
        self.flagCounterLabel.text = numberOfFlags.description
        // si besoin reaffiche les labels
        if self.currentGame().areNumbersShowed {
            UIView.animate(withDuration: 0.25, animations: {
                self.bombCounterLabel.alpha = 1
                self.bombView.alpha = 1
                self.flagCounterLabel.alpha = 1
                self.flagView.alpha = 1
            })
        }
        
        // si besoin affiche la clock et la met à 0
        if currentGame().isTimerAllowed {
            
            clockView.pourcentage = 0
            
            UIView.animate(withDuration: 0.25) {
                self.clockView.alpha = 1
            }
            
        }
        
    }
    
    /*func launchOption3TimerIfNeeded() {
        if currentGame().option3 {
            let currentGameView = containerView.subviews[containerView.subviews.count-1] as! ViewOfGame
            currentGameView.option3Timer.start(timeInterval: Double(currentGame().option3Time), id: "Option3")
            currentGameView.option3Timer.delegate = currentGameView
        }
    }*/
    
    func currentGame() -> OneGame {
        switch gameIndex {
        case 1:
            return currentSection.game1!
        case 2:
            return currentSection.game2!
        case 3:
            return currentSection.game3!
        case 4:
            return currentSection.game4!
        case 5:
            return currentSection.game5!
        default:
            return currentSection.game1!
        }
    }

    func updateSquareGame(withFirstTouched touch: (x: Int, y: Int)) {
        // on récupère la vue courrante
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGame
        // on actualise les données de la vue courrante
        positionBombsSquare(in: &currentViewOfGame.gameState, numberOfBombs: currentGame().z, withFirstTouched: touch)
        createNumbersToDisplaySquare(in: &currentViewOfGame.gameState)
    }
    
    func updateHexGameState(withFirstTouched touch: (x: Int, y: Int)) {
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGame
        positionBombsHex(gameState: &currentViewOfGame.gameState, z: currentGame().z, withFirstTouched: touch)
        createNumbersToDisplayHex(gameState: &currentViewOfGame.gameState)
    }
    
    func updateTriangularGameState(withFirstTouched touch: (x:Int, y: Int)) {
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGame
        positionBombsSquare(in: &currentViewOfGame.gameState, numberOfBombs: currentGame().z, withFirstTouched: touch, isTriangular: true)
        createNumbersToDisplayTriangle(in: &currentViewOfGame.gameState)
    }
    
    /// Adds the bonus choice view to the screen and set its viewOfGame as the first viewOfGame of this infinite party.
    /// - You must keep updating the viewOfGame of the bonusChoiceView each time a new game is presented to screen.
    func addTheBonusChoiceView() {
        /*let screenW = self.view.frame.width
        let screenH = self.view.frame.height
        let dec_h: CGFloat = 20 // decalage horizontal
        let dec_v: CGFloat = isItABigScreen() ? 30 : 15 // decalage vertical
        let w = screenW - dec_h
        let h = w/6
        let size = CGSize(width: w, height: h)
        let origin = CGPoint(x: dec_h/2, y: screenH - h - dec_v)
        if bonusChoiceView != nil { bonusChoiceView?.removeFromSuperview() }
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGame
        //bonusChoiceView = BonusChoiceView(frame: CGRect(origin: origin, size: size), viewOfGame: currentViewOfGame, gameTimer: gameTimer)
        //bonusChoiceView!.progress = 0
        bonusChoiceView!.isTimerOn = currentGame().isTimerAllowed
        self.view.addSubview(bonusChoiceView!)*/
        
        let screenW = self.view.frame.width
        let screenH = self.view.frame.height
        if bonusChoiceView != nil { bonusChoiceView?.removeFromSuperview() }
        let w = screenW
        let h = w/3
        let size = CGSize(width: w, height: h)
        let origin = CGPoint(x: 0, y: screenH)
        let frame = CGRect(origin: origin, size: size)
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGame
        bonusChoiceView = BonusChoiceView(frame: frame, viewOfGame: currentViewOfGame, backgroundColor: Color.rgb(194, 194, 186), lineColor: UIColor(red: 0.5, green: 0.5, blue: 0.45, alpha: 1))
        bonusChoiceView!.isTimerOn = currentGame().isTimerAllowed
        self.view.addSubview(bonusChoiceView!)
        
    }
    
    public func revealTheBonusChoiceView() {
        UIView.animate(withDuration: 0.5) {
            self.bonusChoiceView?.frame.origin.y = self.view.frame.height - self.bonusChoiceView!.frame.height
        }
    }
    
    // MARK: - Animations for end of levels
    
    // This function animate and instantiate a new section (that is not the first section)
    func animateNewSection() {
        let view = containerView.subviews.last!
        UIView.animate(withDuration: 0.72, animations: {
            view.alpha = 0
        }) { (_) in
            view.removeFromSuperview()
            self.gameIndex = 0
            self.animateNewLevel()
            self.addANewGame(game: self.currentSection.game1!)
            self.addANewGame(game: self.currentSection.game2!)
            self.updateViewOfGamesReferences()
            self.updateDisplaysOnNewGame()
        }
        
    }
    
    // Adds a circle on the screen with the new level displayed on it.
    func animateNewLevel() {
        let message = MessageEndOfSection()
        message.circleColor = Color.rgb(242, 180, 37)
        message.textColor = Color.rgb(255, 255, 255)
        message.fontSizeNumber = 60
        message.fontSizeLevel = 14
        message.backgroundColor = UIColor.clear
        self.level = 5*sectionIndex + gameIndex + 1 // updater le niveau courant au bon moment !
        message.sectionIndex = 5*sectionIndex + gameIndex + 1 // level de la partie qui commence
        let size: CGSize = CGSize(width: 200, height: 200)
        let origin: CGPoint = CGPoint(x: (self.view.bounds.width-size.width)/2, y: (self.view.bounds.height-size.height)/2)
        message.frame = CGRect(origin: origin, size: size)
        self.view.addSubview(message)
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.3
        scaleAnimation.toValue = 1
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, fadeAnimation]
        groupAnimation.fillMode = CAMediaTimingFillMode.backwards
        groupAnimation.duration = 0.3
        groupAnimation.delegate = self
        groupAnimation.setValue("AppearMessageAnimation", forKey: "name")
        groupAnimation.setValue(message, forKey: "message")
        message.layer.add(groupAnimation, forKey: nil)
    }
}

// MARK: - Gere la création de la partie après le premier touché.
extension InfiniteGameViewController: variableCanCallGameVC {
    /// Cette fonction est appelée une fois que l'utilisateur tappe pour la première fois sur l'écran. Elle permet
    func createTheGame(withFirstTouched touch: (x: Int, y: Int))
    {
        if currentSection.gameType == .hexagonal {
            updateHexGameState(withFirstTouched: touch)
        } else if currentSection.gameType == .square {
            updateSquareGame(withFirstTouched: touch)
        } else if currentSection.gameType == .triangular {
            updateTriangularGameState(withFirstTouched: touch)
        }
        
        getCurrentViewOfGame().startTimers()
        
        bonusChoiceView!.activateBonusButtons()
    }
}
// MARK: - Protocole pour les gameView 
extension InfiniteGameViewController: GameController {
    
    func gameOver(win: Bool, didTapABomb: Bool, didTimeEnd: Bool) {
        
        //print("gameOver")
        
        Vibrate().vibrate(style: .heavy)
        
        if win {
            
            getCurrentViewOfGame().stopTimers()
            let animationOfCoinManager = EndGameCoinAnimationManager(gameViewToAnimate: getCurrentViewOfGame(), timeOfAnimation: 0.9)
            animationOfCoinManager.animateTheEarnings {
                self.bonusChoiceView?.desactivateBonusButtons()
                UIView.animate(withDuration: 0.25, animations: {
                    self.clockView.alpha = 0
                    self.bombCounterLabel.alpha = 0
                    self.bombView.alpha = 0
                    self.flagCounterLabel.alpha = 0
                    self.flagView.alpha = 0
                })
                
                if self.hasToFinishTheGame {
                    self.hasToFinishTheGame = false
                } else {
                    return
                }
                
                isTheGameStarted.value = false
                self.currentGameIsFinished()
            }
        } else {
            if didTapABomb || didTimeEnd {
                getCurrentViewOfGame().pauseTimers()
                messageManager!.addTheMessage(didTapABomb: didTapABomb)
            } else {
                getCurrentViewOfGame().stopTimers()
                self.endOfInfiniteGame(didTapABomb: false)
            }
        }
    }
    
    func updateFlagsDisplay(numberOfFlags: Int) {
        
        if currentGame().areNumbersShowed {
            bombCounterLabel.text = currentGame().z.description
            flagCounterLabel.text = numberOfFlags.description
        }
    }
    
}

// MARK: - Gere l'affichage de l'horloge
extension InfiniteGameViewController: CountingTimerProtocol
{
    // Cette fonction est appelée par le timer toutes les secondes pour actualiser le temps de l'horloge. Si la chronomètre est terminée, la fonction arrete de le jeu.
    func timerFires(id: String) {
        
        if currentGame().isTimerAllowed {
            
            let pourcentage: CGFloat = getCurrentViewOfGame().gameTimer.counter / CGFloat(currentGame().totalTime) // ratio of time used.
            clockView.pourcentage = pourcentage // et actualisation via un didSet
            if pourcentage >= 1 {
                
                // Fin de la partie à cause de temps
                print("timer end")
                gameOver(win: false, didTapABomb: false, didTimeEnd: true)
                
            }
        }
    }
}

extension InfiniteGameViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let id = anim.value(forKey: "name") as? String else {
            return
        }
        
        if id == "AppearMessageAnimation" {
            
            if gameIndex == 0 {
                gameIndex = 1
            }
            
            let message = anim.value(forKey: "message") as? MessageEndOfSection
            anim.setValue(nil, forKey: "name")
            anim.setValue(nil, forKey: "message")
            
            let exitAnimation = CABasicAnimation(keyPath: "position.x")
            exitAnimation.duration = 0.5
            exitAnimation.toValue = -(message?.bounds.width)!
            exitAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.73, 0.71, 0.92, 0.76)
            exitAnimation.fillMode = CAMediaTimingFillMode.forwards
            exitAnimation.isRemovedOnCompletion = false
            exitAnimation.beginTime = CACurrentMediaTime()+0.2
            exitAnimation.delegate = self
            exitAnimation.setValue("DisappearMessageAnimation", forKey: "name")
            exitAnimation.setValue(message, forKey: "message")
            message!.layer.add(exitAnimation, forKey: nil)
            
        } else if id == "DisappearMessageAnimation" {
            
            let message = anim.value(forKey: "message") as? MessageEndOfSection
            anim.setValue(nil, forKey: "name")
            anim.setValue(nil, forKey: "message")
            message?.removeFromSuperview()
            
        } else if id == "FirstMessageAnimation" {
            
            // launch the different timers at the beginning and start the game
            blockingView?.removeFromSuperview()
            containerView.isUserInteractionEnabled = true
    
        }
        
    }
}

// MARK: - Gere les transitions vers les autres VC
extension InfiniteGameViewController: UIViewControllerTransitioningDelegate {
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
