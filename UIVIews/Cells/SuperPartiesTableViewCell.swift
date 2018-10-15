//
//  SuperPartiesTableViewCell.swift
//  Demineur
//
//  Created by Arthur BRICQ on 03/09/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class SuperPartiesTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var numberDisplay: NiceButton!
    @IBOutlet weak var squareButton: SquarePresentationButton!
    @IBOutlet weak var hexButton: HexPresentationButton!
    @IBOutlet weak var triangularButton: TriangularPresentationButton!
    var lineColor: UIColor = UIColor.orange
    var level: Int = 1 
    var currentLevelReached: (square: Int, hex: Int, triangle: Int) = (1,1,1)

    
    var ligneDuHautSquare: Bool = true
    var partieSupSquare: Bool = true
    var pointDuMilieuSquare: Bool = true
    var partieInfSquare: Bool = true
    var ligneDuBasSquare: Bool = true
    
    
    // MARK: - Actions
    
    
    // MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        
        // MARK: - Dessin des carrées
        let dec: CGFloat = 6
        lineColor.setStroke()
        lineColor.setFill()
        let cote = squareButton.frame.width
        let origin = squareButton.frame.origin
        
        if ligneDuHautSquare {
            let path = UIBezierPath()
            let p1 = CGPoint(x: origin.x + cote/2, y: 0)
            let p2 = CGPoint(x: origin.x + cote/2, y: origin.y - dec)
            path.move(to: p1)
            path.addLine(to: p2)
            path.stroke()
        }
        
        if partieSupSquare {
            let path = UIBezierPath()
            let p1 = CGPoint(x: origin.x - dec, y: origin.y + cote/2)
            let p2 = CGPoint(x: origin.x - dec, y: origin.y - dec)
            let p3 = CGPoint(x: origin.x + cote + dec, y: origin.y - dec)
            let p4 = CGPoint(x: origin.x + cote + dec, y: origin.y  + cote/2)
            path.move(to: p1)
            path.addLine(to: p2)
            path.addLine(to: p3)
            path.addLine(to: p4)
            path.stroke()
        }
        
        if pointDuMilieuSquare {
            let p1 = CGPoint(x: origin.x - dec, y: origin.y + cote/2)
            let p4 = CGPoint(x: origin.x + cote + dec, y: origin.y  + cote/2)
            let circle1 = UIBezierPath(arcCenter: p1, radius: 2, startAngle: 0, endAngle: 7, clockwise: true)
            let circle2 = UIBezierPath(arcCenter: p4, radius: 2, startAngle: 0, endAngle: 7, clockwise: true)
            circle1.fill()
            circle2.fill()
        }
        
        if partieInfSquare {
            let path = UIBezierPath()
            let p1 = CGPoint(x: origin.x - dec, y: origin.y + cote/2)
            let p2 = CGPoint(x: origin.x - dec, y: origin.y + dec + cote)
            let p3 = CGPoint(x: origin.x + cote + dec, y: origin.y + dec + cote)
            let p4 = CGPoint(x: origin.x + cote + dec, y: origin.y  + cote/2)
            path.move(to: p1)
            path.addLine(to: p2)
            path.addLine(to: p3)
            path.addLine(to: p4)
            path.stroke()
        }
        
        if ligneDuBasSquare {
            let path = UIBezierPath()
            let p1 = CGPoint(x: origin.x + cote/2, y: origin.y + cote + dec)
            let p2 = CGPoint(x: origin.x + cote/2, y: self.frame.height)
            path.move(to: p1)
            path.addLine(to: p2)
            path.stroke()
        }
       
        
    }

}
