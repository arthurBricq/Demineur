//
//  ScoreViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var text1label: UILabel!
    @IBOutlet weak var number1label: UILabel!
    @IBOutlet weak var text2label: UILabel!
    @IBOutlet weak var numbe2label: UILabel!
    @IBOutlet weak var text3label: UILabel!
    @IBOutlet weak var number3label: UILabel!
    @IBOutlet weak var text4label: UILabel!
    @IBOutlet weak var number4label: UILabel!
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    // MARK: - functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        text1label.text = "Plus grand niveau atteint durant une partie:"
        text2label.text = "Plus grand nombre de bombes désamorcées"
        text3label.text = "Plus grand niveau atteint durant une partie:"
        text4label.text = "Plus grand nombre de bombes désamorcées"

    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
