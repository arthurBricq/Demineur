//
//  StartTableViewCell.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 09/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class StartTableViewCell: UITableViewCell {
    
    var currentGame: Int = 4
    var strokeColor: UIColor = UIColor(red: 0, green: 144/255, blue: 81/255, alpha: 1.0)
    var lineWidth: CGFloat = 1
    
    // Pour la logique des bouttons
    var VC: RoundButtonsCanCallVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var button1: RoundButtonWithNumber!
    @IBOutlet weak var button2: RoundButtonWithNumber!
    @IBOutlet weak var button3: RoundButtonWithNumber!
    
    
    /**
     Cette fonction est appelée par la TableView pour s'occuper de présenter correctement les boutons des niveaux. De plus, cette fonction permet d'indiquer aux boutons qu'elle est leur numéro.
     */
    func updateTheAlphas() {
        
        button1.isEnabled = true
        button1.number = 1
        button1.delegate = VC
        
        button2.isEnabled = true
        button2.number = 2
        button2.delegate = VC
        
        button3.isEnabled = true
        button3.number = 3
        button3.delegate = VC
        
        // presentation
        switch currentGame {
        case 1:
            button2.alpha = 0.5 ; button2.isEnabled = false ;
            fallthrough
        case 2:
            button3.alpha = 0.5 ; button3.isEnabled = false ;
            
        default:
            break
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        print("drawing")
        let h = rect.height ; let w = rect.width ;
        let r:CGFloat = 20
        let d = w/2 - 25 - 3*r
        let dec: CGFloat = 3
        strokeColor.setStroke()
        
        switch currentGame {
        case 4...Int.max:
            // dessin du cercle autour de 3 :
            let c3 = CGPoint(x: w - 25 - r, y: h/2)
            let circle = UIBezierPath(arcCenter: c3, radius: r + dec, startAngle: 0, endAngle: 2*3.15, clockwise: true)
            circle.lineWidth = lineWidth
            circle.stroke()
            
            // dessin de la ligne
            let p1 = CGPoint(x:w - 25 - r, y: h/2+r+dec)
            let p2 = CGPoint(x:w - 25 - r, y: h)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.lineWidth = lineWidth
            path.stroke()
            
            fallthrough
        case 3:
            // dessin de la ligne de 2 à 3
            let p1 = CGPoint(x: w - 25 - 2*r - d + dec , y:h/2 )
            let p2 = CGPoint(x: w - 25 - 2*r - dec, y: h/2)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.lineWidth = lineWidth
            path.stroke()
            
            // dessin du cercle
            let c2 = CGPoint(x: w/2, y: h/2) // centre du cercle 2
            let circle = UIBezierPath(arcCenter: c2, radius: r + dec, startAngle: 0, endAngle: 2*3.15, clockwise: true)
            circle.lineWidth = lineWidth
            circle.stroke()
            
            fallthrough
        case 2:
            // Dessin de la ligne de 1 à 2
            let p1 = CGPoint(x: 25 + 2*r + dec, y: h/2)
            let p2 = CGPoint(x: 25 + 2*r + d - dec, y: h/2)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.lineWidth = lineWidth
            path.stroke()
            
            // dessin du cercle
            let c1 = CGPoint(x: 25+r, y: h/2)
            let circle = UIBezierPath(arcCenter: c1, radius: r + dec, startAngle: 0, endAngle: 2*3.15, clockwise: true)
            circle.lineWidth = lineWidth
            circle.stroke()
            
            fallthrough
        case 1:
            let p1 = CGPoint(x: 0, y: h/2)
            let p2 = CGPoint(x: 25-dec, y: h/2)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.lineWidth = lineWidth
            path.stroke()
            
            //
            break
        default:
            
            break
        }
        
        
        // dessin du point de la fin (il faut recommencer, sans les cascades)
        
        
        switch currentGame {
        case 3:
            let p = CGPoint(x: w - 25 - 2*r - dec, y: h/2)
            let point = UIBezierPath(arcCenter: p, radius: 1, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            point.stroke()
        case 2:
            let p = CGPoint(x: 25 + 2*r + d - dec, y: h/2)
            let point = UIBezierPath(arcCenter: p, radius: 1, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            point.stroke()
        case 1:
            let p = CGPoint(x: 25-dec, y: h/2)
            let point = UIBezierPath(arcCenter: p, radius: 1, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            point.stroke()
        default:
            break
        }
        
    }
    
    
    
}
