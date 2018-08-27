//
//  MenuViewController.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 06/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lineE: LineView!
    @IBOutlet weak var lineHeight: NSLayoutConstraint!
    @IBOutlet weak var mainLine: LineView!
    @IBOutlet weak var mainLineLeadingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var histoireButton: UIButton!
    @IBOutlet weak var infiniteButton: UIButton!
    @IBOutlet weak var superPartiesButton: UIButton!
    @IBOutlet weak var boutiqueButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var reglagesButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lineHeight.constant = 110 + 6*40 + 5*15

        // CloudKit
        if Reachability.isConnectedToNetwork() == true { // Internet est activé
            scoresModel.refresh()
            print("Gestion des scores en ligne")
            print("Nombre de scores enregistrées en ligne: \(scoresModel.allScores.count)\n")
        }
        // On ajoute la gestion des erreurs
        scoresModel.onError = { error in
            let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            print("Voici l'erreur: \(error.localizedDescription)")
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Localisation
        histoireButton.setTitle("key1".localized(lang: reglages.giveCurrentLanguage()), for: .normal)
        infiniteButton.setTitle("key2".localized(lang: reglages.giveCurrentLanguage()), for: .normal)
        superPartiesButton.setTitle("key3".localized(lang: reglages.giveCurrentLanguage()), for: .normal)
        boutiqueButton.setTitle("key4".localized(lang: reglages.giveCurrentLanguage()), for: .normal)
        reglagesButton.setTitle("key5".localized(lang: reglages.giveCurrentLanguage()), for: .normal)
        tutorialButton.setTitle("key6".localized(lang: reglages.giveCurrentLanguage()), for: .normal)

        
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is HistoryPresentationViewController || segue.destination is BoutiqueViewController || segue.destination is InfinitePresentationViewController || segue.destination is ReglageViewController || segue.destination is TutorialViewController
        {
            segue.destination.transitioningDelegate = self
        }
        
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        // retour au menu
    }
    
}

extension MenuViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented is HistoryPresentationViewController {
            let transition = TransitionToHistoryPresentationViewController()
            transition.animationDuration = 1.5
            transition.presenting = true
            return transition
        } else if presented is InfinitePresentationViewController {
            let transition = TransitionToInfinitePresentationViewController()
            transition.animationDuration = 2.0
            transition.presenting = true
            return transition
        } else if presented is BoutiqueViewController {
            let transition = TransitionToBoutique()
            transition.animationDuration = 1.5
            transition.presenting = true
            return transition
        } else if presented is ReglageViewController {
            let transition = TransitionToReglage()
            transition.animationDuration = 1.5
            transition.presenting = true
            return transition
        } else if presented is TutorialViewController {
            let transition = TransitionToTutoriel()
            transition.animationDuration = 1.5
            transition.presenting = true
            return transition
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed is HistoryPresentationViewController {
            let transition = TransitionToHistoryPresentationViewController()
            transition.animationDuration = 1.5
            transition.presenting = false
            return transition
        } else if dismissed is InfinitePresentationViewController {
            let transition = TransitionToInfinitePresentationViewController()
            transition.animationDuration = 1.5
            transition.presenting = false
            return transition
        } else if dismissed is BoutiqueViewController {
            let transition = TransitionToBoutique()
            transition.animationDuration = 1.5
            transition.presenting = false
            return transition
        } else if dismissed is ReglageViewController {
            let transition = TransitionToReglage()
            transition.animationDuration = 1.5
            transition.presenting = false
            return transition
        } else if dismissed is TutorialViewController {
            let transition = TransitionToTutoriel()
            transition.animationDuration = 1.5
            transition.presenting = false
            return transition
        }
        
        
        return nil
    }
    
}
