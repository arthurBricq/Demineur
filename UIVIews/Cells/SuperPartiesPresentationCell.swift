//
//  SuperPartiesPresentationCell.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

class SuperPartiesPresentationCell: UIView {
    
    // MARK: - Outlets
    
    var squareButton: SquarePresentationButton?
    var hexButton: HexPresentationButton?
    var triangleButton: TriangularPresentationButton?
    
    // MARK: - Variables

    var closureToStartGame: ((Int,GameType)->Void)? // Parameters : level, gameType
    var level: Int = 0
    
    // MARK: - Variables set by the setters and used to draw
    
    private var xSquareLinePosition: CGFloat = 0
    
    // MARK: - Constants
    
    let buttonSize: CGFloat = 40
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add the three buttons in the cell
        let w = frame.width
        let h = frame.height
        // Square button
        squareButton = SquarePresentationButton(frame: CGRect(x: w/4-buttonSize/2 - 30, y: h/2-buttonSize/2, width: buttonSize, height: buttonSize))
        squareButton!.cornersToDraw = [1,2,3,4,5,6,7,8]
        squareButton!.openColor = .white
        squareButton!.strokeColor = .black
        squareButton!.ratio = 2
        squareButton!.setTitleColor(UIColor.lightGray, for: .normal)
        // Hex button
        hexButton = HexPresentationButton(frame: CGRect(x: 2*w/4-buttonSize/2, y: h/2-buttonSize/2, width: buttonSize, height: buttonSize))
        hexButton!.openColor = .white
        hexButton!.strokeColor = .black
        hexButton!.setTitleColor(UIColor.lightGray, for: .normal)
        // Triangular button
        triangleButton = TriangularPresentationButton(frame: CGRect(x: 3*w/4-buttonSize/2 + 30, y: h/2-buttonSize/2, width: buttonSize, height: buttonSize))
        triangleButton!.openColor = .white
        triangleButton!.strokeColor = .black
        triangleButton!.setTitleColor(UIColor.lightGray, for: .normal)
        // And set all the 'xposition holders' that we need to know to draw the lines
        xSquareLinePosition = w/4-buttonSize/2 - 30 + buttonSize/2
        // And add them all 
        self.addSubview(squareButton!)
        self.addSubview(triangleButton!)
        self.addSubview(hexButton!)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions to set the cell
    
    public func setCell(reachedLevels: (square: Int, hex: Int, triangle: Int), cellLevel level: Int, closure: ((Int,GameType)->Void)?) {
        // 1. Right the level on the buttons
        self.level = level
        self.closureToStartGame = closure
        squareButton!.setTitle("\(level+1)", for: .normal)
        squareButton!.closureToStartGame = {
            self.closureToStartGame?(level, .square)
        }
        hexButton!.setTitle("\(level+1)", for: .normal)
        hexButton!.closureToStartGame = {
            self.closureToStartGame?(level, .hexagonal)
        }
        triangleButton!.setTitle("\(level+1)", for: .normal)
        triangleButton!.closureToStartGame = {
            self.closureToStartGame?(level, .triangular)
        }
        
        // 2. Enable the correct buttons
        if level > reachedLevels.square { disableButton(b: squareButton!) }
        if level > reachedLevels.hex { disableButton(b: hexButton!) }
        if level > reachedLevels.triangle { disableButton(b: triangleButton!) }

    }
    
    private func disableButton(b: UIButton) {
        b.isEnabled = false
        b.alpha = 0.4
    }
    
    // MARK: - Functions for the drawings
    
    private func getSquarePath() -> UIBezierPath {
        let h = self.frame.height
        let dec: CGFloat = 3.0
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xSquareLinePosition, y: 0))
        path.addLine(to: CGPoint(x: xSquareLinePosition, y: h/2 - buttonSize/2 - dec))
        return path
    }
    
    private func getHexPath() -> UIBezierPath {
        // TODO: complete

        return UIBezierPath()
    }
    
    private func getTrianglePath() -> UIBezierPath {
        // TODO: complete

        return  UIBezierPath()
    }
    
    /// Returns the path that contains all the lines to be drawn inside this cell. This is the path to be animated from top to botom.
    private func getLinePath() -> UIBezierPath {
        let p1 = getSquarePath()
        let p2 = getHexPath()
        let p3 = getTrianglePath()
        p1.append(p2)
        p1.append(p3)
        return p1
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = getLinePath()
        UIColor.gray.setStroke()
        path.lineWidth = 2.0
        path.stroke()
    }
    
    
    
}
