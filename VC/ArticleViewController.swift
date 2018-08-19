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

    // MARK: - VARIABLES
    override var prefersStatusBarHidden: Bool { return true }
    var articleIndex: Int = 1
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var achatButton: AchatBoutiqueBouton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView! // c'est la vue à gauche
    @IBOutlet weak var indicateurNombreLabel: UILabel!
    
    var pauseVC: PauseViewController? 
    
    // MARK: - ACTIONS
    
    @IBAction func achatButtonTapped(_ sender: Any) {
        
        let prix = allBonus[articleIndex].prixAchat
        
        if money.currentAmountOfMoney > prix {
            money.takeAwayMoney(amount: prix)
            
            switch articleIndex {
            case 0:
                bonus.addTemps(amount: 1)
            case 1:
                bonus.addDrapeau(amount: 1)
            case 2:
                bonus.addBomb(amount: 1)
            case 3:
                bonus.addVerification(amount: 1)
            case 4:
                bonus.addVie(amount: 1)
            default:
                break
            }
            
        }
        
        pauseVC?.updateLivesDisplay()
        pauseVC?.updateMoneyDisplay()
        pauseVC?.pieceView.playParticleAnimation()
        updateNumberOfElementDisplay()
        
    }
    
    
    
    
    
    // MARK: - FONCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    
    func updateNumberOfElementDisplay() {
        let tmp = bonus.giveTheNumberOfBonus(forIndex: articleIndex)
        if tmp == 0 || tmp == 1 {
            indicateurNombreLabel.text = "\(tmp) restant"
        } else {
            indicateurNombreLabel.text = "\(tmp) restants"
        }
    }
    
    func updateView() {
        
        // label et prix de la case
        let currentBonus = allBonus[articleIndex]
        descriptionLabel.text = currentBonus.descriptions[levelOfBonus.giveTheLevelOfBonus(forIndex: articleIndex)]
        achatButton.prix = String(currentBonus.prixAchat)
        containerView.backgroundColor = UIColor.clear
        
        updateNumberOfElementDisplay()
        
        // ajout de la vue avec le dessin
        let size = containerView.frame.size
        let bonusView = BonusView()
        bonusView.backgroundColor = UIColor.clear
        bonusView.isUserInteractionEnabled = false
        bonusView.index = articleIndex
        bonusView.frame = CGRect(origin: CGPoint.zero, size: size)
        if articleIndex == 0 {
            switch levelOfBonus.giveTheLevelOfBonus(forIndex: articleIndex) {
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
