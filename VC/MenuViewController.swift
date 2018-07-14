//
//  MenuViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 06/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var lineE: LineView!
    @IBOutlet weak var lineHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lineHeight.constant = 110 + 5*40 + 4*15
        
        print("Presentation de l'état actuelle des donnes")
        print("argent courant: \(money.currentAmountOfMoney)")
        

    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
}
