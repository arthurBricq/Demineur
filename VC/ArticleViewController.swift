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

    override var prefersStatusBarHidden: Bool { return true }
    
    var articleIndex: Int = 1
    
    var boutiquePopulation: [(description: String,prix: String)] = [
        ("10 secondes en plus pour la partie.","1000"),
        ("1 drapeaux en plus pour la partie.","1000"),
        ("Vérifiez vos drapeaux déjà posé.","2000"),
        ("Gagnez une vie supplémentaire.","2000")
    ]
    
    /// OUTLETS
    @IBOutlet weak var achatButton: AchatBoutiqueBouton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView! // c'est la vue à gauche
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    func updateView() {
        let bonus = allBonus[articleIndex]
        descriptionLabel.text = bonus.descriptions[bonus.niveau]
        achatButton.prix = String(bonus.prixAchat)
        containerView.backgroundColor = UIColor.clear
        let size = containerView.frame.size
        let bonusView = BonusView()
        bonusView.backgroundColor = UIColor.clear
        bonusView.index = articleIndex
        bonusView.frame = CGRect(origin: CGPoint.zero, size: size)
        if articleIndex == 0 {
            switch bonus.niveau {
            case 0:
                bonusView.tempsAngleParameter = 0
            case 1:
                bonusView.tempsAngleParameter = 3.1416/2
            case 2:
                bonusView.tempsAngleParameter = 3.1416
            case 3:
                bonusView.tempsAngleParameter = 3*3.1416/2
            default:
                print("erreur pour la vue du temps des articles") ; break ;
            }
        }
        containerView.addSubview(bonusView)
    }
    

}
