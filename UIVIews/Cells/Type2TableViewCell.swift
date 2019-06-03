//
//  Type2TableViewCell.swift
//  DemineIt
//
//  Created by Arthur BRICQ on 09/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class Type2TableViewCell: UITableViewCell {
    
    var currentGame: Int = 1
    var strokeColor: UIColor = UIColor.orange
    var secondStrokeColor: UIColor = UIColor(red: 0, green: 144/255, blue: 81/255, alpha: 1.0)
    var firstGameOfRow: Int = 4
    
    // Retourne le dernier des niveaux
    private var lastLevel: Int {
        return historyLevels.count
    }
    
    // Pour la logique des bouttons
    var buttonTappedClosure: ((Int)->Void)?
    
    // Outlets sur les bouttons
    @IBOutlet weak var button1: RoundButtonWithNumber!
    @IBOutlet weak var button2: RoundButtonWithNumber!
    @IBOutlet weak var button3: RoundButtonWithNumber!
    
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
        
        // bloquer les niveaux qui ne sont pas accessibles
        switch currentGame-firstGameOfRow {
        case let x where x < 0: // aucun des trois boutons accessible ...
            button1.alpha = 0.5 ; button1.isEnabled = false ;
            fallthrough
        case 0: // ... uniquement le premier accessible ...
            button2.alpha = 0.5 ; button2.isEnabled = false ;
            fallthrough
        case 1: // ... et ainsi de suite
            button3.alpha = 0.5 ; button3.isEnabled = false ;
        case 2:
            break
        default:
            break
        }
        
        // enlever les niveaux qui n'existe pas
//        if currentGame > lastLevel {
//            button1.alpha = 0.0 ; button1.isEnabled = false ;
//            button2.alpha = 0.0 ; button2.isEnabled = false ;
//            button3.alpha = 0.0 ; button3.isEnabled = false ;
//        }
        
        
        switch lastLevel-firstGameOfRow {
        case let x where x < 0: // il faut tout enlever
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
        let h = rect.height ; let w = rect.width ;
        let r:CGFloat = 20
        let d = w/2 - 25 - 3*r
        let dec: CGFloat = 3
        
        strokeColor.setStroke()
        
        updateTheAlphas()
        
        switch currentGame-firstGameOfRow {
        case let x where x >= 3:
            
            
            // dessin du cercle autour de 3 :
            let c3 = CGPoint(x: w - 25 - r, y: h/2)
            let circle = UIBezierPath(arcCenter: c3, radius: r + dec, startAngle: 0, endAngle: 2*3.15, clockwise: true)
            circle.stroke()
            
            // dessin de la ligne
            let p1 = CGPoint(x:w - 25 - r, y: h/2+r+dec)
            let p2 = CGPoint(x:w - 25 - r, y: h)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.stroke()
            
            fallthrough
        case 2:
            // dessin de la ligne de 2 à 3
            let p1 = CGPoint(x: w - 25 - 2*r - d + dec , y:h/2 )
            let p2 = CGPoint(x: w - 25 - 2*r - dec, y: h/2)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.stroke()
            
            // dessin du cercle
            let c2 = CGPoint(x: w/2, y: h/2) // centre du cercle 2
            let circle = UIBezierPath(arcCenter: c2, radius: r + dec, startAngle: 0, endAngle: 2*3.15, clockwise: true)
            circle.stroke()
            
            fallthrough
        case 1:
            // Dessin de la ligne de 1 à 2
            let p1 = CGPoint(x: 25 + 2*r + dec, y: h/2)
            let p2 = CGPoint(x: 25 + 2*r + d - dec, y: h/2)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.stroke()
            
            // dessin du cercle
            let c1 = CGPoint(x: 25+r, y: h/2)
            let circle = UIBezierPath(arcCenter: c1, radius: r + dec, startAngle: 0, endAngle: 2*3.15, clockwise: true)
            circle.stroke()
            
            fallthrough
        case 0:
            let p1 = CGPoint(x: 25+r, y: 0)
            let p2 = CGPoint(x: 25+r, y: h/2-r-dec)
            let path = UIBezierPath()
            path.move(to: p1) ; path.addLine(to: p2)
            path.stroke()
            
            
            //
            break
        default:
            
            break
        }
        
        
        // dessin du point de la fin (il faut recommencer, sans les cascades)
        
        
        switch currentGame-firstGameOfRow {
        case 2:
            let p = CGPoint(x: w - 25 - 2*r - dec, y: h/2)
            let point = UIBezierPath(arcCenter: p, radius: 1, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            point.stroke()
        case 1:
            let p = CGPoint(x: 25 + 2*r + d - dec, y: h/2)
            let point = UIBezierPath(arcCenter: p, radius: 1, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            point.stroke()
            
        case 0:
            let p = CGPoint(x: 25 + r, y: h/2 - r - dec)
            let point = UIBezierPath(arcCenter: p, radius: 1, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            point.stroke()
            
        default:
            break
        }
        
    }
    
}
