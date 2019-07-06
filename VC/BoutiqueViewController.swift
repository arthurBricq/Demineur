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
    @IBOutlet weak var mainLine: LineView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var boutiqueLabel: UILabel!
    
    
    
    
    
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
        
        setColors()
    }

    
    func updateDisplay() {
        moneyLabel.text = String(dataManager.money)
    }
    
    private func setColors() {
        self.view.backgroundColor = Color.getColor(index: 0)
        
        mainLine.strokeColor = Color.getColor(index: 1)
        mainLine.setNeedsDisplay()
        boutiqueLabel.textColor = Color.getColor(index: 2)
        boutiqueLabel.setNeedsDisplay()
        moneyLabel.textColor = Color.getColor(index: 3)
        moneyLabel.setNeedsDisplay()
        
        menuButton.setTitleColor(Color.getColor(index: 3), for: .normal)
        bonusButton.setTitleColor(Color.getColor(index: 3), for: .normal)
        piecesButton.setTitleColor(Color.getColor(index: 3), for: .normal)
        colorsButtons.setTitleColor(Color.getColor(index: 3), for: .normal)
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = .clear
    }
    
    /// This function changes the color of the view with an animation, has to be used when the color theme is changed
    func animateColorChange() {
        
        let timeOfAnimation: TimeInterval = 1.0
        
        // this will change the color of the animation when the animation has done 45% of its complete time, and the elements disappear when it's
        // at 40%, and thus, the change isn't visible
        delay(seconds: 0.45*timeOfAnimation) {
            self.mainLine.strokeColor = Color.getColor(index: 1)
            self.boutiqueLabel.textColor = Color.getColor(index: 2)
            self.moneyLabel.textColor = Color.getColor(index: 3)
            self.mainLine.setNeedsDisplay()
            self.boutiqueLabel.setNeedsDisplay()
            self.moneyLabel.setNeedsDisplay()
            
            self.menuButton.setTitleColor(Color.getColor(index: 3), for: .normal)
            self.bonusButton.setTitleColor(Color.getColor(index: 3), for: .normal)
            self.piecesButton.setTitleColor(Color.getColor(index: 3), for: .normal)
            self.colorsButtons.setTitleColor(Color.getColor(index: 3), for: .normal)
        }
        
        UIView.animateKeyframes(withDuration: timeOfAnimation, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                for subview in self.view.subviews {
                    subview.alpha = 0
                }
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2, animations: {
                self.view.backgroundColor = Color.getColor(index: 0)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                for subview in self.view.subviews {
                    subview.alpha = 1
                }
            })
            
        })
        
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
            return Color.allThemes.count
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
            let level = dataManager.levelOfBonus(atIndex:  indexPath.row)
            let number = dataManager.levelOfBonus(atIndex: indexPath.row)
            
            cell.label1.text = currentBonus.descriptions[level]
            cell.label1.textColor = Color.getColor(index: 2)
            cell.label2.textColor = Color.getColor(index: 2)
            cell.bonusView.index = indexPath.row
            cell.bonusView.tempsAngleParameter = -185
            cell.bonusView.setNeedsDisplay()
            cell.achatButton.prix = String(currentBonus.prixAchat)
            cell.levelLabel.text = String(level+1)
            cell.levelLabel.textColor = Color.getColor(index: 3)
            cell.textLevelLabel.textColor = Color.getColor(index: 3)
            cell.buyLabel.textColor = Color.getColor(index: 2)
            cell.upgradeLabel.textColor = Color.getColor(index: 2)
            cell.numberLabel.text = String(number)
            cell.numberLabel.textColor = Color.getColor(index: 3)
            cell.itemLabel.text = number == 0 ? "item" : "items"
            cell.itemLabel.textColor = Color.getColor(index: 3)

            cell.index = indexPath.row
            cell.backgroundColor = .clear
            
            if level == currentBonus.niveauMax { // dernier niveau atteint
                cell.label2.text = "NIVEAU MAXIMUM"
                cell.AmeliorerButton.alpha = 0
                cell.AmeliorerButton.isUserInteractionEnabled = false
            } else {
                cell.label2.text = currentBonus.descriptionsAmeliorations[level]
                cell.AmeliorerButton.prix = String(currentBonus.prixAmelioration[level])
                
                if dataManager.money < currentBonus.prixAmelioration[level] { // Pas assez d'argent pour améliorer.
                    UIView.animate(withDuration: 0.2, animations: { cell.AmeliorerButton.alpha = 0.5 })
                    cell.AmeliorerButton.isUserInteractionEnabled = false
                } else {
                    cell.AmeliorerButton.alpha = 1.0
                    cell.AmeliorerButton.isUserInteractionEnabled = true
                }
            }
            cell.AmeliorerButton.setNeedsDisplay()
            
            if dataManager.money < currentBonus.prixAchat { // Pas assez d'argent pour acheter.
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
            cell.backgroundColor = .clear
            cell.moneyPackView.size = currentPack.size
            cell.moneyPackView.setNeedsDisplay()
            cell.descriptionLabel.text = currentPack.description
            cell.descriptionLabel.textColor = Color.getColor(index: 3)
            cell.prixButton.text = "\(currentPack.prix.description)€"
            cell.prixButton.setNeedsDisplay()
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeBoutiqueCell", for: indexPath) as! ThemeBoutiqueTableViewCell
            cell.delegate = self
            
            let currentTheme = Color.allThemes[indexPath.row]
            
            cell.backgroundColor = .clear
            
            cell.index = indexPath.row
            
            cell.mainView.layer.cornerRadius = 10
            cell.mainView.layer.borderWidth = 4
            cell.mainView.layer.borderColor = Color.rgb(20, 20, 20).cgColor
            cell.mainView.backgroundColor = currentTheme.colors[0]
            
            cell.lineView.strokeColor = currentTheme.colors[1]
            cell.lineView.backgroundColor = UIColor.clear
            cell.lineView.setNeedsDisplay()
            
            cell.titleView.textColor = currentTheme.colors[2]
            cell.titleView.text = currentTheme.name
            
            cell.buyButton.prix = currentTheme.price.description
            cell.buyButton.isHidden = dataManager.unlockedThemes.contains(indexPath.row)
            
            cell.buyButton.textsize = 55
            if dataManager.money < currentTheme.price {
                cell.buyButton.isUserInteractionEnabled = false
                cell.buyButton.alpha = 0.5
            } else {
                cell.buyButton.isUserInteractionEnabled = true
                cell.buyButton.alpha = 1
            }
            cell.buyButton.setNeedsDisplay()
            
            cell.hidingView.isHidden = dataManager.unlockedThemes.contains(indexPath.row)
            cell.hidingView.layer.cornerRadius = 10
            cell.hidingView.layer.borderWidth = 2
            
            cell.lockView.progress = dataManager.unlockedThemes.contains(indexPath.row) ? 0 : 1
            
            cell.checkerButton.isChecked = (dataManager.currentTheme == indexPath.row)
            
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
