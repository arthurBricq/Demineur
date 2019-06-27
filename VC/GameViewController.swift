
//
//  GameViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 03/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit


/// This class is in charge of presenting one game only, which can be of any size and of any type, and let the user play.
/// The class canno't be instantiated to control a view controller. It's the parent class of 2 other VC: historyGameViewController and superPartieGameViewController
class GameViewController: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var flagsLabel: UILabel!
    @IBOutlet weak var flagView: FlagViewDisplay!
    @IBOutlet weak var bombsLabel: UILabel!
    @IBOutlet weak var bombView: BombViewDisplay!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override var prefersStatusBarHidden: Bool { return true }

    // MARK: - VARIABLES
    
    var gameIndex: Int = 1
    /// Nombre de bombes qui ont été trouvées par l'utilisateur
    var numberOfBombs: Int = 0
    var gameState = [[Int]].init()
    var game: OneGame = OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 20, m: 13, z: 10, totalTime: 90)
    var viewOfGame: ViewOfGame?
    var bonusChoiceView: BonusChoiceView?
    var messageManagor: MessageManagor?
    var gameTimer: CountingTimer?
    
    // MARK: - Constants
    
    let maximumZoom: CGFloat = 2.0
    
    // MARK: - Actions
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        gameTimer?.pause()
        viewOfGame?.option3Timer.pause()
        viewOfGame?.pauseAllOption1Timers()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pauseVC = storyboard.instantiateViewController(withIdentifier: "Pause") as! PauseViewController
        pauseVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pauseVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pauseVC.pausedGameViewController = self
        self.present(pauseVC, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transitioningDelegate = nil
        isTheGameStarted.delegate = self
    }
    
    /// This function will show/hide the correct view amoung the 'clockView', the 'flagLabel', the 'flagView', the 'bombLabel', the 'bombView' and it will do some setUp for the 'gameTimeVariable'.
    func setUpLabelsForNewGame() {
        fatalError("This function needs to be overiden by children")
    }
    
    /// Will put the alpha of the views on the top of screen to be zero. Those lights must be turned on again when creating a new game.
    public func clearScreen() {
        flagView.alpha = 0.0
        flagsLabel.alpha = 0.0
        bombView.alpha = 0.0
        bombsLabel.alpha = 0.0
        viewOfGame?.alpha = 0.0
    }
    
    /// Will make appear the view of game and the labels associated with the game.
    public func presentGame() {
        // 1. Put the view of game
        removePrecendentViewOfGame()
        startANewGame(animatedFromTheRight: false)
        viewOfGame?.alpha = 0.0
        // 2. And make it appear
        UIView.animate(withDuration: 0.5) {
            self.flagView.alpha = 1.0
            self.flagsLabel.alpha = 1.0
            self.bombView.alpha = 1.0
            self.bombsLabel.alpha = 1.0
            self.viewOfGame?.alpha = 1.0
        }
    }
    
    // MARK: - Functions for the game gestion
    
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
        self.scrollView.maximumZoomScale = maximumZoom
        self.scrollView.contentSize = CGSize(width: viewOfGame!.frame.size.width+20, height: viewOfGame!.frame.size.height)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
        let p = CGPoint(x: scrollView!.frame.width/2 - viewOfGame!.frame.size.width/2, y: 50)
        viewOfGame!.frame.origin = p
        self.scrollView.addSubview(viewOfGame!)
        
         print("\nState of the variables:")
         print("Initial zoom \(widthRatio)")
         print("Scroll view frame: \(scrollView.frame)")
         print("Scroll view content frame: \(scrollView.contentSize)")
         print("View of game frame: \(viewOfGame!.frame)")
 
    }
    
    // MARK: - Functions to create a new game
    
    
    /// This function will start a new game, with the 'viewOfGame' as gameManager for the game 'game' variable.
    func startANewGame(animatedFromTheRight: Bool) {
        // 0. Set te colors
        game.colors = ColorSetForOneGame(openColor: colorForRGB(r: 192, g: 197, b: 206) , emptyColor: UIColor.white, strokeColor: colorForRGB(r: 52, g: 61, b: 70), textColor: colorForRGB(r: 52, g: 61, b: 70))
        
        // 1. Kill the last variables of the game
        gameTimer?.stop()
        isTheGameStarted.value = false
        self.numberOfBombs = 0
        
        viewOfGame = getNewViewOfGame()
        
        // Set the properties of the view of game
        viewOfGame!.backgroundColor = UIColor.clear
        viewOfGame!.delegate = self
        viewOfGame!.layer.masksToBounds = false
        viewOfGame!.numberOfRemainingFlags = game.numberOfFlag
        viewOfGame!.onPosingFlag = { (test: Bool) -> Void in
            self.numberOfBombs += test ? 1 : 0
        }
        
        setUpLabelsForNewGame()
        updateFlags(numberOfFlags: game.numberOfFlag)
        removePrecendentViewOfGame()
        addTheBonusChoiceView()
        
        // Set the properties of the scroll view
        setUpScrollView()
        
        // Set the message managor, to be linked to the correct view of game
        messageManagor = MessageManagor(viewOfGame: viewOfGame!, gameTimer: gameTimer, superView: self.view, clockView: self is HistoryGameViewController ? clockView : nil, functionToFinishGame: { (didTapABomb) in
            self.endOfHistoryGame(didTapABomb)
        })
        
        if animatedFromTheRight {
            UIView.animate(withDuration: 0.7) {
                self.viewOfGame?.center.x -= self.view.frame.width
            }
        }
    }
    
    /// This function returns a new view of game, set with the correct type and with the none cases positionned. It still needs to be tapped to position the bombs and finish the gamestate array.
    func getNewViewOfGame() -> ViewOfGame? {
        var vog: ViewOfGame?
        if game.gameType == .square { // read comments to understand.
            createANewSquareGameStepOne()
            vog = SquareViewOfGame(game: game, gameState: &gameState)
            vog!.makeDarkBorderDisplay()
        } else if game.gameType == .hexagonal {
            createANewHexGameStepOne()
            vog = HexViewOfGame(game: game, gameState: &gameState)
        } else if game.gameType == .triangular {
            createNewTriangularGameStepOne()
            vog = TriangleViewOfGame(game: game, gameState: &gameState)
        }
        return vog
    }
    
    private func createANewSquareGameStepOne() {
        gameState = createEmptySquareGameState(n: game.n, m: game.m)
        positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameState)
    }
    
    private func createANewHexGameStepOne() {
        gameState = createEmptyHexGameState(n: game.n, m: game.m)
        positionNoneCaseHex(noneCases: game.noneCasesPosition, gameState: &gameState)
    }
    
    private func createNewTriangularGameStepOne() {
        gameState = createEmptySquareGameState(n: game.n, m: game.m)
        positionNoneCaseSquare(noneCases: game.noneCasesPosition, in: &gameState)
    }
    
    func updateSquareGame(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsSquare(in: &gameState, numberOfBombs: game.z, withFirstTouched: (touch.x,touch.y))
        createNumbersToDisplaySquare(in: &gameState)
        viewOfGame!.gameState = gameState
    }
    
    func updateHexGameState(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsHex(gameState: &gameState, z: game.z, withFirstTouched: (touch.x, touch.y))
        createNumbersToDisplayHex(gameState: &gameState)
        viewOfGame!.gameState = gameState
    }
    
    func updateTriangularGameStepTwo(withFirstTouched touch: (x: Int, y: Int)) {
        positionBombsSquare(in: &gameState, numberOfBombs: game.z, withFirstTouched: (touch.x,touch.y), isTriangular: true)
        createNumbersToDisplayTriangle(in: &gameState)
        viewOfGame!.gameState = gameState
    }
    
}


extension GameViewController: variableCanCallGameVC {
    
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
        gameTimer?.start(timeInterval: 1.0, id: "Clock")
        
    }
    
}

// MARK: - Protocol pour les gameViews (permet de terminer la partie, entre autre)
extension GameViewController: GameController {
    
    func gameOver(win: Bool, didTapABomb: Bool, didTimeEnd: Bool) {
        
        Vibrate().vibrate(style: .heavy)
        
        gameTimer?.pause()
        
        viewOfGame!.isUserInteractionEnabled = false
        viewOfGame!.option3Timer.stop()
        viewOfGame!.pauseAllOption1Timers()
        
        if didTapABomb || didTimeEnd {
            messageManagor?.addTheMessage(didTapABomb: didTapABomb)
        } else {
            
            gameTimer?.stop()
            
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
extension GameViewController: CountingTimerProtocol {
    
    func timerFires(id: String) {
        // In this case, the id does not matter at all.
        // This method is called each second.
        if let gameTimer = gameTimer {
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
    
    
}

// MARK: - Gere les transitions
extension GameViewController: UIViewControllerTransitioningDelegate {
    
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
            
            // Hide the clock view
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.clockView.alpha = 0.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7, animations: {
                self.viewOfGame!.center.x -= self.view.frame.width
                self.viewOfGame?.alpha = 0
            })
            
        }) { (_) in
            
            self.removePrecendentViewOfGame()
            self.startANewGame(animatedFromTheRight: false)
            self.viewOfGame?.alpha = 0.0
            UIView.animate(withDuration: 0.6, animations: {
                self.viewOfGame?.alpha = 1.0
                self.clockView.alpha = 1
            })
            
        }
        
    }
}

// MARK: - POP-OVER : permet de faire apparaitre le bon message à la fin de partie si le joueur tape sur une bombe.

extension GameViewController {
    
    fileprivate func endOfHistoryGame(_ didTapABomb: Bool) {
        self.gameTimer?.stop()
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

extension GameViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.viewOfGame
    }
}

