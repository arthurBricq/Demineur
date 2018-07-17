//
//  ArticleViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 15/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit


/**
 ViewController en charge de la boutique qui est dans le menu pause.
 Ce ViewController est instancié par un PageViewController qui lui est instancié dans un ContainerView
*/



class ArticleViewController: UIViewController {

    var articleIndex: Int = 1
    
    var boutiquePopulation: [(description: String,prix: String)] = [
        ("1 drapeaux en plus pour la partie.","1000"),
        ("10 secondes en plus pour la partie.","1000"),
        ("Vérifiez vos drapeaux déjà posé.","2000"),
        ("Gagnez une vie supplémentaire.","2000")
    ]
    
    /// OUTLETS
    @IBOutlet weak var achatButton: AchatBoutiqueBouton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    func updateView() {
        descriptionLabel.text = boutiquePopulation[articleIndex].description
        achatButton.prix = boutiquePopulation[articleIndex].prix
    }

}
