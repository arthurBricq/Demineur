//
//  HistoryGameViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 12/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class HistoryGameViewController: GameViewController {
    
    override func setUpLabelsForNewGame() {
        
        addTheBonusChoiceView()
        
        
        if !game.isTimerAllowed {
            clockView.isHidden = true
            //viewOfGame!.gameTimer.delegate = nil
        } else {
            clockView.isHidden = false
            clockView.pourcentage = 0.0
            //viewOfGame!.gameTimer.delegate = self
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
        /*
        if game.option3 {
            viewOfGame?.option3Timer.start(timeInterval: TimeInterval(game.option3Time), id: "Option3")
            viewOfGame?.option3Timer.delegate = viewOfGame
        }*/
    }
    
    /// This function will either create the bonusBarView or replace it with a new one when a new game is started
    /// - When calling the function, be sure that the viewOfGame already exists.
    private func addTheBonusChoiceView() {
        let screenW = self.view.frame.width
        let screenH = self.view.frame.height
        if bonusChoiceView != nil { bonusChoiceView?.removeFromSuperview() }
        /*let dec_h: CGFloat = 20 // decalage horizontal
         let dec_v: CGFloat = isItABigScreen() ? 30 : 15 // decalage vertical
         let w = screenW - dec_h*/
        let w = screenW
        let h = w/3
        let size = CGSize(width: w, height: h)
        let origin = CGPoint(x: 0, y: screenH - h)
        let frame = CGRect(origin: origin, size: size)
        bonusChoiceView = BonusChoiceView(frame: frame, viewOfGame: viewOfGame!, gameTimer: gameTimer, backgroundColor: UIColor(red: 0.6, green: 0.6, blue: 0.55, alpha: 0.6), lineColor: UIColor(red: 0.5, green: 0.5, blue: 0.45, alpha: 1))
        //bonusChoiceView = BonusChoiceView(frame: CGRect(origin: origin, size: size), viewOfGame: viewOfGame!, gameTimer: gameTimer)
        //bonusChoiceView!.progress = 0.0
        self.view.addSubview(bonusChoiceView!)
    }
    
    
}














/*
class HistoryGameViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var flagsLabel: UILabel!
    @IBOutlet weak var flagView: FlagViewDisplay!
    @IBOutlet weak var bombsLabel: UILabel!
    @IBOutlet weak var bombView: BombViewDisplay!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - VARIABLES
    
    override var prefersStatusBarHidden: Bool { return true }
    
    var gameIndex: Int = 1
    /// Nombre de bombes qui ont été trouvées par l'utilisateur
    var numberOfBombs: Int = 0
    var gameState = [[Int]].init()
    var gameTimer = CountingTimer()
    var game: OneGame = OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 20, m: 13, z: 10, totalTime: 90)
    var viewOfGame: ViewOfGame?
    var bonusChoiceView: BonusChoiceView?
    var messageManagor: MessageManagor?
    
    // MARK: - FUNCTIONS
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transitioningDelegate = nil
        isTheGameStarted.delegate = self // Cela permet, via cette variable, d'appeller le VC qui s'occupe du jeu pour créer la partie
        startANewGame(animatedFromTheRight: false)
        messageManagor = MessageManagor(viewOfGame: viewOfGame!, gameTimer: gameTimer, superView: self.view, clockView: clockView, functionToFinishGame: { (didTapABomb) in
            self.endOfHistoryGame(didTapABomb)
        })
    }

    /// This function will start a new game, with the 'viewOfGame' as gameManager for the game 'game' variable.
    func startANewGame(animatedFromTheRight: Bool) {
        // 0. Set te colors
        let color1: UIColor = colorForRGB(r: 52, g: 61, b: 70)
        game.colors = ColorSetForOneGame(openColor: colorForRGB(r: 192, g: 197, b: 206) , emptyColor: UIColor.white, strokeColor: color1, textColor: color1)
        
        // 1. Kill the last variables of the game
        gameTimer.stop()
        isTheGameStarted.value = false
        self.numberOfBombs = 0
       
       
        if game.gameType == .square { // read comments to understand. 
            createANewSquareGameStepOne()
            viewOfGame = SquareViewOfGame(game: game, gameState: &gameState, scrollViewDimension: scrollView.frame.size)
            viewOfGame!.layer.borderWidth = 1.0
            if animatedFromTheRight {
                let size = viewOfGame!.dimension
                viewOfGame!.frame.origin = CGPoint(x: self.view.center.x - size.width/2 + self.view.frame.width, y: self.view.center.y - size.height/2)
            }
        } else if game.gameType == .hexagonal {
            createANewHexGameStepOne()
            viewOfGame = HexViewOfGame(game: game, gameState: &gameState, scrollViewDimension: scrollView.frame.size)
            /*
            let center = self.view.center
            let (w,h) = dimensionHexTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let origin = animatedFromTheRight ? CGPoint(x: center.x - w/2 + self.view.frame.width, y: center.y - h/2) : CGPoint(x: center.x - w/2, y: center.y - h/2)
            viewOfGame = HexViewOfGame(frame: CGRect(origin: origin, size: CGSize.init(width: w, height: h)), game: game, gameState: &gameState)
             */
        } else if game.gameType == .triangular {
            createNewTriangularGameStepOne()
            viewOfGame = TriangleViewOfGame(game: game, gameState: &gameState, scrollViewDimension: scrollView.frame.size)
            /*
            let center = self.view.center
            let (w,h) = dimensionTriangularTable(n: game.n, m: game.m, maxW: maxWidth, maxH: maxHeight)
            let origin = animatedFromTheRight ? CGPoint(x: center.x - w/2 + self.view.frame.width, y: center.y - h/2) : CGPoint(x: center.x - w/2, y: center.y - h/2)
            viewOfGame = TriangleViewOfGame(frame: CGRect(origin: origin, size: CGSize.init(width: w, height: h)), game: game, gameState: &gameState)
            */
        }
        
        // Set the properties of the view of game
        viewOfGame!.backgroundColor = UIColor.clear
        viewOfGame!.makeDarkBorderDisplay()
        viewOfGame!.delegate = self
        viewOfGame!.layer.masksToBounds = false
//        viewOfGame!.layer.borderColor = game.colors.strokeColor.cgColor
        viewOfGame!.numberOfFlags = game.numberOfFlag
        viewOfGame!.onPosingFlag = { (test: Bool) -> Void in
            self.numberOfBombs += test ? 1 : 0
        }
        
        setUpLabelsForNewGame()
        updateFlags(numberOfFlags: game.numberOfFlag)
        removePrecendentViewOfGame()
        addTheBonusChoiceView()
        
        // Set the properties of the scroll view
        setUpScrollView()
        
        if animatedFromTheRight {
            UIView.animate(withDuration: 0.7) {
                self.viewOfGame?.center.x -= self.view.frame.width
            }
        }
    }
    
    /// This function will either create the bonusBarView or replace it with a new one when a new game is started
    /// - When calling the function, be sure that the viewOfGame already exists.
    private func addTheBonusChoiceView() {
        let screenW = self.view.frame.width
        let screenH = self.view.frame.height
        let dec_h: CGFloat = 20 // decalage horizontal
        let dec_v: CGFloat = isItABigScreen() ? 30 : 15 // decalage vertical
        let w = screenW - dec_h
        let h = w/6
        let size = CGSize(width: w, height: h)
        let origin = CGPoint(x: dec_h/2, y: screenH - h - dec_v)
        if bonusChoiceView != nil { bonusChoiceView?.removeFromSuperview() }
        bonusChoiceView = BonusChoiceView(frame: CGRect(origin: origin, size: size), viewOfGame: viewOfGame!, gameTimer: gameTimer)
        bonusChoiceView!.progress = 0.0
        self.view.addSubview(bonusChoiceView!)
    }
    
    /// retire tous les view of game qui sont présent sur l'écran. Il faut penser à rajouter une nouvelle vue avec 'startANewGame()' après faire l'appel de cette fonction.
    public func removePrecendentViewOfGame() {
        viewOfGame?.removeFromSuperview()
    }
    
    private func openTheBombs() {
        viewOfGame?.returnAllTheCases()
    }
    
    private func updateFlags(numberOfFlags: Int) {
        flagsLabel.text = numberOfFlags.description
        bombsLabel.text = game.z.description
    }
    
    /// This function set up all the settings of the scroll view. The viewOfGame must be already set, and it will be added to the scroll view.
    private func setUpScrollView() {
        // Scroll View settings
        // 1. General settings
        scrollView.delegate = self
        scrollView.layer.zPosition = -1 // permet de placer la vue du jeu derrières l'interface
        scrollView.bounces = true // permet de faire rebondir sur les dépassements
        scrollView.clipsToBounds = false // Permet de faire dépasser le jeu sur tout l'écran de l'iphone
        scrollView.isScrollEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        
        // 2. Settings specific to one view of game
        let widthRatio = (self.scrollView!.frame.width) / (viewOfGame!.frame.size.width+30)
        let heightRatio = (self.scrollView!.frame.height) / (viewOfGame!.frame.size.height)
        self.scrollView.minimumZoomScale = widthRatio < heightRatio ? widthRatio : heightRatio
        scrollView.makeRedBorderDisplay()
        self.scrollView.maximumZoomScale = 2
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
        self.scrollView.contentSize = CGSize(width: viewOfGame!.frame.size.width+20, height: viewOfGame!.frame.size.height)
        self.scrollView.addSubview(viewOfGame!)
        /*
        print("\nState of the variables:")
        print("Initial zoom \(widthRatio)")
        print("Scroll view frame: \(scrollView.frame)")
        print("Scroll view content frame: \(scrollView.contentSize)")
        print("View of game frame: \(viewOfGame!.frame)")
        */
    }
    
    /// This function will show/hide the correct view amoung the 'clockView', the 'flagLabel', the 'flagView', the 'bombLabel', the 'bombView' and it will do some setUp for the 'gameTimeVariable'.
    private func setUpLabelsForNewGame() {
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
extension HistoryGameViewController: GameController {
    
    func gameOver(win: Bool, didTapABomb: Bool, didTimeEnd: Bool) {
        
        Vibrate().vibrate(style: .heavy)
        
        gameTimer.pause()
        
        viewOfGame!.isUserInteractionEnabled = false
        viewOfGame!.option3Timer.stop()
        viewOfGame!.pauseAllOption1Timers()
    
        if didTapABomb || didTimeEnd {
            messageManagor?.addTheMessage(didTapABomb: didTapABomb)
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
    
    fileprivate func endOfHistoryGame(_ didTapABomb: Bool) {
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

// MARK: - Scroll view extension

extension HistoryGameViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.viewOfGame
    }
}
*/
