//
//  PieceBoutiqueTableViewCell.swift
//  Demineur
//
//  Created by Marin on 15/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class PieceBoutiqueTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var moneyPackView: MoneyPackage!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var prixButton: InAppPurchaseButton!
    
    @IBAction func buyAction(_ sender: Any) {
        print(moneyPackView.size)
    }
    

}
