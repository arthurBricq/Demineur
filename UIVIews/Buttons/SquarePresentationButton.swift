//
//  SquarePresentationButton.swift
//  Demineur
//
//  Created by Arthur BRICQ on 03/09/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class SquarePresentationButton: UIButton {

    // MARK: -  VARIABLES
    @IBInspectable var cornersToDraw: [Int] = [1,2,3,4,5,6,7,8]
    @IBInspectable var ratio: CGFloat = 6
    @IBInspectable var lineWidth: CGFloat = 1.0
    var number: Int = 0
    var openColor = UIColor.white // color for open-case's background
    var emptyColor = UIColor.white // color for empty-case's background
    var strokeColor = UIColor.white
    var textColor = UIColor.black
    
    
    
    override func draw(_ rect: CGRect) {
        let w = rect.width
        let h = rect.height
        if w != h { fatalError("les tailles ne sont pas cohérentes") }
        let r = w
        
        ///// 1 dessin des contours habituels /////
        // ******** drawing the corners of the case ************ //
        strokeColor.setStroke()
        openColor.setFill()
        
        let p1 = CGPoint(x: 1, y: 1)
        let p2 = CGPoint(x: 1, y: r-1)
        let p3 = CGPoint(x: r-1, y: r-1)
        let p4 = CGPoint(x: r-1, y: 1)
        
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.addLine(to: p1)
        
        
        /*
        let path = UIBezierPath(rect: rect)
        path.fill() ;
        // Creation of the label to display the number.
        let myLabel = UILabel()
        let sizeOfLabel = CGSize(width: r, height: r)
        let origin = CGPoint(x: 0, y: 0)
        myLabel.frame = CGRect(origin: origin, size: sizeOfLabel)
        myLabel.textAlignment = .center
        myLabel.textColor = textColor
        myLabel.text = "\(number)"
        self.addSubview(myLabel)
        */
        path.fill()
        path.stroke()

        
        //// 3. Surligner les cases qui sont en extrémités.
        /// On ne peut pas dessiner sur les cases qui sont au dessus ou en dessous de soi.
        /// il y a deux cas à distinguer : la case est à un bord blogal.
        /// la case est contre une none case (dans ce cas, il faut que ce soit la methode draw de la none case qui soit appelée.)
    
        print("Nombre de subviews dans une case carrée: \(self.subviews.count) \n")
        
    }
       
}
