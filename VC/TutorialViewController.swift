//
//  TutorialViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 27/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uniquement un scroll vertical
        scrollView.contentSize.width = scrollView.bounds.width
        scrollView.contentSize.height = 1000
        
        
        addMenuButton()
        addTitleAndTiters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
    }

    func addMenuButton() {
        let button = UIButton()
        button.setTitle("Menu", for: .normal)
        button.setTitleColor(colorForRGB(r: 94, g: 94, b: 94), for: .normal)
        button.addTarget(self, action: #selector(exitToMenu), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 22)
        button.frame = CGRect(x: 2, y: 10, width: 60, height: 40)
        self.scrollView.addSubview(button)
    }
    
    func addTitleAndTiters() {
        let titleLabel = UILabel()
        titleLabel.text = "key6".localized(lang: reglages.giveCurrentLanguage())
        titleLabel.font = UIFont(name: "PingFangSC-Thin", size: 50)
        titleLabel.textColor = colorForRGB(r: 66, g: 66, b: 66)
        titleLabel.frame = CGRect(x: 2, y: 60, width: 300, height: 70)
        self.scrollView.addSubview(titleLabel)

        
        let sommaireLabel = UILabel()
        sommaireLabel.text = "key7".localized(lang: reglages.giveCurrentLanguage())
        sommaireLabel.font = UIFont(name: "PingFangSC-Thin", size: 25)
        sommaireLabel.textColor = colorForRGB(r: 66, g: 66, b: 66)
        sommaireLabel.frame = CGRect(x: 2, y: 140, width: 400, height: 40)
        self.scrollView.addSubview(sommaireLabel)
        
        let line = LineView()
        line.isVertical = false
        line.frame = CGRect(x: 4, y: 180, width: self.scrollView.frame.width - 8, height: 0.5)
        line.strokeColor = UIColor.lightGray
        line.lineWidth = 1.0
        self.scrollView.addSubview(line)
        
        
    }
    
    
    @objc func exitToMenu() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
