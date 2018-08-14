//
//  InfinitePresentationViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 10/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class InfinitePresentationViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { return true }
    
    @IBOutlet weak var headerView: HeaderInfinite!
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Positionnement et propriété de la ligne
        /*iLine.backgroundColor = UIColor.clear
        iLine.strokeColor = headerView.color2
        iLine.lineWidth = 2
        iLineLeading.constant = (4.5*headerView.frame.width/163) - iLine.frame.width/2 + iLine.lineWidth/2
        iLineTop.constant += 13.5*headerView.frame.height/57
        
        leftLine.backgroundColor = UIColor.clear
        leftLine.strokeColor = headerView.color2
        leftLine.lineWidth = 2*/
    }
    
    @IBAction func playButton(_ sender: Any) {
    }
    
    @IBAction func scoreButton(_ sender: Any) {
    }
    
}
