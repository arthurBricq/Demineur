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
    @IBOutlet weak var bonusView: BonusView!
    @IBOutlet weak var achatButton: AchatBoutiqueBouton!
    @IBOutlet weak var AmeliorerButton: AchatBoutiqueBouton!
    
    
    // MARK: - FUNCTIONS & ACTIONS
    
    // REMARQUE : on est certain que lorsque l'utilisateur tappe sur ces bouttons il a assez d'argent, car les boutons ne seraient pas disponibles sinon.
    @IBAction func achatButtonTapped(_ sender: Any) {
        
        money.takeAwayMoney(amount: allBonus[index].prixAchat)
        
        switch index {
        case 0:
            bonus.addTemps(amount: 1)
        case 1:
            bonus.addDrapeau(amount: 1)
        case 2:
            bonus.addBomb(amount: 1)
        case 3:
            bonus.addVerification(amount: 1)
        case 4:
            var amount = 1
            if levelOfBonus.giveTheLevelOfBonus(forIndex: 4) == 1 {
                amount = 2
            } else if levelOfBonus.giveTheLevelOfBonus(forIndex: 4) == 2 {
                amount = 3
            }
            bonus.addVie(amount: amount)
        default:
            break
        }
        
        delegate?.reloadDatas()
        
    }
    
    @IBAction func ameliorerButtonTapped(_ sender: Any) {
        
        let arrow = SkillUpArrowView()
        arrow.backgroundColor = UIColor.clear
        let arrowWidth: CGFloat = 30
        let arrowHeight: CGFloat = 7/5*arrowWidth
        arrow.frame = CGRect(x: bonusView.frame.maxX - arrowWidth/2, y: bonusView.frame.minY + arrowHeight/2, width: arrowWidth, height: 0)
        contentView.addSubview(arrow)
        
        switch index {
        case 0:
            levelOfBonus.addTemps(amount: 1)
        case 1:
            levelOfBonus.addDrapeau(amount: 1)
        case 2:
            levelOfBonus.addBomb(amount: 1)
        case 3:
            levelOfBonus.addVerification(amount: 1)
        case 4:
            levelOfBonus.addVie(amount: 1)
        default:
            break
        }
        
        levelLabel.text = String(levelOfBonus.giveTheLevelOfBonus(forIndex: index))

        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            arrow.frame = CGRect(x: self.bonusView.frame.maxX - arrowWidth/2, y: self.bonusView.frame.minY - arrowHeight/2, width: arrowWidth, height: arrowHeight)
        }) { (_) in
            
            UIView.animate(withDuration: 0.4, animations: {
                arrow.alpha = 0
            }, completion: { (_) in
                money.takeAwayMoney(amount: allBonus[self.index].prixAmelioration[levelOfBonus.giveTheLevelOfBonus(forIndex: self.index)])
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
