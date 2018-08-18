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
    var currentTheme: ColorTheme {
        get {
            return allThemes[index]
        }
    }
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
    }
    
    @IBAction func buyAction(_ sender: Any) {
        
        
        
    }
    
}
