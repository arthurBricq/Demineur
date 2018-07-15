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
    @IBOutlet weak var pauseButton: PauseButton!
    // Cette variable s'occupe de contenir les parties du jeu.
    //@IBOutlet weak var containerView: UIView!
    var containerView = UIView()
    var blockingView: UIView? = UIView()
    
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
        
        let containerWidth = self.view.frame.width*0.95
        let containerHeight = self.view.frame.height * (isItABigScreen() ? 0.7 : 0.8 )
        let ox = view.frame.width/2 - containerWidth/2
        let oy = (isItABigScreen() ? 0.16 : 0.10) * view.frame.height
        print("positionnement du container view: \(oy)")
        containerView.frame = CGRect(x: ox, y: oy, width: containerWidth, height: containerHeight)
        self.view.addSubview(containerView)
        
        /// Pour la position de la containerView
        containerView.backgroundColor = UIColor.clear
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 0.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clockView.alpha = 0
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
        hasToFinishTheGame = true
        
        if sectionIndex%3 == 0 {
            currentSection = Section(simpleSquareGameWith: (12,9))
        } else if sectionIndex%3 == 1 {
            currentSection = Section(simpleHexGameWith: (12,9))
        } else if sectionIndex%3 == 2 {
            currentSection = Section(simpleTriangularGameWith: (8,11))
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
            if returnCurrentGame().isTimerAllowed {
                gameTimer.start(timeInterval: 1.0, id: "")
            }
        }
        
        // met à jour les affichages, etc. et lance la partie
        updateLabels(numberOfFlags: returnCurrentGame().numberOfFlag, onNewGame: true)
        
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
        print("AAA")
        
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
        updateLabels(numberOfFlags: returnCurrentGame().numberOfFlag, onNewGame: true)
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
        //containerView.subviews.first?.isUserInteractionEnabled = false
        containerView.subviews.last?.isUserInteractionEnabled = true
    }
    
    func updateLabels(numberOfFlags: Int, onNewGame: Bool = false) {
        
        if returnCurrentGame().areNumbersShowed && !onNewGame {
            bombCounterLabel.text = returnCurrentGame().z.description
            flagCounterLabel.text = numberOfFlags.description
        }
        
        if !returnCurrentGame().isTimerAllowed {
            if onNewGame {
                if clockView.alpha != 0 {
                    let anim = Animator().fadeOut(duration: 0.5)
                    anim.fillMode = kCAFillModeBackwards
                    clockView.layer.add(anim, forKey: nil)
                    clockView.alpha = 0
                }
            }
        } else {
            
            if onNewGame {
                if clockView.alpha != 0 {
                    // Faire l'animation du retour de l'horloge
                } else {
                    let anim = Animator().fadeIn(duration: 0.5)
                    anim.fillMode = kCAFillModeBackwards
                    clockView.layer.add(anim, forKey: nil)
                    clockView.alpha = 1
                }
                
                gameTimer.delegate = self
                gameTimer.timeInterval = 1.0
            }
        }
        
        if !returnCurrentGame().areNumbersShowed {
            
            if onNewGame {
                let anim = Animator().fadeOut(duration: 0.5)
                anim.fillMode = kCAFillModeBackwards
                
                if flagView.alpha != 0 {
                    flagView.layer.add(anim, forKey: nil)
                    flagView.alpha = 0
                }
                
                if flagCounterLabel.alpha != 0 {
                    flagCounterLabel.layer.add(anim, forKey: nil)
                    flagCounterLabel.alpha = 0
                }
                
                if bombView.alpha != 0 {
                    bombView.layer.add(anim, forKey: nil)
                    bombView.alpha = 0
                }
                
                if bombCounterLabel.alpha != 0 {
                    bombCounterLabel.layer.add(anim, forKey: nil)
                    bombCounterLabel.alpha = 0
                }
            }
            
        } else {
            
            if onNewGame {
                let anim = Animator().fadeIn(duration: 0.5)
                anim.fillMode = kCAFillModeBackwards
                
                if flagView.alpha != 1 {
                    
                    bombCounterLabel.text = returnCurrentGame().z.description
                    flagCounterLabel.text = numberOfFlags.description
                    
                    flagView.layer.add(anim, forKey: nil)
                    flagView.alpha = 1
                } else {
                    let fadeOut = Animator().fadeOut(duration: 0.25)
                    fadeOut.fillMode = kCAFillModeBoth
                    fadeOut.delegate = self
                    fadeOut.setValue("FadeDisplay", forKey: "name")
                    fadeOut.setValue(flagView, forKey: "layer")
                    fadeOut.setValue(returnCurrentGame().z.description, forKey: "bomb")
                    fadeOut.setValue(numberOfFlags.description, forKey: "flag")
                    flagView.layer.add(fadeOut, forKey: nil)
                }
                
                if flagCounterLabel.alpha != 1 {
                    flagCounterLabel.layer.add(anim, forKey: nil)
                    flagCounterLabel.alpha = 1
                } else {
                    let fadeOut = Animator().fadeOut(duration: 0.25)
                    fadeOut.fillMode = kCAFillModeBoth
                    fadeOut.delegate = self
                    fadeOut.setValue("FadeDisplay", forKey: "name")
                    fadeOut.setValue(flagCounterLabel, forKey: "layer")
                    fadeOut.setValue(returnCurrentGame().z.description, forKey: "bomb")
                    fadeOut.setValue(numberOfFlags.description, forKey: "flag")
                    flagCounterLabel.layer.add(fadeOut, forKey: nil)
                }
                
                if bombView.alpha != 1 {
                    bombView.layer.add(anim, forKey: nil)
                    bombView.alpha = 1
                } else {
                    let fadeOut = Animator().fadeOut(duration: 0.25)
                    fadeOut.fillMode = kCAFillModeBoth
                    fadeOut.delegate = self
                    fadeOut.setValue("FadeDisplay", forKey: "name")
                    fadeOut.setValue(bombView, forKey: "layer")
                    fadeOut.setValue(returnCurrentGame().z.description, forKey: "bomb")
                    fadeOut.setValue(numberOfFlags.description, forKey: "flag")
                    bombView.layer.add(fadeOut, forKey: nil)
                }
                
                if bombCounterLabel.alpha != 1 {
                    bombCounterLabel.layer.add(anim, forKey: nil)
                    bombCounterLabel.alpha = 1
                } else {
                    let fadeOut = Animator().fadeOut(duration: 0.25)
                    fadeOut.fillMode = kCAFillModeBoth
                    fadeOut.delegate = self
                    fadeOut.setValue("FadeDisplay", forKey: "name")
                    fadeOut.setValue(bombCounterLabel, forKey: "layer")
                    fadeOut.setValue(returnCurrentGame().z.description, forKey: "bomb")
                    fadeOut.setValue(numberOfFlags.description, forKey: "flag")
                    bombCounterLabel.layer.add(fadeOut, forKey: nil)
                }
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
            containerView.isUserInteractionEnabled = false
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
        
        if returnCurrentGame().isTimerAllowed {
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
                print("test1")
                gameOver(win: false)
            }
        }
    }
    
    
}


// Gere les animations
extension InfiniteGameViewController {
    
    func animateNewSection() {
        
        let view = containerView.subviews.last!
        
        UIView.animate(withDuration: 0.72, animations: {
            view.alpha = 0
        }) { (_) in
            
            view.removeFromSuperview()
            
            self.gameIndex = 0
            print("Section = \(self.sectionIndex)     Game = \(self.gameIndex)")
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
        message.sectionIndex = 5*sectionIndex + gameIndex + 1
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
            if returnCurrentGame().isTimerAllowed {
                gameTimer.start(timeInterval: 1.0, id: "")
            }
            
        } else if id == "FadeDisplay" {
            
            let view = anim.value(forKey: "layer") as? UIView
            bombCounterLabel.text = anim.value(forKey: "bomb") as? String
            flagCounterLabel.text = anim.value(forKey: "flag") as? String
            anim.setValue(nil, forKey: "bomb")
            anim.setValue(nil, forKey: "flag")
            anim.setValue(nil, forKey: "name")
            anim.setValue(nil, forKey: "layer")
            
            let fadeIn = Animator().fadeIn(duration: 0.25)
            fadeIn.fillMode = kCAFillModeBackwards
            view?.layer.add(fadeIn, forKey: nil)
            view?.alpha = 1
            
        }
        
    }
}
