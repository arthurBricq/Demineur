//
//  TriangularPresentationButton.swift
//  Demineur
//
//  Created by Arthur BRICQ on 03/09/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TriangularPresentationButton: UIButton {

    // MARK: - VARIABLES
    @IBInspectable var strokeColor: UIColor = .black
    @IBInspectable var emptyColor: UIColor = .black
    @IBInspectable var openColor: UIColor = .black
    @IBInspectable var textColor: UIColor = .black
    @IBInspectable var lineWidth: CGFloat = 1.0
    var number: Int = 0
    var closureToStartGame: (()->Void)?
    
    // MARK: - FUNCTIONS
    override func draw(_ rect: CGRect) {
        // Contrainte sur les dimensions : w = a ; h = sin(alpha)w
        let a: CGFloat = rect.width ;
        
        //// 1. dessin des lignes normales ////
        
        // Il y a deux types de bouttons triangulaires : type 1 et type 2
        // on détermine le type grâce à la logique qui vient ici.
        // Le boutton s'occupe lui même de se dessiner comme il le faut : pas besoin de spécifier le type du boutton.
        let buttonType = triangularButtonIsOfType(i: 0, j: 0)
        var contourPath = UIBezierPath() // C'est le chemin du contour.
        var p1 = CGPoint()
        var p2 = CGPoint()
        var p3 = CGPoint()
        
        if buttonType == 1 {
            // ***** TRACER DU TRIANGLE DE TYPE 1 ****** //
            p1 = CGPoint(x: 0, y: 1)
            p2 = CGPoint(x: a/2, y: rect.height)
            p3 = CGPoint(x: a, y: 1)
            let line = UIBezierPath()
            line.move(to: p1)
            line.addLine(to: p2)
            line.addLine(to: p3)
            line.addLine(to: p1)
            line.lineWidth = lineWidth
            contourPath = line
        } else if buttonType == 2 {
            // ***** TRACER DU TRIANGLE DE TYPE 2 ****** //
            p1 = CGPoint(x: 0, y: rect.height)
            p2 = CGPoint(x: a, y: rect.height)
            p3 = CGPoint(x: a/2, y: 0)
            let line = UIBezierPath()
            line.move(to: p1)
            line.addLine(to: p2)
            line.addLine(to: p3)
            line.addLine(to: p1)
            line.lineWidth = lineWidth
            contourPath = line
        }
        
        strokeColor.setStroke()
        let verticalDisplacement: CGFloat = (buttonType == 1) ? -a/7.5 : +a/7.5 // décaler les vues.
        // Remplissage des couleurs
        openColor.setFill()
        contourPath.fill()
        contourPath.stroke()
        // Dessin du numéro.
        /*
        let myLabel = UILabel()
        let cx = rect.width/2
        let cy = rect.height/2
        let sizeOfLabel = CGSize(width: rect.width, height: rect.width)
        let origin = CGPoint(x: cx - rect.width/2, y: cy - rect.width/2 + verticalDisplacement)
        myLabel.frame = CGRect(origin: origin, size: sizeOfLabel)
        myLabel.textAlignment = .center
        myLabel.textColor = textColor
        myLabel.text = "\(number)"
        self.addSubview(myLabel)
         */
    
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let x = point.x
        let y = point.y
        let a = self.frame.width
        let h = self.frame.height
        
        let buttonType = triangularButtonIsOfType(i: 1, j: 0)
        
        if buttonType == 1 {
            if x >= 0 && x <= a/2 {
                if 0 < y && y < 2*h*x/a { return true }
            } else if a/2 < x && x <= a {
                if 0 < y && y < 2*h - 2*h*x/a { return true }
            }
        } else if buttonType == 2 {
            if x <= a/2 && x >= 0 {
                if y > (h - 2*h*x/a) && y < h { return true }
            } else if a/2 < x && x <= a {
                if y > (-h + 2*h*x/a) && y < h { return true  }
            }
        }
        
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.alpha = 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 1.0) {
            self.alpha = 1.0
        }
        self.closureToStartGame?()
    }

}
