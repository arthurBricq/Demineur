//
//  ArticleViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    var articleIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("une vue arrive avec index: \(articleIndex)")
        
        let h = self.view.frame.height
        let w = self.view.frame.width
        let view = ArticleView(frame: CGRect(x: 5, y: 5, width: h-10, height: h-10))
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        view.index = articleIndex
        
        if articleIndex == 0 {
            self.view.backgroundColor = UIColor.blue
        } else if articleIndex == 1 {
            self.view.backgroundColor = UIColor.red
        } else if articleIndex == 2 {
            self.view.backgroundColor = UIColor.green
        } else if articleIndex == 3 {
            self.view.backgroundColor = UIColor.orange
        }
        
        
    }

}
