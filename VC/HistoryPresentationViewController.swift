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
    
    @IBOutlet weak var levelsTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - VARIABLES
    
    var color1 = colorForRGB(r: 66, g: 66, b: 66)
    var color2 = UIColor.orange
    
    // MARK: - ACTIONS
    
    @IBAction func MenuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToHistoryPresentation(segue: UIStoryboardSegue) {
        // retour aux niveaux
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelsTableView.delegate = self
        levelsTableView.dataSource = self
        dataManager.currentHistoryLevel = 5
        addHistoryLabel()
    }

    /// This function adds the label with 'HISTORY' writen on it to the tableview, so that is scrolls with the cells.
    private func addHistoryLabel() {
        let w = self.view.frame.width
        let h = self.view.frame.height
        let lbl = UILabel(frame: CGRect(x: w/2 + 50, y: 40, width: 20, height: 300))
        lbl.text = "HISTORY"
        lbl.font = UIFont(name: "PingFangSC-Light", size: 25)
        lbl.textColor = UIColor.gray
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        self.levelsTableView.addSubview(lbl)
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
        
}

extension HistoryPresentationViewController:UITableViewDataSource, UITableViewDelegate
{
    /*
     NOTE ABOUT THIS TABLE VIEW
     The rows of this table view present the level.
     Just note that the first row is left blank in order to draw the initial line there.
     The other rows present levels one by one, with a line that will go around the finished levels.
    */
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // All the levels, plus the first row where the line will be drawn
        return historyLevels.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryPresentationCell
        if indexPath.row == 0 {
            cell.disableAndHideButton()
        } else {
            // Set the cell as required here
            let gameIndex = indexPath.row-1
            if gameIndex == dataManager.currentHistoryLevel {
                cell.setCell(displayedLevel: gameIndex+1, cellState: .reached)
            } else {
                cell.setCell(displayedLevel: gameIndex+1, cellState: gameIndex < dataManager.currentHistoryLevel ? .completed : .notReachedYet)
            }
            cell.buttonTappedClosure = {
                self.performSegue(withIdentifier: "StartingGame", sender: gameIndex)
            }
        }
        cell.clipsToBounds = false 
        cell.setNeedsDisplay()
        cell.levelButton.setNeedsDisplay()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 100 : 80
    }
    
    
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
