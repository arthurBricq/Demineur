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
    
    @IBAction func unwindToInfinitePresentation(segue: UIStoryboardSegue) {
        // retour aux niveaux
    }
    /// fonction appelée lorsque le unwind est fait
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
        
        return UIStoryboardSegue(identifier: identifier, source: fromViewController, destination: toViewController) {
            let fromView = fromViewController.view!
            let toView = toViewController.view!
            if let containerView = fromView.superview {
                toView.frame = fromView.frame
                toView.alpha = 0
                containerView.addSubview(toView)
                
                UIView.animate(withDuration: 1, animations: {
                    toView.alpha = 1
                }, completion: { (_) in
                    toView.removeFromSuperview()
                    self.dismiss(animated: false, completion: nil)
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playButton(_ sender: Any) {
        self.performSegue(withIdentifier: "InfinitePresentationToInfiniteGame", sender: nil)
    }
    
    @IBAction func scoreButton(_ sender: Any) {
        
        
        
    }
    
}
