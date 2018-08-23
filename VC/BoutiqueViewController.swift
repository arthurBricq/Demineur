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

    // MARK: - VARIABLES
    override var prefersStatusBarHidden: Bool { return true }
    var selectedButtonIndex: Int = 0 // 0 for bonus, 1 for pieces, 2 for colors
    let identifiersOfCells: [String] = ["BonusBoutiqueCell","PieceBoutiqueCell","ThemeBoutiqueCell"]
    
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var bonusButton: UIButton!
    @IBOutlet weak var piecesButton: UIButton!
    @IBOutlet weak var colorsButtons: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var pieceView: PieceView!
    
    
    
    
    
    // MARK: - ACTIONS
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
    
    
    
    // MARK: - Other functions
    
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


// MARK: - Gère la TableView
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
        case 2:
            return allThemes.count
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
            
            cell.delegate = self
            let currentBonus = allBonus[indexPath.row]
            let level = levelOfBonus.giveTheLevelOfBonus(forIndex: indexPath.row)
            let number = bonus.giveTheNumberOfBonus(forIndex: indexPath.row)
            
            cell.label1.text = currentBonus.descriptions[level]
            cell.bonusView.index = indexPath.row
            cell.bonusView.tempsAngleParameter = -185
            cell.bonusView.setNeedsDisplay()
            cell.achatButton.prix = String(currentBonus.prixAchat)
            cell.levelLabel.text = String(level+1)
            cell.numberLabel.text = String(number)
            cell.itemLabel.text = number == 0 ? "item" : "items"
            cell.index = indexPath.row
            
            if level == currentBonus.niveauMax { // dernier niveau atteint
                cell.label2.text = "NIVEAU MAXIMUM"
                cell.AmeliorerButton.alpha = 0
                cell.AmeliorerButton.isUserInteractionEnabled = false
            } else {
                cell.label2.text = currentBonus.descriptionsAmeliorations[level]
                cell.AmeliorerButton.prix = String(currentBonus.prixAmelioration[level])
                
                if money.currentAmountOfMoney < currentBonus.prixAmelioration[level] { // Pas assez d'argent pour améliorer.
                    UIView.animate(withDuration: 0.2, animations: { cell.AmeliorerButton.alpha = 0.5 })
                    cell.AmeliorerButton.isUserInteractionEnabled = false
                } else {
                    cell.AmeliorerButton.alpha = 1.0
                    cell.AmeliorerButton.isUserInteractionEnabled = true
                }
            }
            cell.AmeliorerButton.setNeedsDisplay()
            
            if money.currentAmountOfMoney < currentBonus.prixAchat { // Pas assez d'argent pour acheter.
                UIView.animate(withDuration: 0.2, animations: { cell.achatButton.alpha = 0.5 })
                cell.achatButton.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.2, animations: { cell.AmeliorerButton.alpha = 0.5 })
                cell.AmeliorerButton.isUserInteractionEnabled = false
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieceBoutiqueCell", for: indexPath) as! PieceBoutiqueTableViewCell
            cell.delegate = self
            
            let currentPack = allPacks[indexPath.row]
            
            cell.moneyPackView.size = currentPack.size
            cell.moneyPackView.setNeedsDisplay()
            cell.descriptionLabel.text = currentPack.description
            cell.prixButton.text = "\(currentPack.prix.description)€"
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeBoutiqueCell", for: indexPath) as! ThemeBoutiqueTableViewCell
            cell.delegate = self
            
            let currentTheme = allThemes[indexPath.row]
            
            cell.index = indexPath.row
            
            cell.mainView.layer.cornerRadius = 10
            cell.mainView.layer.borderWidth = 2
            cell.mainView.layer.borderColor = colorForRGB(r: 20, g: 20, b: 20).cgColor
            cell.mainView.backgroundColor = currentTheme.colors[0]
            
            cell.lineView.strokeColor = currentTheme.colors[1]
            cell.lineView.backgroundColor = UIColor.clear
            cell.lineView.setNeedsDisplay()
            
            cell.titleView.textColor = currentTheme.colors[2]
            cell.titleView.text = currentTheme.name
            
            cell.buyButton.prix = currentTheme.price.description
            cell.buyButton.isHidden = themesManager.indexesOfUnlockedThemes.contains(indexPath.row)
            
            cell.buyButton.textsize = 55
            if money.currentAmountOfMoney < currentTheme.price {
                cell.buyButton.isUserInteractionEnabled = false
                cell.buyButton.alpha = 0.5
            } else {
                cell.buyButton.isUserInteractionEnabled = true
                cell.buyButton.alpha = 1
            }
            cell.buyButton.setNeedsDisplay()
            
            cell.hidingView.isHidden = themesManager.indexesOfUnlockedThemes.contains(indexPath.row)
            cell.hidingView.layer.cornerRadius = 10
            cell.hidingView.layer.borderWidth = 2
            
            cell.lockView.progress = themesManager.indexesOfUnlockedThemes.contains(indexPath.row) ? 0 : 1
            
            cell.checkerButton.isChecked = (themesManager.indexOfSelectedTheme == indexPath.row)
            
            cell.checkerButton.setNeedsDisplay()
            
            
            return cell
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "BonusBoutiqueCell", for: indexPath)
        }
        
        
        
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch selectedButtonIndex {
        case 0:
            return 140
        case 1:
            return 100
        case 2:
            return 160
        default:
            return 100
        }
    }
}


// MARK: - Extension pour recharger les données de la page après un changement dans une cellule
extension BoutiqueViewController: CellCanCallTableViewController {
    
    func reloadMoney() {
        updateDisplay()
        pieceView.playParticleAnimation()
    }
    
    
    func reloadDatas() {
        updateDisplay()
        tableView.reloadData()
    }
    
}
