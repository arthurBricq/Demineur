//
//  BonusBoutiqueTableViewCell.swift
//  Demineur
//
//  Created by Arthur BRICQ on 08/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class BonusBoutiqueTableViewCell: UITableViewCell {

    // MARK: - VARIABLES
    var index: Int = 0 // indice du bonus représenté
    var delegate: CellCanCallTableViewController?

    // MARK: - OUTLETS

    /// description du niveau actuel. 
    @IBOutlet weak var label1: UILabel!
    /// description de l'amélioration à faire.
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var textLevelLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var bonusView: BonusView!
    @IBOutlet weak var achatButton: AchatBoutiqueBouton!
    @IBOutlet weak var AmeliorerButton: AchatBoutiqueBouton!
    
    
    // MARK: - FUNCTIONS & ACTIONS
    
    // REMARQUE : on est certain que lorsque l'utilisateur tappe sur ces bouttons il a assez d'argent, car les boutons ne seraient pas disponibles sinon.
    @IBAction func achatButtonTapped(_ sender: Any) {
        
        dataManager.money -= allBonus[index].prixAchat
        
        switch index {
        case 0:
            dataManager.tempsQuantity += 1
        case 1:
            dataManager.drapeauQuantity += 1
        case 2:
            dataManager.bombeQuantity += 1
        case 3:
            dataManager.verificationQuantity += 1
        case 4:
            var amount = 1
            if dataManager.levelOfBonus(atIndex:  4) == 1 {
                amount = 2
            } else if dataManager.levelOfBonus(atIndex:  4) == 2 {
                amount = 3
            }
            dataManager.vieQuantity += amount
        default:
            break
        }
        
        delegate?.reloadDatas()
        delegate?.reloadMoney()
        
    }
    
    @IBAction func ameliorerButtonTapped(_ sender: Any) {
        
        dataManager.money -= allBonus[self.index].prixAmelioration[dataManager.levelOfBonus(atIndex:  self.index)]
        self.delegate?.reloadMoney()
        
        let arrow = SkillUpArrowView()
        arrow.backgroundColor = UIColor.clear
        let arrowWidth: CGFloat = 30
        let arrowHeight: CGFloat = 7/5*arrowWidth
        let arrowOrigin = CGPoint(x: bonusView.frame.maxX - arrowWidth/2, y: bonusView.frame.minY + arrowHeight/2)
        
        arrow.frame = CGRect(origin: arrowOrigin, size: CGSize(width: arrowWidth, height: 0))
        self.addSubview(arrow)
        
        switch index {
        case 0:
            dataManager.tempsLevel += 1
        case 1:
            dataManager.drapeauLevel += 1
        case 2:
            dataManager.bombeLevel += 1
        case 3:
            dataManager.verificationLevel += 1
        case 4:
            dataManager.vieLevel += 1
        default:
            break
        }
        
        levelLabel.text = String(dataManager.levelOfBonus(atIndex:  index))

        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            arrow.frame = CGRect(x: arrowOrigin.x, y: arrowOrigin.y  - arrowHeight, width: arrowWidth, height: arrowHeight)
        }) { (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                arrow.alpha = 0
            }, completion: { (_) in
                arrow.removeFromSuperview()
                self.delegate?.reloadDatas()
            })
        }
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
