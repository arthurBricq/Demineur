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
    
    var totalNumberOfRowsInSection: Int {
        return Int(floor(Double(historyLevels.count/3))+1)
    }
    
    // retourne le nombre de niveau du chapitre en question.
    var numberOfLevelInSection: Int { return historyLevels.count }
    
    var color1 = colorForRGB(r: 66, g: 66, b: 66)
    var color2 = UIColor.orange
    
//    var selectedGameIndex: Int = 1
    
    // MARK: - ACTIONS
    @IBAction func MenuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToHistoryPresentation(segue: UIStoryboardSegue) {
        // retour aux niveaux
    }
    
    /// fonction appelée lorsque le unwind est fait
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
    
    /// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        levelsTableView.delegate = self
        levelsTableView.dataSource = self
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalNumberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StartCell", for: indexPath) as! StartTableViewCell
            cell.currentGame = dataManager.currentHistoryLevel+1
            cell.buttonTappedClosure = { (index) -> Void in
                self.performSegue(withIdentifier: "StartingGame", sender: index-1)
            }
            cell.strokeColor = color1
            cell.tag = 1
            cell.setNeedsDisplay()
            return cell
        } else if indexPath.row % 2 == 1  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Type1Cell", for: indexPath) as! Type1TableViewCell
            cell.firstGameOfRow = 3*indexPath.row + 1
            cell.tag = dataManager.currentHistoryLevel+1
            cell.currentGame = dataManager.currentHistoryLevel+1
            cell.buttonTappedClosure = { (index) -> Void in
                self.performSegue(withIdentifier: "StartingGame", sender: index-1)
            }
            let firstGameOfRow = 3*indexPath.row + 1
            cell.button1.setTitle(String(firstGameOfRow), for: .normal)
            cell.button2.setTitle(String(firstGameOfRow+1), for: .normal)
            cell.button3.setTitle(String(firstGameOfRow+2), for: .normal)
            cell.strokeColor = color1
            cell.secondStrokeColor = color1
            cell.setNeedsDisplay()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Type2Cell", for: indexPath) as! Type2TableViewCell
            cell.firstGameOfRow = 3*indexPath.row + 1
            cell.tag = dataManager.currentHistoryLevel+1
            cell.currentGame = dataManager.currentHistoryLevel+1
            cell.buttonTappedClosure = { (index) -> Void in
                self.performSegue(withIdentifier: "StartingGame", sender: index-1)
            }
            let firstGameOfRow = 3*indexPath.row + 1
            cell.button1.setTitle(String(firstGameOfRow), for: .normal)
            cell.button2.setTitle(String(firstGameOfRow+1), for: .normal)
            cell.button3.setTitle(String(firstGameOfRow+2), for: .normal)
            cell.strokeColor = color1
            cell.secondStrokeColor = color1
            cell.setNeedsDisplay()
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
