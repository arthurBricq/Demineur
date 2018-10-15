//
//  SuperPartiesPresentationViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 03/09/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class SuperPartiesPresentationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    override var prefersStatusBarHidden: Bool { return true }
    var currentLevelReached: (square: Int, hex: Int, triangle: Int) = (1,0,0)
    var selectedGame: (level: Int,gameType: GameType)?
    
    // MARK: - Actions
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Settings up the lines display
        line1.backgroundColor = colorForRGB(r: 66, g: 66, b: 66)
        line2.backgroundColor = colorForRGB(r: 66, g: 66, b: 66)
        line3.backgroundColor = colorForRGB(r: 66, g: 66, b: 66)
        line4.backgroundColor = colorForRGB(r: 66, g: 66, b: 66)
        
        // Settings of the tableView
        tableView.layer.zPosition = -1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SuperPartiesGameViewController {
            let dest = segue.destination as! SuperPartiesGameViewController
            // Give the correct game to the destination
            let numberOfBombs: Int = (selectedGame!.level+1)*100
            let ratio: CGFloat = 0.3 // % of bombs: ratio = z / (n*m) = z / (n^2)
            let n: Int = Int(sqrt(Double(numberOfBombs)/Double(ratio)))
            dest.game = OneGame(gameTypeWithNoOptionsWithoutNoneCases: selectedGame!.gameType, n: n, m: n, z: numberOfBombs, totalTime: 1000)
        }
    }
}

// MARK: - Gestion du tableView
extension SuperPartiesPresentationViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuperPartieCell", for: indexPath) as! SuperPartiesTableViewCell
        
        cell.squareButton.cornersToDraw = [1,2,3,4,5,6,7,8]
        cell.squareButton.openColor = .white
        cell.squareButton.strokeColor = .black
        cell.squareButton.ratio = 2
        
        cell.hexButton.openColor = .white
        cell.hexButton.strokeColor = .black
    
        cell.triangularButton.openColor = .white
        cell.triangularButton.strokeColor = .black
        
        cell.numberDisplay.color = UIColor(red: 0.720, green: 0.469, blue: 0.000, alpha: 1.000)
        cell.numberDisplay.text = String(100*indexPath.row + 100)
        
        cell.level = indexPath.row
        cell.currentLevelReached = currentLevelReached
        
        cell.isUserInteractionEnabled = true
        
        cell.updateTheAlphas()
        cell.updateTheLines()
        cell.setNeedsDisplay()
        
        cell.closureToStartGame = { (levelTapped: Int,gameTypeTapped: GameType) -> Void in
            self.selectedGame = (level: levelTapped, gameType: gameTypeTapped)
            self.performSegue(withIdentifier: "StartSuperPartieSegue", sender: nil)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let maxLevel = max(currentLevelReached.square, currentLevelReached.hex, currentLevelReached.triangle)
        return maxLevel+2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
