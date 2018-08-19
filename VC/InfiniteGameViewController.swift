//
//  InfiniteGameViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 20/04/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//


/*
 Le but de cette page est de fonctionner avec une section donnée.
 */

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
    // Cette variable s'occupe de contenir les parties du jeu.
    //@IBOutlet weak var containerView: UIView!
    var containerView = UIView()
    var blockingView: UIView? = UIView()
    
    
    // MARK: - VARIABLES
    
    var sectionIndex: Int = 0
    var gameIndex: Int = 1
    var numberOfBombs: Int = 0 // a la fin des parties, il faut updater le nombre de bombes correctement marquées
    {
        didSet {
            print("nombre de drapeaux corrects: \(numberOfBombs)")
        }
    }
    var level: Int = 1 {
        didSet {
            print("niveau courrant: \(level)")
        }
    }
    
    var emptyGameState = [[Int]].init()
    var gameState = [[Int]].init() // Pour la partie en cours ...
    var currentSection = Section(simpleHexGameWith: (11,9)) // création de la section courante
    
    var gameTimer = CountingTimer()
    var animationTimer = CountingTimer()
    
    var hasToFinishTheGame: Bool = true // This variable is used in order to call only once the function 'currentGameIsFinished'. Indeed, it is called many times for a very strange reason.
    var bonusChoiceView: BonusChoiceView?
    var gameManager = InfiniteGameManager() // permet de s'occuper de la logique du mode infinie.
    
    
    // MARK: - ACTIONS
    
    @IBAction func buttonReturn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newsectionbutton(_ sender: Any) {
        sectionIndex += 1
        startNewSection()
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        
        gameTimer.pause()
        
        let currentGameView = containerView.subviews[containerView.subviews.count-1]
        if currentGameView is ViewOfGameSquare {
            let squareView = currentGameView as! ViewOfGameSquare
            squareView.option3Timer.pause()
        } else if currentGameView is ViewOfGame_Hex {
            let hexView = currentGameView as! ViewOfGame_Hex
            hexView.option3Timer.pause()
        } else if currentGameView is ViewOfGameTriangular {
            let triangularView = currentGameView as! ViewOfGameTriangular
            triangularView.option3Timer.pause()
        }
        
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
        
        let containerWidth = self.view.frame.width*0.95
        let containerHeight = self.view.frame.height * (isItABigScreen() ? 0.7 : 0.8 )
        let ox = view.frame.width/2 - containerWidth/2
        let oy = (isItABigScreen() ? 0.16 : 0.10) * view.frame.height
        containerView.frame = CGRect(x: ox, y: oy, width: containerWidth, height: containerHeight)
        self.view.addSubview(containerView)
        
        /// Pour la position de la containerView
        containerView.backgroundColor = UIColor.clear
        containerView.layer.borderColor = UIColor.red.cgColor
        containerView.layer.borderWidth = 0.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clockView.alpha = 0
        isTheGameStarted.delegate = self // permet le positionnement des bombes pos-début.
        
        startNewSection()
        
        // instauration de la bar des bonus
        addTheBonusChoiceView()
        
    }
    
    
    /**
     Cette fonction permet de remettre à zero la partie infinie, en iniciant la section à la première section
    */
    func restartTheGame() {
        gameIndex = 1
        gameManager.iterators = InfiniteIterators() // remettre les iterateurs à 0
        sectionIndex = 0
        level = 1
        numberOfBombs = 0
        gameTimer.stop()
        containerView.subviews.last?.removeFromSuperview()
        containerView.subviews.last?.removeFromSuperview()
        startNewSection()
    }
    
    /**
     Cette fonction doit-être appelée quand on commence une nouvelle section (i.e.) dans le ViewWillAppear très probablement.
     Appelé au TOUT DEBUT
     */
    func startNewSection() {
        
        // reinitialise toutes les données
        gameTimer.stop()
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
        let color1 = UIColor.white
        let color2 = UIColor(red: 102/255, green: 153/255, blue: 255/255, alpha: 1.0)
        let color3 = UIColor(red: 153/255, green: 102/255, blue: 255/255, alpha: 1.0)
        let color4 = UIColor(red: 255/255, green: 153/255, blue: 102/255, alpha: 1.0)
        let color5 = UIColor(red: 153/255, green: 255/255, blue: 51/255, alpha: 1.0)
        currentSection.game1?.colors = ColorSetForOneGame(openColor: color2, emptyColor: color1, strokeColor: .black, textColor: .black)
        currentSection.game2?.colors = ColorSetForOneGame(openColor: color3, emptyColor: color2, strokeColor: .black, textColor: .black)
        currentSection.game3?.colors = ColorSetForOneGame(openColor: color4, emptyColor: color3, strokeColor: .black, textColor: .black)
        currentSection.game4?.colors = ColorSetForOneGame(openColor: color5, emptyColor: color4, strokeColor: .black, textColor: .black)
        currentSection.game5?.colors = ColorSetForOneGame(openColor: color1, emptyColor: color5, strokeColor: .black, textColor: .black)
        
        // si c'est la première section, on ne fait pas d'animations et on lance la partie immédiatemment
        if sectionIndex == 0 {
            
            if currentSection.gameType == .hexagonal {
                addANewHexGame(game: currentSection.game1!) // element 1 (sur le dessus)
                addANewHexGame(game: currentSection.game2!) // element 0 (en dessous du premier)
            } else if currentSection.gameType == .square {
                addANewSquareGame(game: currentSection.game1!) // element 1 (sur le dessus)
                addANewSquareGame(game: currentSection.game2!) // element 0 (en dessous du premier)
            } else if currentSection.gameType == .triangular {
                addANewTriangularGame(game: currentSection.game1!)
                addANewTriangularGame(game: currentSection.game2!)
            }
            
            blockingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlockingView(_:)))
            blockingView?.addGestureRecognizer(tapGesture)
            
            let message = MessageEndOfSection()
            message.circleColor = colorForRGB(r: 242, g: 180, b: 37)
            message.textColor = colorForRGB(r: 255, g: 255, b: 255)
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
            
        } else {
            // on supprime la partie courrante
            containerView.isUserInteractionEnabled = true
            containerView.subviews[containerView.subviews.count-1].removeFromSuperview()
            
            animateNewSection()
            
            launchOption3TimerIfNeeded()
            containerView.isUserInteractionEnabled = true
        }
        
        // met à jour les affichages, etc. et lance la partie
        updateDisplaysOnNewGame()
        containerView.subviews.first?.isUserInteractionEnabled = false
    }
    
    @objc func tapBlockingView(_ sender: UITapGestureRecognizer) {
        
        let message = blockingView?.subviews.last
        let exitAnimation = CABasicAnimation(keyPath: "position.x")
        exitAnimation.duration = 0.5
        exitAnimation.toValue = -(message?.bounds.width)!
        exitAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.73, 0.71, 0.92, 0.76)
        exitAnimation.fillMode = kCAFillModeForwards
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
    
    /**
     Cette fonction est appelée quand la partie actuelle est terminée.
     Son rôle est de faire disparaitre l'ancienne vue et de faire apparaitre la nouvelle afin de passer à la partie suivante.
     */
    func currentGameIsFinished() {
        /// DISPARITION OF CURRENT VIEW
        gameTimer.stop()

        if gameIndex != 5 {
            animateNewLevel()
        }
        
        //// ANIMATION TO MAKE DISAPEAR THE VIEW GOES HERE.
        UIView.animate(withDuration: 2.0, animations: {
            self.containerView.subviews.last?.alpha = 0.0
        }) { (tmp) in
            
            if self.gameIndex == 5 {
                self.sectionIndex += 1
                self.startNewSection()
            } else {
                self.reloadTheGames()
            }
        }
        
    }
    
    /**
     Cette fonction est appelée après la disparition de la vue courrante.
     */
    func reloadTheGames() {
        
        isTheGameStarted.value = false
        containerView.subviews.last?.removeFromSuperview()
        
        if currentSection.gameType == .hexagonal {
            addANewHexGame(game: nextGameToAdd())
        } else if currentSection.gameType == .square {
            addANewSquareGame(game: nextGameToAdd())
        } else if currentSection.gameType == .triangular {
            addANewTriangularGame(game: nextGameToAdd())
        }
        
        gameIndex += 1
        updateDisplaysOnNewGame()
        launchOption3TimerIfNeeded()
        bonusChoiceView!.isTimerOn = returnCurrentGame().isTimerAllowed
        bonusChoiceView!.activateBonusButtons()
        updateUserInteractionProperty()
        hasToFinishTheGame = true
    }
    
    /// Cette fonction termine totalement la partie et lance le prochain VC qui est un message de fin de partie.
    func endOfInfiniteGame() {
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
        // Il faut compter le nombre de drapeaux et le niveau final atteint, pour sauvegarder les données dans la base de données.
        // La variable 'level' est déjà upadter à chaque changement de niveau
        // Pour la variable 'numberOfBombs', on utilise des closures dénomées 'onPosingFlag(isFlagCorrect: Bool)' qui vont être donnée aux gameView et qui update la variable 'numberOfBombs'.
        
        if Reachability.isConnectedToNetwork() == true {
            scoresModel.addOneScore(level: self.level, numberOfBombs: self.numberOfBombs)
        }
        localScores.addOneScoreToLocal(level: self.level, numberOfBombs: self.numberOfBombs)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Fonctions qui ajoutent les parties
    
    /**
     Cette fonction rajoute une partie carré en dessous des vues actuelles.
     La partie est ajouté au prelier élement du tableau des subviews du container view.
     */
    func addANewSquareGame(game: OneGame, isFirst: Bool = false) {
        /// Dimensionnement
        let maxWidth = self.containerView.frame.width
        let maxHeight = self.containerView.frame.height
        
        let (width, height) = dimensionSquareTable(n: game.n, m: game.m, withMaximumWidth: maxWidth, withMaximumHeight: maxHeight)
        /// Positionnnement
        
        let origin = CGPoint(x: self.containerView.frame.width/2 - width/2, y: self.containerView.frame.height/2 - height/2)
        // let origin = CGPoint(x: containerView.frame.width/2 + (isFirst ? width/2 : -width/2), y: containerView.frame.height/2 - height/2)
        let viewSize = CGSize(width: width, height: height)
        let gameToAdd = ViewOfGameSquare()
        gameToAdd.frame = CGRect(origin: origin, size: viewSize)
        gameToAdd.layer.zPosition = 0 ; // en dessous
        
        /// Actualisation /// Creation de la partie vide du jeu
        gameToAdd.n = game.n
        gameToAdd.m = game.m
        gameToAdd.z = game.z
        gameToAdd.ratio = 3.0
        gameToAdd.lineWidth = 0.5
        gameToAdd.gameState = createEmptySquareGameState(n: game.n, m: game.m)
        positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameToAdd.gameState)
        gameToAdd.backgroundColor = UIColor.clear
        gameToAdd.delegate = self
        gameToAdd.option1 = game.option1
        gameToAdd.option1Time = game.option1Time
        gameToAdd.option2 = game.option2
        gameToAdd.option2frequency = game.option2Frequency
        gameToAdd.option3Frequency = game.option3Frequency
        gameToAdd.openColor = game.colors.openColor
        gameToAdd.emptyColor = game.colors.emptyColor
        gameToAdd.textColor = game.colors.textColor
        gameToAdd.strokeColor = game.colors.strokeColor
        gameToAdd.numberOfFlags = game.numberOfFlag
        
        gameToAdd.layer.borderWidth = 1.0
        gameToAdd.layer.borderColor = UIColor.black.cgColor
        
        // Comptage des drapeaux
        gameToAdd.onPosingFlag = { (test: Bool) -> Void in
            if test {
                self.numberOfBombs += 1 
            }
        }
        
        gameToAdd.onUnposingFlag = { (test: Bool) -> Void in
            if test {
                self.numberOfBombs -= 1
            }
        }
        
        /// Ajout de la vue
        self.containerView.insertSubview(gameToAdd, at: 0)
    }
    
    /**
     Cette fonction rajoute une partie hexagonale en dessous des vues actuelles.
     La partie est ajouté au premier élement du tableau des subviews du container view.
     */
    func addANewHexGame(game: OneGame, isFirst: Bool = false) {
        // Dimensionnement
        let maxWidth = self.containerView.frame.width
        let maxHeight = self.containerView.frame.height
        let (width, height) = dimensionHexTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
        // Positionnement
        let viewSize = CGSize(width: width, height: height)
        let origin = CGPoint(x: self.containerView.frame.width/2 - width/2, y: self.containerView.frame.height/2 - height/2)
        // let origin = (height > containerView.frame.height) ? CGPoint(x: containerView.frame.width/2 + (isFirst ? width/2 : -width/2), y: (containerView.frame.height/2 - height/2)*0.5) : CGPoint(x: containerView.frame.width/2 + (isFirst ? width/2 : -width/2), y: containerView.frame.height/2 - height/2)
        let gameToAdd = ViewOfGame_Hex()
        gameToAdd.frame = CGRect(origin: origin, size: viewSize)
        gameToAdd.layer.zPosition = 0
        
        /// Actualisation /// Creation de la partie vide du jeu
        gameToAdd.n = game.n
        gameToAdd.m = game.m
        gameToAdd.a = width / (sqrt(3) * CGFloat(game.m))
        gameToAdd.z = game.z
        gameToAdd.lineWidth = 0.5
        gameToAdd.gameState = createEmptyHexGameState(n: game.n, m: game.m)
        positionNoneCaseHex(noneCases: game.noneCasesPosition, gameState: &gameToAdd.gameState)
        gameToAdd.backgroundColor = UIColor.clear
        gameToAdd.delegate = self
        gameToAdd.option1 = game.option1
        gameToAdd.option1Time = game.option1Time
        gameToAdd.option2 = game.option2
        gameToAdd.option2frequency = game.option2Frequency
        gameToAdd.option3Frequency = game.option3Frequency
        gameToAdd.openColor = game.colors.openColor
        gameToAdd.emptyColor = game.colors.emptyColor
        gameToAdd.textColor = game.colors.textColor
        gameToAdd.strokeColor = game.colors.strokeColor
        gameToAdd.numberOfFlags = game.z
        
        // Comptage des drapeaux
        gameToAdd.onPosingFlag = { (test: Bool) -> Void in
            if test {
                self.numberOfBombs += 1
            }
        }
        
        gameToAdd.onUnposingFlag = { (test: Bool) -> Void in
            if test {
                self.numberOfBombs -= 1
            }
        }
        
        
        /// Ajout de la vue
        self.containerView.insertSubview(gameToAdd, at: 0)
    }
    
    
    /**
     Cette fonction rajoute une partie triangulaire en dessous des vues actuelles.
     La partie est ajouté au premier élement du tableau des subviews du container view.
     */
    func addANewTriangularGame(game: OneGame, isFirst: Bool = false) {
        
        let maxWidth = self.containerView.bounds.width
        let maxHeight = self.containerView.bounds.height
        let (w,h) = dimensionTriangularTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
        let origin = CGPoint(x: self.containerView.frame.width/2 - w/2, y: self.containerView.frame.height/2 - h/2)

//        let origin = CGPoint(x: containerView.bounds.width/2 + (isFirst ? w/2 : -w/2), y: (containerView.bounds.height - h)/2)
        
        let gameToAdd = ViewOfGameTriangular()

        gameToAdd.frame = CGRect(origin: origin, size: CGSize.init(width: w, height: h))
        gameToAdd.m = game.m
        gameToAdd.n = game.n
        gameToAdd.z = game.z
        gameToAdd.gameState = createEmptySquareGameState(n: game.n, m: game.m)
        gameToAdd.backgroundColor = UIColor.clear
        gameToAdd.emptyColor = game.colors.emptyColor
        gameToAdd.openColor = UIColor.lightGray.withAlphaComponent(0.5)
        gameToAdd.strokeColor = UIColor.black
        gameToAdd.lineWidth = 1.0
        gameToAdd.delegateVC = self
        gameToAdd.option1 = game.option1
        gameToAdd.option1Time = game.option1Time
        gameToAdd.option2 = game.option2
        gameToAdd.option2frequency = game.option2Frequency
        gameToAdd.option3Frequency = game.option3Frequency
        gameToAdd.isUserInteractionEnabled = true
        gameToAdd.strokeColor = game.colors.strokeColor
        gameToAdd.openColor = game.colors.openColor
        gameToAdd.emptyColor = game.colors.emptyColor
        gameToAdd.numberOfFlags = game.z
        
        // Comptage des drapeaux
        gameToAdd.onPosingFlag = { (test: Bool) -> Void in
            if test {
                self.numberOfBombs += 1
            }
        }
        
        gameToAdd.onUnposingFlag = { (test: Bool) -> Void in
            if test {
                self.numberOfBombs -= 1
            }
        }
        
        
        /// Ajout de la vue
        self.containerView.insertSubview(gameToAdd, at: 0)
    }
    
    func displayTheGamesPresentInContainer() {
        print("\n***** Vues présente actuellement *****")
        print("Number of views: \(containerView.subviews.count)")
        //let first = containerView.subviews.first ; let last = containerView.subviews.last ;
        if let first = containerView.subviews.first as? ViewOfGameSquare {
            print("Première partie : carrée.")
            print("N = \(first.n) ; M = \(first.m) ; Z = \(first.z)" )
        } else if let first = containerView.subviews.first as? ViewOfGameTriangular {
            print("Première partie : triangulaire.")
            print("N = \(first.n) ; M = \(first.m) ; Z = \(first.z)" )
        } else if let first = containerView.subviews.first as? ViewOfGame_Hex {
            print("Première partie : hexagonal.")
            print("N = \(first.n) ; M = \(first.m) ; Z = \(first.z)" )
        }
        print("PARTIE COURANTE ----> ")
        if let last = containerView.subviews.last as? ViewOfGameSquare {
            print("Seconde partie : carrée.")
            print("N = \(last.n) ; M = \(last.m) ; Z = \(last.z)" )
        } else if let last = containerView.subviews.first as? ViewOfGameTriangular {
            print("Seconde partie : triangulaire.")
            print("N = \(last.n) ; M = \(last.m) ; Z = \(last.z)" )
        } else if let last = containerView.subviews.first as? ViewOfGame_Hex {
            print("Seconde partie : hexagonal.")
            print("N = \(last.n) ; M = \(last.m) ; Z = \(last.z)" )
        }
        
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
        switch returnCurrentGame().gameType {
        case .square:
            let currentViewOfGame = containerView.subviews.last as! ViewOfGameSquare
            currentViewOfGame.returnAllTheCases()
        case .triangular:
            let currentViewOfGame = containerView.subviews.last as! ViewOfGameTriangular
            currentViewOfGame.returnAllTheCases()
        case .hexagonal:
            let currentViewOfGame = containerView.subviews.last as! ViewOfGame_Hex
            currentViewOfGame.returnAllTheCases()
        }
    }
    
    func updateDisplaysOnNewGame() {
        
        let numberOfFlags = returnCurrentGame().numberOfFlag
        
        // met à jour les labels
        self.bombCounterLabel.text = self.returnCurrentGame().z.description
        self.flagCounterLabel.text = numberOfFlags.description
        
        // si besoin reaffiche les labels
        if self.returnCurrentGame().areNumbersShowed {
            UIView.animate(withDuration: 0.25, animations: {
                self.bombCounterLabel.alpha = 1
                self.bombView.alpha = 1
                self.flagCounterLabel.alpha = 1
                self.flagView.alpha = 1
            })
        }
        
        // si nécessaire cache ou affiche la clock
        if returnCurrentGame().isTimerAllowed {
            
            gameTimer.start(timeInterval: 1.0, id: "Clock")
            gameTimer.delegate = self
            
            UIView.animate(withDuration: 0.25) {
                self.clockView.alpha = 1
            }
        }
        
    }
    
    func launchOption3TimerIfNeeded() {
        
        if returnCurrentGame().option3 {
            
            let currentGameView = containerView.subviews[containerView.subviews.count-1]
            
            if currentGameView is ViewOfGameSquare {
                let squareView = currentGameView as! ViewOfGameSquare
                squareView.option3Timer.start(timeInterval: Double(returnCurrentGame().option3Time), id: "Option3")
                squareView.option3Timer.delegate = squareView
            } else if currentGameView is ViewOfGame_Hex {
                let hexView = currentGameView as! ViewOfGame_Hex
                hexView.option3Timer.start(timeInterval: Double(returnCurrentGame().option3Time), id: "Option3")
                hexView.option3Timer.delegate = hexView
            } else if currentGameView is ViewOfGameTriangular {
                let triangularView = currentGameView as! ViewOfGameTriangular
                triangularView.option3Timer.start(timeInterval: Double(returnCurrentGame().option3Time), id: "Option3")
                triangularView.option3Timer.delegate = triangularView
            }
        }
    }
    
    func returnCurrentGame() -> OneGame {
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
    
}

// MARK: - Création d'une nouvelle partie
extension InfiniteGameViewController {
    
    ///// SQUARE
    func updateSquareGame(withFirstTouched touch: (x: Int, y: Int)) {
        // on récupère la vue courrante
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGameSquare
        let z = currentViewOfGame.z ;
        // on actualise les données de la vue courrante
        positionBombsSquare(in: &currentViewOfGame.gameState, numberOfBombs: z, withFirstTouched: touch)
        createNumbersToDisplaySquare(in: &currentViewOfGame.gameState)
        currentViewOfGame.updateAllNumbers()
        
    }
    
    
    ///// HEX
    func updateHexGameState(withFirstTouched touch: (x: Int, y: Int)) {
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGame_Hex
        let z = currentViewOfGame.z
        positionBombsHex(gameState: &currentViewOfGame.gameState, z: z, withFirstTouched: touch)
        createNumbersToDisplayHex(gameState: &currentViewOfGame.gameState)
        currentViewOfGame.updateAllNumbers()
    }
    
    
    ///// TRIANGLE
    func updateTriangularGameState(withFirstTouched touch: (x:Int, y: Int)) {
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGameTriangular
        let z = currentViewOfGame.z
        positionBombsSquare(in: &currentViewOfGame.gameState, numberOfBombs: z, withFirstTouched: touch, isTriangular: true)
        createNumbersToDisplayTriangle(in: &currentViewOfGame.gameState)
        currentViewOfGame.updateAllNumbers()
        
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
        
        bonusChoiceView!.activateBonusButtons()
        
    }
}


// MARK: - Gere la fin de la partie (lancée par le gameView)
extension InfiniteGameViewController: GameViewCanCallVC {
    func gameOver(win: Bool, didTapABomb: Bool) {
        
        if win {
            
            UIView.animate(withDuration: 0.25, animations: {
                self.clockView.alpha = 0
                self.bombCounterLabel.alpha = 0
                self.bombView.alpha = 0
                self.flagCounterLabel.alpha = 0
                self.flagView.alpha = 0
            })
            
            if hasToFinishTheGame {
                hasToFinishTheGame = false
            } else {
                return
            }
            
            Vibrate().vibrate(style: .heavy)
            
            isTheGameStarted.value = false
            currentGameIsFinished()
            
            
        } else {
            
            if didTapABomb {
                addTheMessage()
            } else {
                self.endOfInfiniteGame()
                
                /*
                openTheBombs()
                gameTimer.stop()
                containerView.isUserInteractionEnabled = false
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "WinLooseVC") as! WinLooseViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                vc.precedentViewController = self
                vc.win = false
                vc.transitioningDelegate = self
                vc.didTapABomb = false
                vc.precedentGameIndex = gameIndex
                self.present(vc, animated: true, completion: nil)
                */
                
            }
        }
        
        
    }
    
    func updateFlagsDisplay(numberOfFlags: Int) {
        
        if returnCurrentGame().areNumbersShowed {
            bombCounterLabel.text = returnCurrentGame().z.description
            flagCounterLabel.text = numberOfFlags.description
        }
    }
}

// MARK: - Gere l'affichage de l'horloge
extension InfiniteGameViewController: CountingTimerProtocol
{
    // Cette fonction est appelée par le timer toutes les secondes pour actualiser le temps de l'horloge. Si la chronomètre est terminée, la fonction arrete de le jeu.
    func timerFires(id: String) {
        
        if returnCurrentGame().isTimerAllowed {
            let pourcentage: CGFloat = gameTimer.counter / CGFloat(returnCurrentGame().totalTime) // ratio of time used.
            
            clockView.pourcentage = pourcentage // et actualisation via un didSet
            
            if pourcentage >= 1 {
                
                // Fin de la partie à cause de temps
                
                if containerView.subviews[containerView.subviews.count-1] is ViewOfGameSquare {
                    let currentGameView = containerView.subviews[containerView.subviews.count-1] as! ViewOfGameSquare
                    currentGameView.returnAllTheCases()
                } else if containerView.subviews[containerView.subviews.count-1] is ViewOfGame_Hex {
                    let currentGameView = containerView.subviews[containerView.subviews.count-1] as! ViewOfGame_Hex
                    currentGameView.returnAllTheCases()
                } else if containerView.subviews[containerView.subviews.count-1] is ViewOfGameTriangular {
                    let currentGameView = containerView.subviews[containerView.subviews.count-1] as! ViewOfGameTriangular
                    currentGameView.returnAllTheCases()
                }
                
                gameTimer.stop()
                gameOver(win: false, didTapABomb: false) // on marque 0 pour le
            }
        }
    }
    
    
}


// MARK: - Gere les animations
extension InfiniteGameViewController {
    
    func animateNewSection() {
        
        let view = containerView.subviews.last!
        
        UIView.animate(withDuration: 0.72, animations: {
            view.alpha = 0
        }) { (_) in
            
            view.removeFromSuperview()
            
            self.gameIndex = 0
            self.animateNewLevel()
            
            if self.currentSection.gameType == .hexagonal {
                self.addANewHexGame(game: self.currentSection.game1!) // element 1 (sur le dessus)
                self.addANewHexGame(game: self.currentSection.game2!) // element 0 (en dessous du premier)
            } else if self.currentSection.gameType == .square {
                self.addANewSquareGame(game: self.currentSection.game1!) // element 1 (sur le dessus)
                self.addANewSquareGame(game: self.currentSection.game2!) // element 0 (en dessous du premier)
            } else if self.currentSection.gameType == .triangular {
                self.addANewTriangularGame(game: self.currentSection.game1!)
                self.addANewTriangularGame(game: self.currentSection.game2!)
            }
        }
        
    }
    
    func animateNewLevel() {
        
        let message = MessageEndOfSection()
        
        message.circleColor = colorForRGB(r: 242, g: 180, b: 37)
        message.textColor = colorForRGB(r: 255, g: 255, b: 255)
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
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.duration = 0.3
        groupAnimation.delegate = self
        groupAnimation.setValue("AppearMessageAnimation", forKey: "name")
        groupAnimation.setValue(message, forKey: "message")
        message.layer.add(groupAnimation, forKey: nil)
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
            exitAnimation.fillMode = kCAFillModeForwards
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
            
            blockingView?.removeFromSuperview()
            launchOption3TimerIfNeeded()
            containerView.isUserInteractionEnabled = true
            
        }
        
    }
}

// MARK: - Les actions des bonus
extension InfiniteGameViewController: BonusButtonsCanCallVC {
    
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
        bonusChoiceView!.isTimerOn = returnCurrentGame().isTimerAllowed
        self.view.addSubview(bonusChoiceView!)
    }
    
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
        if currentSection.gameType == .hexagonal {
            let viewOfGameHex = containerView.subviews.last as! ViewOfGame_Hex
            viewOfGameHex.numberOfFlags += values[drapeauLevel]
        } else if currentSection.gameType == .square {
            let viewOfGameSquare = containerView.subviews.last as! ViewOfGameSquare
            viewOfGameSquare.numberOfFlags += values[drapeauLevel]
        } else if currentSection.gameType == .triangular {
            let viewOfGameTriangular = containerView.subviews.last as! ViewOfGameTriangular
            viewOfGameTriangular.numberOfFlags += values[drapeauLevel]
        }
        
    }
    
    
    
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
            
            if currentSection.gameType == .hexagonal {
                let viewOfGameHex = containerView.subviews.last as! ViewOfGame_Hex
                viewOfGameHex.markARandomBomb()
            } else if currentSection.gameType == .square {
                let viewOfGameSquare = containerView.subviews.last as! ViewOfGameSquare
                viewOfGameSquare.markARandomBomb()
            } else if currentSection.gameType == .triangular {
                let viewOfGameTriangular = containerView.subviews.last as! ViewOfGameTriangular
                viewOfGameTriangular.markARandomBomb()
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
    
    
    
    func verificationTapped() { // il faut verifier les drapeaux posée
        if bonus.verification > 0 {
            
            bonus.addVerification(amount: -1)
            bonusChoiceView!.updateTheNumberLabels()
            
            let viewOfGame = containerView.subviews.last!
            
            switch returnCurrentGame().gameType {
            case .square:
                let viewOfGameSquare = viewOfGame as! ViewOfGameSquare
                viewOfGameSquare.verificationBonusFunc()
                
            case .hexagonal:
                let viewOfGameHex = viewOfGame as! ViewOfGame_Hex
                viewOfGameHex.verificationBonusFunc()
                
            case .triangular:
                let viewOfGameTriangular = viewOfGame as! ViewOfGameTriangular
                viewOfGameTriangular.verificationBonusFunc()
                
            }
            
        } else {
            return
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

// MARK: - Message à la fin de partie si le joueur tape sur une bombe.
extension InfiniteGameViewController {
    
    /// Cette fonction ajoute le message approprié quand l'utilisateur tape sur une bombe.
    func addTheMessage() {
        if bonus.vie > 0 {
            // faire apparaitre le message qui demande une nouvelle chance
            messageOne()
        } else {
            
            if money.getCurrentValue() > 0 {
                messageTwo()
            } else {
                endOfInfiniteGame()
                /*
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
                */
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
            let viewOfGame: UIView? = self.containerView.subviews.last
            
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
                    
                    if self.returnCurrentGame().gameType == .hexagonal {
                        let currentViewOfGame = self.containerView.subviews.last as! ViewOfGame_Hex
                        currentViewOfGame.isUserInteractionEnabled = true
                        if self.returnCurrentGame().option3 {
                            currentViewOfGame.option3Timer.start(timeInterval: TimeInterval(self.returnCurrentGame().option3Time), id: "Option3")
                        }
                    } else if self.returnCurrentGame().gameType == .square {
                        let currentViewOfGame = self.containerView.subviews.last as! ViewOfGameSquare
                        currentViewOfGame.isUserInteractionEnabled = true
                        if self.returnCurrentGame().option3 {
                            currentViewOfGame.option3Timer.start(timeInterval: TimeInterval(self.returnCurrentGame().option3Time), id: "Option3")
                        }
                    } else if self.returnCurrentGame().gameType == .triangular {
                        let currentViewOfGame = self.containerView.subviews.last as! ViewOfGameTriangular
                        currentViewOfGame.isUserInteractionEnabled = true
                        if self.returnCurrentGame().option3 {
                            currentViewOfGame.option3Timer.start(timeInterval: TimeInterval(self.returnCurrentGame().option3Time), id: "Option3")
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
                self.endOfInfiniteGame()
                /*
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
                */
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
            coinView.playParticleAnimation()
            
            var viewToRemove: BombView?
            let viewOfGame: UIView? = self.containerView.subviews.last
            
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
                    
                    if self.returnCurrentGame().gameType == .hexagonal {
                        let viewOfGame = self.containerView.subviews.last as! ViewOfGame_Hex
                        viewOfGame.isUserInteractionEnabled = true
                        if self.returnCurrentGame().option3 {
                            viewOfGame.option3Timer.start(timeInterval: TimeInterval(self.returnCurrentGame().option3Time), id: "Option3")
                        }
                    } else if self.returnCurrentGame().gameType == .square {
                        let viewOfGame = self.containerView.subviews.last as! ViewOfGameSquare
                        viewOfGame.isUserInteractionEnabled = true
                        if self.returnCurrentGame().option3 {
                            viewOfGame.option3Timer.start(timeInterval: TimeInterval(self.returnCurrentGame().option3Time), id: "Option3")
                        }
                    } else if self.returnCurrentGame().gameType == .triangular {
                        let viewOfGame = self.containerView.subviews.last as! ViewOfGameTriangular
                        viewOfGame.isUserInteractionEnabled = true
                        if self.returnCurrentGame().option3 {
                            viewOfGame.option3Timer.start(timeInterval: TimeInterval(self.returnCurrentGame().option3Time), id: "Option3")
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
                self.endOfInfiniteGame()
                /*
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
                */
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
        return (containerView.subviews.last?.frame.width)!
        
    }
    
}


