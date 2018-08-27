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
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var lineView: LineView!
    
    
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    // MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        text1label.text = "Plus grand niveau atteint durant une partie:"
        number1label.text = String(localScores.bestLevel)
        
        text2label.text = "Plus grand nombre de bombes désamorcées"
        numbe2label.text = String(localScores.bestNumberOfBombs)
        
        
        
        // Pour calculer le pourcentage des plus forts, il faut connaitre les niveaux maximum de tous les joueurs. 
        
        if Reachability.isConnectedToNetwork() { // Si internet est actif ...
            
            // BEST SCORES
            text3label.text = "Plus grand niveau atteint durant une partie:"
            number3label.text = String(scoresModel.bestLevel)
            
            text4label.text = "Plus grand nombre de bombes désamorcées"
            number4label.text = String(scoresModel.bestNumberOfBombs)
            
            
            // STATISTIQUES
            let (localAverageLevel, localAverageNumberOfBombs) = (localScores.averageLevel,localScores.averageNumberOfBombs)
            
            // Tableau des comparaisons
            let equivalentScores = scoresModel.findEquivalentScoresOfPlayers()
            let averageLevels = scoresModel.findAverageLevelOfPlayers()
            let numberOfBombs = scoresModel.findTotalNumberOfBombsOfPlayers()
            
            
            
            // Methode pour les X% les plus fort:
            // 1. On calcul le "score equivalent", où chaque niveau rapporte 10 points et où chaque bombe rapporte 1 point
            // 2. On compare ce score avec tous les scores équivalent de tous les joueurs pour trouver le X% des plus forts, à l'aide d'un tableau de tous les scores équivalent triés
            let localEquivalentScore = 10 * localAverageLevel + localAverageNumberOfBombs
            var tmp: Int = 0
            while localEquivalentScore > equivalentScores[tmp] && tmp < equivalentScores.count-1 {
                tmp += 1
            }
            let pourcentage1: CGFloat = (1 - CGFloat(tmp/equivalentScores.count))*(100)
            label5.text = "Vous faites parties des \(pourcentage1)% les plus doués ! "
            
            
            
            // Pour la durée des parties, on refais pareil
            tmp = 0 // reinitaliser
            while localAverageLevel > averageLevels[tmp] && tmp < averageLevels.count-1 {
                tmp += 1
            }
            let pourcentage2: CGFloat = 100*(1 - CGFloat(tmp/averageLevels.count))
            label6.text = "Vous arrivez plus loin que \(pourcentage2)% des joueurs"
            
            
            
            // Pour le nombre de bombe
            
            tmp = 0
            while localScores.totalNumberOfBombs > numberOfBombs[tmp] && tmp < numberOfBombs.count-1 { tmp += 1}
            let pourcentage3: CGFloat = 100 * (1 - CGFloat(tmp/numberOfBombs.count))
            label7.text = "Vous avez désamorcé \(localScores.totalNumberOfBombs) bombes, soit plus que \(pourcentage3)% des joueurs."
            
            
            
            
        } else {
            text3label.text = "Internet Requis"
            number3label.text = ""
            
            text4label.text = "Internet Requis"
            number4label.text = ""
            
            label5.text = "Internet Requis"
            label6.text = ""
            label7.text = ""
        }
        
        
        
        
        
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
