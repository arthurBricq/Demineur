//
//  Type1TableViewCell.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 09/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/*
class Type1TableViewCell: UITableViewCell {
    
    var currentGame: Int = 4
    var strokeColor: UIColor = UIColor(red: 0, green: 144/255, blue: 81/255, alpha: 1.0)
    var secondStrokeColor: UIColor = UIColor.orange
    
    // Retourne le dernier des niveaux
    private var lastLevel: Int {
        return historyLevels.count
    }
    
    // Pour la logique des bouttons
    var buttonTappedClosure: ((Int)->Void)?
    
    var firstGameOfRow: Int = 4
    
    /// OUTLETS des bouttons
    @IBOutlet weak var button1: RoundButtonWithNumber!
    @IBOutlet weak var button2: RoundButtonWithNumber!
    @IBOutlet weak var button3: RoundButtonWithNumber!
    
    /**
     Cette fonction permet de faire baisser le alphas des niveaux qui n'ont pas encore été atteints.
     */
    func updateTheAlphas() {
        
        button1.isEnabled = true
        button1.number = firstGameOfRow
        button1.buttonTappedClosure = buttonTappedClosure
        button1.alpha = 1
        
        button2.isEnabled = true
        button2.number = firstGameOfRow+1
        button2.buttonTappedClosure = buttonTappedClosure
        button2.alpha = 1
        
        button3.isEnabled = true
        button3.number = firstGameOfRow+2
        button3.buttonTappedClosure = buttonTappedClosure
        button3.alpha = 1
        
        print("firstGame : \(firstGameOfRow)      x = \(currentGame-firstGameOfRow)")
        
        // bloquer les niveaux qui ne sont pas accessibles
        switch currentGame-firstGameOfRow {
        case let x where x < 0:
            button1.alpha = 0.5 ; button1.isEnabled = false ;
            fallthrough
        case 0:
            button2.alpha = 0.5 ; button2.isEnabled = false ;
            fallthrough
        case 1:
            button3.alpha = 0.5 ; button3.isEnabled = false ;
            fallthrough
        case 2:
            break
        default:
            break
        }
        
        // enlever les niveaux qui n'existe pas
        switch lastLevel-firstGameOfRow{
        case let x where x < 0:
            button1.alpha = 0.0 ; button1.isEnabled = false ;
            fallthrough
        case 0:
            button2.alpha = 0.0 ; button2.isEnabled = false ;
            fallthrough
        case 1:
            button3.alpha = 0.0 ; button3.isEnabled = false ;
            fallthrough
        case 2:
            break
        default:
            break
        }
        
    }
    
    
    override func draw(_ rect: CGRect) {
        // Il y a deux étapes: tracers toutes les lignes, puis tracer les points d'avancer
        
        let h = rect.height ; let w = rect.width ;
        let r:CGFloat = 20
        let d = w/2 - 25 - 3*r
        let dec: CGFloat = 3
        
        strokeColor.setStroke()
        
        updateTheAlphas()
        
        switch currentGame-firstGameOfRow {
        case let x where x >= 3 : // il faut tout dessiner
            
            // dessin du cercle
            let c1 = CGPoint(x: 25 + r, y: h/2)
            let circle = UIBezierPath(arcCenter: c1, radius: r + dec, startAngle: 0, endAngle: 2*3.15, clockwise: true)
            circle.stroke()
            
            // dessin de la ligne qui descend
            secondStrokeColor.setStroke()
            let p1 = CGPoint(x: 25 + r, y: h/2 + r + dec)
            let p2 = CGPoint(x: 25 + r, y: h)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.stroke()
            
            strokeColor.setStroke()
            fallthrough
            
        case 2: // le deuxième niveau de la ligne est aussi terminer
            // dessin de la ligne
            let p1 = CGPoint(x: w/2 - r - dec, y: h/2)
            let p2 = CGPoint(x: 25 + 2*r + dec, y: h/2)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.stroke()
            
            // dessin du cercle
            let c2 = CGPoint(x: w/2, y: h/2)
            let circle = UIBezierPath(arcCenter: c2, radius: r + dec, startAngle: 0, endAngle: 2*3.15, clockwise: true)
            circle.stroke()
            
            fallthrough
        case 1: // le premier niveau est terminé.
            // dessin de la ligne
            let p1 = CGPoint(x: w - 25 - 2*r - dec, y: h/2)
            let p2 = CGPoint(x: w - 25 - 2*r - d + dec, y: h/2)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.stroke()
            
            // dessin du cercle
            let c1 = CGPoint(x: w - 25 - r, y: h/2)
            let circle = UIBezierPath(arcCenter: c1, radius: r + dec, startAngle: 0, endAngle: 2*3.15, clockwise: true)
            circle.stroke()
            
            
            fallthrough
        case 0: // premier niveau de la colonne de type 1
            let p1 = CGPoint(x: w-25-r, y: 0)
            let p2 = CGPoint(x: w-25-r, y: h/2 - r - dec )
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.stroke()
            
            
            fallthrough
            
        default:
            break
        }
        
        
        switch currentGame-firstGameOfRow {
        case 2:
            let p = CGPoint(x: 25 + 2*r + dec, y: h/2)
            let point = UIBezierPath(arcCenter: p, radius: 1, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            point.stroke()
            
        case 1:
            let p = CGPoint(x: w - 25 - 2*r - d + dec, y: h/2)
            let point = UIBezierPath(arcCenter: p, radius: 1, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            point.stroke()
            
        case 0:
            let p = CGPoint(x: w-25-r, y: h/2 - r - dec )
            let point = UIBezierPath(arcCenter: p, radius: 1, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            point.stroke()
        default:
            break
            
        }
        
    }
    
    
    
}

 */
