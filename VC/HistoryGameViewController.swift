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
        
        // instauration du timer
        if !game.isTimerAllowed {
            clockView.isHidden = true
        } else {
            clockView.isHidden = false
            gameTimer.delegate = self
            gameTimer.timeInterval = 1.0
        }
        
        // instauration des drapeaux et des bombes
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
        
        
        isTheGameStarted.delegate = self // Cela permet, via cette variable, d'appeller le VC qui s'occupe du jeu.
        
        startANewGame()
        
        // instauration de la bar des bonus
        addTheBonusChoiceView()
    
        
        
        
    }
    
    
    func addTheBonusChoiceView() {
        
        print("aaa")
        
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
        // Quelques détails relatif aux timer
        gameTimer.stop()
        clockView.pourcentage = 0.0
        isTheGameStarted.value = false
        updateFlags(numberOfFlags: game.numberOfFlag)
        
        
        print("Niveau Courant : \(gameIndex)")
        
        
        // Tailles maximales occupées par la vue :
        let maxHeight = self.view.bounds.height * 0.65
        let multiplier: CGFloat = isItABigScreen() ? 0.98 : 0.85
        let maxWidth = game.gameType == .square ? self.view.bounds.width * multiplier : self.view.bounds.width * 0.95
        
        removePrecendentViewOfGame()
        
        let color1: UIColor = colorForRGB(r: 52, g: 61, b: 70)
        game.colors = ColorSetForOneGame(openColor: colorForRGB(r: 192, g: 197, b: 206) , emptyColor: UIColor.white, strokeColor: color1, textColor: color1)
        
        gameTimer.start(timeInterval: 1.0, id: "Clock")
        
        if game.gameType == .square {
            createANewSquareGameStepOne()
            
            let gameView = ViewOfGameSquare()
            let (width, height) = dimensionSquareTable(n: game.n, m: game.m, withMaximumWidth: maxWidth, withMaximumHeight: maxHeight)
            print("largeur de la vue: \(width)")
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
            let center = self.view.center
            let (w,h) = dimensionHexTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let origin = CGPoint(x: center.x - w/2, y: center.y - h/2 + 50)
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
            let center = self.view.center
            let (w,h) = dimensionTriangularTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let origin = CGPoint(x: center.x - w/2, y: center.y - h/2 + 20)
            
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
        displayIntMatrix(matrix: gameState)
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
        displayIntMatrix(matrix: gameState)
        viewOfGameHex!.gameState = gameState // on actualise la nouvelle carte du jeu
        viewOfGameHex!.updateAllNumbers()
    }
    
    ///// TRIANGLE
    func createNewTriangularGameStepOne() {
        gameState = createEmptySquareGameState(n: game.n, m: game.m)
        positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameState)
    }
    
    func updateTriangularGameStepTwo(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsSquare(in: &gameState, numberOfBombs: game.z, withFirstTouched: (touch.x,touch.y))
        displayIntMatrix(matrix: gameState)
        createNumbersToDisplayTriangle(in: &gameState)
        displayIntMatrix(matrix: gameState)
        viewOfGameTriangular!.gameState = gameState
        viewOfGameTriangular!.updateAllNumbers()
    }
}

// Quand la partie est terminée
extension HistoryGameViewController: GameViewCanCallVC {
    
    func gameOver(win: Bool, didTapABomb: Bool) {
        gameTimer.stop()
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

extension HistoryGameViewController: variableCanCallGameVC {
    func createTheGame(withFirstTouched touch: (x: Int, y: Int)) { // cette fonction est appelée lorsque l'utilisateur tape sur la première case : cela apelle cette fonction immédiatement avec le touches began, puis la partie commence comme il le faut grâce au touchesEnded.
        if game.gameType == .hexagonal {
            updateHexGameState(withFirstTouched: (touch.x,touch.y))
        } else if game.gameType == .square {
            updateSquareGame(withFirstTouched: (touch.x,touch.y))
        } else if game.gameType == .triangular {
            updateTriangularGameStepTwo(withFirstTouched: (touch.x,touch.y))
        }
    }
}


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
        
        print("e")
        
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


