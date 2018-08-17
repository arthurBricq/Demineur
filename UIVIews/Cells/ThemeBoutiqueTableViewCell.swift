//
//  ThemeBoutiqueTableViewCell.swift
//  Demineur
//
//  Created by Marin on 17/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class ThemeBoutiqueTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lineView: LineView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var checkerButton: CheckerButton!
    
    @IBAction func chosenButton(_ sender: Any) {
    }
    
}
