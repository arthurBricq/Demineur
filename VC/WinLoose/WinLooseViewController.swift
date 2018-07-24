//
//  WinLooseViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 23/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class WinLooseViewController: UIViewController {

    /// OUTLETS
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    /// VARIABLES

    var win: Bool = false
    
    
    /// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view1.layer.borderWidth = 1.5
        view1.layer.borderColor = UIColor.gray.cgColor
        view1.layer.cornerRadius = 5.0
        view2.layer.borderWidth = 1.0
        view2.layer.borderColor = UIColor.gray.cgColor
        view2.layer.cornerRadius = 5.0
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var darkBlur = UIBlurEffect()
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.regular)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.frame //your view that have any objects
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        if win {
            updateWinDisplay()
        } else {
            updateLooseDisplay()
        }
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("apres le chargement de la vue")
        print(containerView.bounds.width)
        
       
    }
    
    /// pour actualiser la vue lorsque la partie est gagnée
    func updateWinDisplay() {
        titleLabel.text = "GAGNE"
        // titleLabel.textColor = colorForRGB(r: 79, g: 143, b: 0)
        label.text = "Bien joué ! Vous avez trouvé toutes les bombes à temps."
        
        
        let W = containerView.bounds.width
        let largeur = containerView.bounds.height
        
        
        print("W : \(W)")

        
        let b1 = MenuPauseIconsButtons()
        b1.type = 0
        b1.frame = CGRect(x: 0, y: 0, width: largeur, height: largeur)
        
        let b2 = MenuPauseIconsButtons()
        b2.type = 1
        b2.frame = CGRect(x: W/2-largeur/2, y: 0, width: largeur, height: largeur)
        
        let b3 = MenuPauseIconsButtons()
        b3.type = 2
        b3.frame = CGRect(x: W-largeur, y: 0, width: largeur, height: largeur)
        b3.addTarget(self, action: #selector(dismissTheVC), for: .touchUpInside)
        
        
        containerView.addSubview(b1)
        containerView.addSubview(b2)
        containerView.addSubview(b3)
        
    }

    /// pour actualiser la vue lorsque la partie est perdue
    func updateLooseDisplay() {
        titleLabel.text = "PERDU"
        // titleLabel.textColor = colorForRGB(r: 148, g: 17, b: 0)
        label.text = "Dommage ! Le temps est écoulé."
        
        let b1 = MenuPauseIconsButtons()
        b1.type = 0
        // b1.frame.size = CGSize(width: 50, height: 50)
        
    }
    
    @objc func dismissTheVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
