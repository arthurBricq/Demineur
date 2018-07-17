//
//  HistoryPresentationViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 07/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class HistoryPresentationViewController: UIViewController  {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    /// OUTLETS hh
    @IBOutlet weak var levelsTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    
    /// ACTIONS
    @IBAction func MenuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// VARIABLES
    var totalNumberOfRowsInSection: Int = 5 // nombre de lignes à a
    var currentGame: Int = 11
    var color1 = colorForRGB(r: 66, g: 66, b: 66) //UIColor(red: 0, green: 144/255, blue: 81/255, alpha: 1.0)
    var color2 = UIColor.orange
    var selectedGameIndex: Int = 1
    
    
    /// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        levelsTableView.delegate = self
        levelsTableView.dataSource = self
    }
    
    /**
     Cette fonction doit retourner les niveaux
     */
    func oneGameForGivenIndex(index: Int) -> OneGame {
        if index == 1 {
            return OneGame(gameTypeWithNoOptionsWithoutNoneCases: .square, n: 13, m: 10, z: 14, totalTime: 60)
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
            return OneGame(squareYingYang15x15GameTime: 60, z: 10)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is HistoryGameViewController:
            let dest = segue.destination as! HistoryGameViewController
            dest.game = oneGameForGivenIndex(index: selectedGameIndex)
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
            cell.currentGame = currentGame
            cell.VC = self
            cell.strokeColor = color1
            cell.updateTheAlphas()
            print("Cell height = \(cell.frame.height)")
            return cell
            
        } else if indexPath.row % 2 == 1  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Type1Cell", for: indexPath) as! Type1TableViewCell
            cell.firstGameOfRow = 3*indexPath.row + 1
            cell.currentGame = currentGame
            cell.VC = self
            cell.updateTheAlphas()
            let firstGameOfRow = 3*indexPath.row + 1
            cell.button1.setTitle(String(firstGameOfRow), for: .normal)
            cell.button2.setTitle(String(firstGameOfRow+1), for: .normal)
            cell.button3.setTitle(String(firstGameOfRow+2), for: .normal)
            cell.strokeColor = color1
            cell.secondStrokeColor = color1
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Type2Cell", for: indexPath) as! Type2TableViewCell
            cell.firstGameOfRow = 3*indexPath.row + 1
            cell.currentGame = currentGame
            cell.VC = self
            cell.updateTheAlphas()
            let firstGameOfRow = 3*indexPath.row + 1
            cell.button1.setTitle(String(firstGameOfRow), for: .normal)
            cell.button2.setTitle(String(firstGameOfRow+1), for: .normal)
            cell.button3.setTitle(String(firstGameOfRow+2), for: .normal)
            cell.strokeColor = color1
            cell.secondStrokeColor = color1
            return cell
            
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
}

extension HistoryPresentationViewController: RoundButtonsCanCallVC {
    
    func buttonTapped(withIndex: Int) {
        print("le boutton a été tapé \(withIndex)")
        selectedGameIndex = withIndex
        self.performSegue(withIdentifier: "StartingGame", sender: nil)
    }
    
}
