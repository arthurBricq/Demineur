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
        
        money.currentAmountOfMoney -= allBonus[index].prixAchat
        
        
    }
    
    @IBAction func ameliorerButtonTapped(_ sender: Any) {
        print("b")
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
