//
//  BoutiqueViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 08/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/// Cette classe présente la boutique. Il y a trois bouttons qui permettent de changer le contenu de la boutique : bonus, les pièces, et les couleurs. Le contenu de la boutique se trouve dans une tableView en dessous de ces bouttons. 
class BoutiqueViewController: UIViewController {

    /// VARIABLES
    override var prefersStatusBarHidden: Bool { return true }
    var selectedButtonIndex: Int = 0 // 0 for bonus, 1 for pieces, 2 for colors
    let identifiersOfCells: [String] = ["BonusBoutiqueCell","PieceBoutiqueCell","ColorsBoutiqueCell"]
    
    
    
    /// OUTLETS
    @IBOutlet weak var bonusButton: UIButton!
    @IBOutlet weak var piecesButton: UIButton!
    @IBOutlet weak var colorsButtons: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyLabel: UILabel!
    
    
    
    
    
    /// ACTIONS
    @IBAction func bonusButtonTapped(_ sender: Any) {
        bonusButton.alpha = 1.0
        piecesButton.alpha = 0.6
        colorsButtons.alpha = 0.6
        bonusButton.isUserInteractionEnabled = false
        piecesButton.isUserInteractionEnabled = true
        colorsButtons.isUserInteractionEnabled = true
        selectedButtonIndex = 0
        tableView.reloadData()
    }
    
    @IBAction func piecesButtonTapped(_ sender: Any) {
        bonusButton.alpha = 0.6
        piecesButton.alpha = 1.0
        colorsButtons.alpha = 0.6
        bonusButton.isUserInteractionEnabled = true
        piecesButton.isUserInteractionEnabled = false
        colorsButtons.isUserInteractionEnabled = true
        selectedButtonIndex = 1
        tableView.reloadData()
    }
    
    @IBAction func colorsButtonTapped(_ sender: Any) {
        bonusButton.alpha = 0.6
        piecesButton.alpha = 0.6
        colorsButtons.alpha = 1.0
        bonusButton.isUserInteractionEnabled = true
        piecesButton.isUserInteractionEnabled = true
        colorsButtons.isUserInteractionEnabled = false
        selectedButtonIndex = 2
        tableView.reloadData()
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /// FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bonusButton.alpha = 1.0
        piecesButton.alpha = 0.6
        colorsButtons.alpha = 0.6
        bonusButton.isUserInteractionEnabled = false
        piecesButton.isUserInteractionEnabled = true
        colorsButtons.isUserInteractionEnabled = true
        selectedButtonIndex = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        
        updateDisplay() 
    }

    
    func updateDisplay() {
        moneyLabel.text = String(money.currentAmountOfMoney)
    }
    
    
}

extension BoutiqueViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch selectedButtonIndex {
        case 0:
            return allBonus.count
        case 1:
            return allPacks.count
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch selectedButtonIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BonusBoutiqueCell", for: indexPath) as! BonusBoutiqueTableViewCell
            /// ATTENTION : les cellules sont responsables elles-mêmes des actions lorsque l'on les tappes.
            
            let currentBonus = allBonus[indexPath.row]
            let level = levelOfBonus.giveTheLevelOfBonus(forIndex: indexPath.row)
            let number = bonus.giveTheNumberOfBonus(forIndex: indexPath.row)
            
            cell.label1.text = currentBonus.descriptions[level]
            cell.bonusView.index = indexPath.row
            cell.achatButton.prix = String(currentBonus.prixAchat)
            cell.levelLabel.text = String(level+1)
            cell.numberLabel.text = String(number)
            cell.itemLabel.text = number == 0 ? "item" : "items"
            cell.index = indexPath.row
            
            if currentBonus.niveau == currentBonus.descriptions.count { // dernier niveau atteint
                cell.label2.text = ""
                cell.AmeliorerButton.alpha = 0.5
                cell.AmeliorerButton.prix = ""
                cell.AmeliorerButton.isUserInteractionEnabled = false
            } else {
                cell.label2.text = currentBonus.descriptionsAmeliorations[currentBonus.niveau]
                cell.AmeliorerButton.prix = String(currentBonus.prixAmelioration[currentBonus.niveau])
                cell.AmeliorerButton.alpha = 1.0
                cell.AmeliorerButton.isUserInteractionEnabled = true
            }
            
            if money.currentAmountOfMoney < currentBonus.prixAchat { // Pas assez d'argent pour acheter.
                cell.achatButton.alpha = 0.5
                cell.achatButton.isUserInteractionEnabled = false
                cell.AmeliorerButton.alpha = 0.5
                cell.AmeliorerButton.isUserInteractionEnabled = false
            } else if money.currentAmountOfMoney < currentBonus.prixAmelioration[level] { // Pas assez d'argent pour améliorer.
                cell.AmeliorerButton.alpha = 0.5
                cell.AmeliorerButton.isUserInteractionEnabled = false
            }
            
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieceBoutiqueCell", for: indexPath) as! PieceBoutiqueTableViewCell
            let currentPack = allPacks[indexPath.row]
            
            cell.moneyPackView.size = currentPack.size
            cell.moneyPackView.setNeedsDisplay()
            cell.descriptionLabel.text = currentPack.description
            cell.prixButton.setTitle(currentPack.prix.description, for: .normal)
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
            return cell
        }
        
        
        
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch selectedButtonIndex {
        case 0:
            return 140
        case 1:
            return 100
        default:
            return 100

        }
    }
}
