//
//  ThemeBoutiqueTableViewCell.swift
//  Demineur
//
//  Created by Marin on 17/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class ThemeBoutiqueTableViewCell: UITableViewCell {

    // MARK: - Variables
    var index: Int = 0
    var delegate: CellCanCallTableViewController?
    
    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lineView: LineView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var checkerButton: CheckerButton!
    @IBOutlet weak var hidingView: UIView!
    @IBOutlet weak var buyButton: AchatBoutiqueBouton!
    @IBOutlet weak var lockView: LockView!
    
    
    // MARK: - Actions
    @IBAction func chosenButton(_ sender: Any) {
        
        selectedTheme = index
        delegate?.reloadDatas()
        
    }
    
    @IBAction func buyAction(_ sender: Any) {
        
        money.takeAwayMoney(amount: allThemes[index].price)
        allThemes[index].isUnlocked = true
        
        delay(seconds: 0.2) {
            UIView.animate(withDuration: 0.5) {
                self.lockView.progress = 0
            }
            UIView.animateKeyframes(withDuration: 1.5, delay: 0.4, options: [], animations: {
                self.hidingView.alpha = 0
                self.buyButton.alpha = 0
            }) { (_) in
                self.delegate?.reloadDatas()
            }
        }
        
    }
    
}
