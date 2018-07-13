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
    
    //// MARK : outlets
    
    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var bombCounterLabel: UILabel!
    @IBOutlet weak var bombView: BombViewDisplay!
    @IBOutlet weak var flagCounterLabel: UILabel!
    @IBOutlet weak var flagView: FlagViewDisplay!
    // Cette variable s'occupe de contenir les parties du jeu.
    //@IBOutlet weak var containerView: UIView!
    var containerView = UIView()
    
    //// MARK : variables
    
    var sectionIndex: Int = 0
    var gameIndex: Int = 1
    var emptyGameState = [[Int]].init()
    var gameState = [[Int]].init() // Pour la partie en cours ...
    
    var currentSection = Section(simpleHexGameWith: (11,9)) // création de la section courante
    
    var gameTimer = CountingTimer()
    var animationTimer = CountingTimer()
    
    var hasToFinishTheGame: Bool = true // This variable is used in order to call only once the function 'currentGameIsFinished'. Indeed, it is called many times for a very strange reason.
    
    
    //// MARK : actions of buttons
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
    
    
    //// MARK : all functions
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let containerWidth = self.view.frame.width*0.93
        let containerHeight = self.view.frame.height*0.9
        let ox = view.frame.width/2 - containerWidth/2
        let oy = 0.09*view.frame.height
        print("positionnement du container view: \(oy)")
        containerView.frame = CGRect(x: ox, y: oy, width: containerWidth, height: containerHeight)
        self.view.addSubview(containerView)
        
        containerView.backgroundColor = UIColor.clear
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 0.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isTheGameStarted.delegate = self // permet le positionnement des bombes pos-début.
        
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
        gameIndex = 1
        hasToFinishTheGame = true
        
        if sectionIndex%3 == 0 {
            currentSection = Section(simpleSquareGameWith: (11,9))
        } else if sectionIndex%3 == 1 {
            currentSection = Section(simpleHexGameWith: (11,9))
        } else if sectionIndex%3 == 2 {
            currentSection = Section(simpleTriangularGameWith: (6,7))
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
        } else {
            
            // sinon on positionne la première partie de la nouvelle section à droite de celle active
            if currentSection.gameType == .square {
                addANewSquareGame(game: currentSection.game1!, isFirst: true)
            } else if currentSection.gameType == .hexagonal {
                addANewHexGame(game: currentSection.game1!, isFirst: true)
            } else if currentSection.gameType == .triangular {
                addANewTriangularGame(game: currentSection.game1!, isFirst: true)
            }
            
            // on supprime la partie courrante
            containerView.subviews[containerView.subviews.count-1].removeFromSuperview()
            
            // modifie l'anchor point des view et le repositionne en conséquence pour donner une meilleure impression lors de l'animation
            let view1 = containerView.subviews[containerView.subviews.count-1]
            view1.layer.anchorPoint.x = 1
            view1.center.x = view1.center.x + view1.bounds.width/2
            
            let view2 = containerView.subviews[containerView.subviews.count-2]
            view2.layer.anchorPoint.x = 0
            view2.center.x = view2.center.x - view2.bounds.width/2
            
            // on cache la deuxième vue, qui n'apparait qu'une fois l'animation commencée
            view2.isHidden = true
            
            // on lance le timer qui gère l'animation
            animationTimer.start(timeInterval: 0.01, id: "Animation")
            animationTimer.delegate = self
        }
        
        // met à jour les affichages, etc. et lance la partie
        updateLabels(numberOfFlags: returnCurrentGame().numberOfFlag)
        launchOption3TimerIfNeeded()
        containerView.isUserInteractionEnabled = true ;
        gameTimer.start(timeInterval: 1.0, id: "")
        
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
        updateLabels(numberOfFlags: returnCurrentGame().numberOfFlag)
        launchOption3TimerIfNeeded()
        updateUserInteractionProperty()
        hasToFinishTheGame = true
        gameTimer.start(timeInterval: 1.0, id: "")
    }
    
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
        
        let origin = CGPoint(x: containerView.frame.width/2 + (isFirst ? width/2 : -width/2), y: containerView.frame.height/2 - height/2)
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
        let origin = (height > containerView.frame.height) ? CGPoint(x: containerView.frame.width/2 + (isFirst ? width/2 : -width/2), y: (containerView.frame.height/2 - height/2)*0.5) : CGPoint(x: containerView.frame.width/2 + (isFirst ? width/2 : -width/2), y: containerView.frame.height/2 - height/2)
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
        let origin = CGPoint(x: containerView.bounds.width/2 + (isFirst ? w/2 : -w/2), y: (containerView.bounds.height - h)/2)
        
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
    
    func updateLabels(numberOfFlags: Int) {
        let currentGame = returnCurrentGame()
        bombCounterLabel.text = currentGame.z.description
        flagCounterLabel.text = numberOfFlags.description
        
        if !returnCurrentGame().isTimerAllowed {
            clockView.isHidden = true
        } else {
            clockView.isHidden = false
            gameTimer.delegate = self
            gameTimer.timeInterval = 1.0
        }
        
        if !returnCurrentGame().areNumbersShowed {
            flagView.isHidden = true
            flagCounterLabel.isHidden = true
            bombView.isHidden = true
            bombCounterLabel.isHidden = true
        } else {
            flagView.isHidden = false
            flagCounterLabel.isHidden = false
            bombView.isHidden = false
            bombCounterLabel.isHidden = false
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

// *********** Creation d'une nouvelle partie **************** //
// Ces fonctions sont appelée lorsqu'on a besoin de créer une nouvelle partie.
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
        displayIntMatrix(matrix: gameState)
        
    }
    
    
    ///// HEX
    func updateHexGameState(withFirstTouched touch: (x: Int, y: Int)) {
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGame_Hex
        let z = currentViewOfGame.z
        positionBombsHex(gameState: &currentViewOfGame.gameState, z: z, withFirstTouched: touch)
        createNumbersToDisplayHex(gameState: &currentViewOfGame.gameState)
        currentViewOfGame.updateAllNumbers()
        displayIntMatrix(matrix: currentViewOfGame.gameState)
    }
    
    
    ///// TRIANGLE
    func updateTriangularGameState(withFirstTouched touch: (x:Int, y: Int)) {
        let currentViewOfGame = containerView.subviews[containerView.subviews.count-1] as! ViewOfGameTriangular
        let z = currentViewOfGame.z
        positionBombsSquare(in: &currentViewOfGame.gameState, numberOfBombs: z, withFirstTouched: touch)
        createNumbersToDisplayTriangle(in: &currentViewOfGame.gameState)
        currentViewOfGame.updateAllNumbers()
        displayIntMatrix(matrix: currentViewOfGame.gameState)
        
    }
    
}


/// Gérer la création de la partie après le premier touché.
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
        
        
    }
}


/// Gerer la fin de la partie (lancée par le gameView)
extension InfiniteGameViewController: GameViewCanCallVC {
    func gameOver(win: Bool) {
        if win {
            if hasToFinishTheGame {
                hasToFinishTheGame = false
            } else {
                return
            }
            
            Vibrate().vibrate(style: .heavy)
            
            isTheGameStarted.value = false
            print("fin de la partie courante")
            currentGameIsFinished()
            
            
        } else {
            
            Vibrate().vibrate(style: .heavy)
            
            print("Game-Over")
            gameTimer.stop()
            containerView.isUserInteractionEnabled = false ;
        }
    }
    
    func updateFlagsDisplay(numberOfFlags: Int) {
        updateLabels(numberOfFlags: numberOfFlags)
    }
}

/// Gerer l'affichage de l'horloge
extension InfiniteGameViewController: CountingTimerProtocol
{
    func timerFires(id: String) {
        
        if id == "Animation" {
            
            let animationDuration: CGFloat = 1
            
            let percent : CGFloat = animationTimer.counter/animationDuration
            setViews(atPercent: percent, view1: containerView.subviews[containerView.subviews.count-1], view2: containerView.subviews[containerView.subviews.count-2])
            
            if percent >= 1 {
                
                animationTimer.stop()
                containerView.subviews[containerView.subviews.count-1].removeFromSuperview()
                
                // centre correctement la vue à fin
                let newGameView = containerView.subviews[containerView.subviews.count-1]
                newGameView.layer.transform = CATransform3DIdentity
                newGameView.center.x = newGameView.center.x - newGameView.bounds.width
                
                // ajoute la deuxième vue en dessous
                if currentSection.gameType == .hexagonal {
                    addANewHexGame(game: currentSection.game2!)
                } else if currentSection.gameType == .square {
                    addANewSquareGame(game: currentSection.game2!)
                } else if currentSection.gameType == .triangular {
                    addANewTriangularGame(game: currentSection.game2!)
                }
                
            }
            
        } else {
            
            let pourcentage: CGFloat = gameTimer.counter / CGFloat(returnCurrentGame().totalTime) // ratio of time used.
            
            clockView.pourcentage = pourcentage // et actualisation via un didSet
            
            if pourcentage >= 1 {
                
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
                gameOver(win: false)
            }
        }
    }
    
    
}


// Gere les animations
extension InfiniteGameViewController {
    
    func setViews(atPercent: CGFloat, view1: UIView, view2: UIView) {
        
        func view1Transform(percent: CGFloat, translateBy: CGFloat) -> CATransform3D {
            var identity = CATransform3DIdentity
            identity.m34 = -1/1000
            
            let angle = percent * .pi * -0.5
            
            let rotationTransform = CATransform3DRotate(identity, angle, 0, 1, 0)
            let translationTransform = CATransform3DMakeTranslation(percent*translateBy, 0, 0)
            
            return CATransform3DConcat(rotationTransform, translationTransform)
        }
        
        func view2Transform(percent: CGFloat, translateBy: CGFloat) -> CATransform3D {
            var identity = CATransform3DIdentity
            identity.m34 = -1/1000
            
            let angle = (1-percent) * .pi * 0.5
            
            let rotationTransform = CATransform3DRotate(identity, angle, 0, 1, 0)
            let translationTransform = CATransform3DMakeTranslation(percent*translateBy, 0, 0)
            
            return CATransform3DConcat(rotationTransform, translationTransform)
        }
        
        view1.layer.transform = view1Transform(percent: atPercent, translateBy: -view1.bounds.width)
        view1.alpha = max(0.4, (1-atPercent))
        view2.layer.transform = view2Transform(percent: atPercent, translateBy: -view1.bounds.width)
        view2.alpha = max(0.4, atPercent)
        view2.isHidden = false
    }
    
}
