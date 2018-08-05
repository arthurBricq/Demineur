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
    
    /// OUTLETS hh
    @IBOutlet weak var levelsTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    /// ACTIONS
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
    
    /// VARIABLES
    var totalNumberOfRowsInSection: Int {
        return Int(floor(Double(historyLevels.count/3))+1)
    }
    
    // retourne l'indice
    var currentGameIndex: Int { return gameData.currentLevel }
    
    // retourne le nombre de niveau du chapitre en question.
    var numberOfLevelInSection: Int { return historyLevels.count }
    var color1 = colorForRGB(r: 66, g: 66, b: 66) //UIColor(red: 0, green: 144/255, blue: 81/255, alpha: 1.0)
    var color2 = UIColor.orange
    var selectedGameIndex: Int = 1
    
    
    /// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        levelsTableView.delegate = self
        levelsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    /**
     Cette fonction doit retourner les niveaux des jeux en mode histoire
     */
    func oneGameForGivenIndex(index: Int) -> OneGame {
        if index == 1 {
            return OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 4, totalTime: 60)
        } else if index == 2 {
            return OneGame(gameTypeWithNoOptionsWithoutNoneCases: .hexagonal, n: 16, m: 10, z: 10, totalTime: 60)
        } else if index == 3 {
            return OneGame(gameTypeWithNoOptionsWithoutNoneCases: .triangular, n: 10, m: 11, z: 10, totalTime: 60)
        } else if index == 4 {
            return OneGame(gameTypeWithOption1WithoutNoneCases: .hexagonal, n: 15, m: 10, z: 10, totalTime: 60, option1Time: 10)
        } else if index == 5 {
            return OneGame(gameTypeWithOption2WithoutNoneCases: .square, n: 15, m: 10, z: 10, totalTime: 60, option2Frequency: 0.2)
        } else if index == 6 {
            return OneGame(gameTypeWithOption3WithoutNoneCases: .square, n: 12, m: 11, z: 16, totalTime: 90, option3Time: 5, option3Frequency: 0.7)
        } else if index == 7 {
            return OneGame(hexagonalPyramid7x7GameTime: 60, z: 5)
        } else if index == 8 {
            return OneGame(squareHeart12x13GameTime: 60, z: 8)
        } else if index == 9 {
            return OneGame(triangularButterfly4x7GameTime: 60, z: 4)
        } else {
            return OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 20, totalTime: 90)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
            
        case is HistoryGameViewController:
            let dest = segue.destination as! HistoryGameViewController
            
            // On connait l'indice choisit de la partie et on connait la partie courrant du jeu,
            if selectedGameIndex <= gameData.currentLevel {
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
    
    /// Cette fonction doit modifier le alpha des cellules correctement et cachées les cellules en trop,
    func updateTheCells() {
        print("updating the alphas")
        for i in 1..<totalNumberOfRowsInSection {
            let tmp = tableView.cellForRow(at: IndexPath(row: i, section: 0))
            if tmp is Type1TableViewCell {
                let cell = tmp as! Type1TableViewCell
                cell.updateTheAlphas()
            } else {
                let cell = tmp as! Type2TableViewCell
                cell.updateTheAlphas()
            }
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
            cell.currentGame = currentGameIndex+1
            cell.VC = self
            cell.strokeColor = color1
            cell.tag = 1
            cell.setNeedsDisplay()
            return cell
            
        } else if indexPath.row % 2 == 1  {
            print("type 1 démarre avec : \(3*indexPath.row + 1) et currentGame: \(currentGameIndex+1)" )
            let cell = tableView.dequeueReusableCell(withIdentifier: "Type1Cell", for: indexPath) as! Type1TableViewCell
            cell.firstGameOfRow = 3*indexPath.row + 1
            cell.tag = currentGameIndex+1
            cell.currentGame = currentGameIndex+1
            cell.VC = self
            let firstGameOfRow = 3*indexPath.row + 1
            cell.button1.setTitle(String(firstGameOfRow), for: .normal)
            cell.button2.setTitle(String(firstGameOfRow+1), for: .normal)
            cell.button3.setTitle(String(firstGameOfRow+2), for: .normal)
            cell.strokeColor = color1
            cell.secondStrokeColor = color1
            cell.setNeedsDisplay()
            return cell
            
        } else {
            print("type 2 démarre avec : \(3*indexPath.row + 1) et currentGame: \(currentGameIndex+1)")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Type2Cell", for: indexPath) as! Type2TableViewCell
            cell.firstGameOfRow = 3*indexPath.row + 1
            cell.tag = currentGameIndex+1
            cell.currentGame = currentGameIndex+1
            cell.VC = self
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

extension HistoryPresentationViewController: RoundButtonsCanCallVC {
    
    /**
    Cette fonction est appelée quand il faut initier un niveau.
    */
    func buttonTapped(withIndex: Int) {
        selectedGameIndex = withIndex-1
        self.performSegue(withIdentifier: "StartingGame", sender: nil)
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
