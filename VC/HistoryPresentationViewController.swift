//
//  HistoryPresentationViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 07/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/* ATTENTION : il y a deux choses à ne pas confondre
1) currentGame
2) currentGameIndex

 
 Liaison : l'indice a une unité de moins que le niveau courant, qui lui est exprimé de façon purement logique en partant de 1.
 
*/
class HistoryPresentationViewController: UIViewController  {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - VARIABLES
    
    var color1 = colorForRGB(r: 66, g: 66, b: 66)
    var color2 = UIColor.orange
    var rows: [HistoryPresentationCell] = []
    
    // MARK: - Constants
    let heigthOfRow: CGFloat = 100
    
    // MARK: - ACTIONS
    
    @IBAction func MenuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToHistoryPresentation(segue: UIStoryboardSegue) {
        // retour aux niveaux
    }
   
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.currentHistoryLevel = 5
        fillScrollView()
        setUpScrollView()
        self.view.bringSubviewToFront(menuButton)
        addHistoryLabel()
        // To be called when the view is presented
        animateCells(index: 0)
    }
    
    /// This method will add all the cells to the scroll view, and add them one by one.
    private func fillScrollView() {
        let numberOfRows = historyLevels.count + 1
        let w = self.view.frame.width
        
        var yPosition: CGFloat = 0.0
        for i in 0..<numberOfRows {
            let h: CGFloat = i == 0 ? 150.0 : heigthOfRow
            let cell = HistoryPresentationCell(frame: CGRect(x: 0, y: yPosition, width: w, height: h))
            yPosition += i == 0 ? 150.0 : heigthOfRow
            if i == 0 {
                cell.setFirstRowCell(delegate: self)
            } else {
                let gameIndex = i-1
                cell.buttonTappedClosure = {
                    self.performSegue(withIdentifier: "StartingGame", sender: gameIndex)
                }
                if gameIndex == dataManager.currentHistoryLevel {
                    cell.setCell(displayedLevel: gameIndex+1, cellState: .reached, delegate: self)
                } else {
                    cell.setCell(displayedLevel: gameIndex+1, cellState: gameIndex < dataManager.currentHistoryLevel ? .completed : .notReachedYet, delegate: self)
                }
                
            }
            scrollView.addSubview(cell)
            rows.append(cell)
        }
    }
    
    private func setUpScrollView() {
        let numberOfLevels = historyLevels.count
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(numberOfLevels)*heigthOfRow + 150)
    }
    
    /// Call this method when you want to have the animation. 
    private func animateCells(index: Int ) {
        if index == 0 {
            self.menuButton.alpha = 0.5
            self.menuButton.isEnabled = false
        }
        if index < rows.count {
            rows[index].animateLine()
        }
        
    }
    
    /// This function adds the label with 'HISTORY' writen on it to the tableview, so that is scrolls with the cells.
    private func addHistoryLabel() {
        let w = self.view.frame.width
        let lbl = UILabel(frame: CGRect(x: w/2 + 50, y: 55, width: 20, height: 300))
        lbl.text = "HISTORY"
        lbl.font = UIFont(name: "PingFangSC-Light", size: 25)
        lbl.textColor = UIColor.gray
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        // TODO: add the label
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
            
        case is HistoryGameViewController:
            
            let dest = segue.destination as! HistoryGameViewController
            // On connait l'indice choisit de la partie et on connait la partie courrant du jeu,
            let selectedGameIndex = sender as! Int
            
            if selectedGameIndex <= dataManager.currentHistoryLevel {
                dest.game = historyLevels[selectedGameIndex]
                dest.gameIndex = selectedGameIndex
            } else {
                dest.game = historyLevels[0]
            }
            
            dest.transitioningDelegate = self
            
        default:
            break
        }
    }
    
    
    /// fonction appelée lorsque le unwind est fait
    /*
     override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
     tableView.reloadData()
     
     return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController) {
     let fromView = fromViewController.view!
     let toView = toViewController.view!
     if let containerView = fromView.superview {
     toView.frame = fromView.frame
     toView.alpha = 0
     containerView.addSubview(toView)
     
     UIView.animate(withDuration: 1, animations: {
     toView.alpha = 1
     }, completion: { (_) in
     toView.removeFromSuperview()
     self.dismiss(animated: false, completion: nil)
     })
     }
     }
     }
     */
        
}

// Animations of transition
extension HistoryPresentationViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented is HistoryGameViewController {
            let transition = TransitionToGameView()
            transition.animationDuration = 1.5
            return transition
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is HistoryGameViewController {
            let transition = TransitionToGameView()
            transition.animationDuration = 1.5
            return transition
        }
        
        return nil
    }
}

// MARK: - Functions for animation gestion of cells
extension HistoryPresentationViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // 1. Obtain the data sent by the cells
        if let cellNumber = anim.value(forKey: "cellNumber") as? Int  {
            if let isFinished = anim.value(forKey: "isFinished") as? Bool {
                if !isFinished {
                    self.animateCells(index: cellNumber + 1 )
                } else {
                    self.menuButton.alpha = 1.0
                    self.menuButton.isEnabled = true
                }
            }
        }
    }
}
