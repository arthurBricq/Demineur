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
    var isFirstRow: Bool = false
    var animationDelegate: CAAnimationDelegate?

    
    // MARK: - Variables set by the setters and used to draw
    
    private var xSquareLinePosition: CGFloat = 0
    private var squareCellState = PresentationCellState.completed
    private var xHexLinePosition: CGFloat = 0
    private var hexCellState = PresentationCellState.completed
    private var xTriangleLinePosition: CGFloat = 0
    private var triangleCellState = PresentationCellState.completed
    
    // MARK: - Constants
    
    let buttonSize: CGFloat = 40
    
    // MARK: - Inits
    
    init(frame: CGRect, level: Int, animationDelegate: CAAnimationDelegate) {
        super.init(frame: frame)
        self.isFirstRow = level == 0
        print("INIT level: \(level)")
        self.level = level 
        self.animationDelegate = animationDelegate
        let w = frame.width
        let h = frame.height
        xSquareLinePosition = w/4-buttonSize/2 - 30 + buttonSize/2
        xHexLinePosition = w/2
        xTriangleLinePosition = 3*w/4-buttonSize/2 + 30
        self.backgroundColor = UIColor.clear
        
        if !isFirstRow { // Adds the button
            // Square button
            squareButton = SquarePresentationButton(frame: CGRect(x: xSquareLinePosition-buttonSize/2, y: h/2-buttonSize/2, width: buttonSize, height: buttonSize))
            squareButton!.cornersToDraw = [1,2,3,4,5,6,7,8]
            squareButton!.openColor = .white
            squareButton!.strokeColor = .black
            squareButton!.ratio = 2
            squareButton!.setTitleColor(UIColor.lightGray, for: .normal)
            // Hex button
            hexButton = HexPresentationButton(frame: CGRect(x: xHexLinePosition-buttonSize/2, y: h/2-buttonSize/2, width: buttonSize, height: buttonSize))
            hexButton!.openColor = .white
            hexButton!.strokeColor = .black
            hexButton!.setTitleColor(UIColor.lightGray, for: .normal)
            // Triangular button
            triangleButton = TriangularPresentationButton(frame: CGRect(x: xTriangleLinePosition-buttonSize/2, y: h/2-buttonSize/2, width: buttonSize, height: buttonSize))
            triangleButton!.openColor = .white
            triangleButton!.strokeColor = .black
            triangleButton!.setTitleColor(UIColor.lightGray, for: .normal)
            // And add them all
            self.addSubview(squareButton!)
            self.addSubview(triangleButton!)
            self.addSubview(hexButton!)
        } 
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    // MARK: - Functions to set the cell
    
    public func setCell(reachedLevels: (square: Int, hex: Int, triangle: Int), cellLevel level: Int, closure: ((Int,GameType)->Void)?) {
        // 1. Right the level on the buttons
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
        triangleButton!.contentHorizontalAlignment = .center
        triangleButton!.contentVerticalAlignment = .top
        triangleButton!.titleEdgeInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // 2. Enable the correct buttons
        if level > reachedLevels.square { disableButton(b: squareButton!) }
        if level > reachedLevels.hex { disableButton(b: hexButton!) }
        if level > reachedLevels.triangle { disableButton(b: triangleButton!) }
        
        // 3. Find the states for every line to be drawn
        if level > reachedLevels.square { squareCellState = .notReachedYet } else { squareCellState = (level == reachedLevels.square) ? .reached : .completed }
        if level > reachedLevels.hex { hexCellState = .notReachedYet } else { hexCellState = (level == reachedLevels.hex) ? .reached : .completed }
        if level > reachedLevels.triangle { triangleCellState = .notReachedYet } else { triangleCellState = (level == reachedLevels.triangle) ? .reached : .completed }

        
    }
    
    private func disableButton(b: UIButton) {
        b.isEnabled = false
        b.alpha = 0.4
    }
    
    // MARK: - Functions for the drawings
    
    private func getSquarePath() -> UIBezierPath {
        let path = UIBezierPath()
        let h = self.frame.height
        let dec: CGFloat = 3.0
        
        if squareCellState == .reached || squareCellState == .completed {
            // Add the upper most line
            path.move(to: CGPoint(x: xSquareLinePosition, y: 0))
            path.addLine(to: CGPoint(x: xSquareLinePosition, y: h/2 - buttonSize/2 - dec))
        }
        
        if squareCellState == .reached {
            // Add the point here
            let center = CGPoint(x: xSquareLinePosition, y: h/2 - buttonSize/2 - dec)
            let point = UIBezierPath(arcCenter: center, radius: 1.5, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            path.append(point)
        }
        
        if squareCellState == .completed {
            // Add the line around the square
            let p1 = CGPoint(x: xSquareLinePosition - buttonSize/2 - dec, y: h/2 - buttonSize/2 - dec)
            let p2 = CGPoint(x: xSquareLinePosition - buttonSize/2 - dec, y: h/2 + buttonSize/2 + dec)
            let p3 = CGPoint(x: xSquareLinePosition + buttonSize/2 + dec, y: h/2 + buttonSize/2 + dec)
            let p4 = CGPoint(x: xSquareLinePosition + buttonSize/2 + dec, y: h/2 - buttonSize/2 - dec)
            path.move(to: p1)
            path.addLine(to: p2)
            path.addLine(to: p3)
            path.addLine(to: p4)
            path.addLine(to: p1)
            
            // Add the line going to the dow
            path.move(to: CGPoint(x: xSquareLinePosition, y: h/2 + buttonSize/2 + dec))
            path.addLine(to: CGPoint(x: xSquareLinePosition, y: h))
        }
        
        
        return path
    }
    
    private func getHexPath() -> UIBezierPath {
        let path = UIBezierPath()
        let h = self.frame.height
        let dec: CGFloat = 3.0
        
        if hexCellState == .reached || hexCellState == .completed {
            // Add the upper most line
            path.move(to: CGPoint(x: xHexLinePosition, y: 0))
            path.addLine(to: CGPoint(x: xHexLinePosition, y: h/2 - buttonSize/2 - dec))
        }
        
        if hexCellState == .reached {
            // Add the point here
            let center = CGPoint(x: xHexLinePosition, y: h/2 - buttonSize/2 - dec)
            let point = UIBezierPath(arcCenter: center, radius: 1.5, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            path.append(point)
        }
        
        if hexCellState == .completed {
            let a = buttonSize/2 + dec 
            let x0 = xHexLinePosition
            let teta = CGFloat.pi / 3
            let p1 = CGPoint(x: x0, y: h/2 - buttonSize/2 - dec)
            let p2 = CGPoint(x: p1.x + a*sin(teta), y:p1.y + a*cos(teta))
            let p3 = CGPoint(x: p2.x, y: p2.y + a + dec/2)
            let p4 = CGPoint(x: p1.x, y: p1.y + 2*a)
            let p5 = CGPoint(x: p4.x - a*sin(teta), y: p3.y)
            let p6 = CGPoint(x: p5.x, y: p2.y)
            let contourPath = UIBezierPath()
            contourPath.move(to: p1)
            contourPath.addLine(to: p2)
            contourPath.addLine(to: p3)
            contourPath.addLine(to: p4)
            contourPath.addLine(to: p5)
            contourPath.addLine(to: p6)
            contourPath.addLine(to: p1)
            path.append(contourPath)
            path.move(to: CGPoint(x: x0, y: p4.y))
            path.addLine(to: CGPoint(x: x0, y: h))
            
        }

        return path
    }
    
    private func getTrianglePath() -> UIBezierPath {
        
        let path = UIBezierPath()
        let h = self.frame.height
        let dec: CGFloat = 3.0
        
        if triangleCellState == .reached || triangleCellState == .completed {
            // Add the upper most line
            path.move(to: CGPoint(x: xTriangleLinePosition, y: 0))
            path.addLine(to: CGPoint(x: xTriangleLinePosition, y: h/2 - buttonSize/2 - dec))
        }
        
        if triangleCellState == .reached {
            // Add the point here
            let center = CGPoint(x: xTriangleLinePosition, y: h/2 - buttonSize/2 - dec)
            let point = UIBezierPath(arcCenter: center, radius: 1.5, startAngle: 0, endAngle: 6.3, clockwise: true)
            point.lineWidth = 2
            path.append(point)
        }
        
        if triangleCellState == .completed {
            // Add the line around the square
            let p1 = CGPoint(x: xTriangleLinePosition - buttonSize/2 - dec*2, y: h/2 - buttonSize/2 - dec)
            let p2 = CGPoint(x: xTriangleLinePosition + buttonSize/2 + dec*2, y: h/2 - buttonSize/2 - dec)
            let p3 = CGPoint(x: xTriangleLinePosition, y: h/2 + buttonSize/2 + dec*2 + 2)
            path.move(to: p1)
            path.addLine(to: p2)
            path.addLine(to: p3)
            path.addLine(to: p1)
            
            // Add the line going to the dow
            path.move(to: CGPoint(x: xTriangleLinePosition, y: p3.y))
            path.addLine(to: CGPoint(x: xTriangleLinePosition, y: h))
        }
        
        return path
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
    
    /// Returns the path to be drawn in the first row ...
    private func getFirstRowPath(heightOfFirstLine y: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let h = self.frame.height
        let p0 = CGPoint(x: 0, y: y)
        let p1 = CGPoint(x: self.xSquareLinePosition, y: y)
        let p11 = CGPoint(x: self.xSquareLinePosition, y: h)
        let p2 = CGPoint(x: self.xHexLinePosition, y: y)
        let p22 = CGPoint(x: self.xHexLinePosition, y: h)
        let p3 = CGPoint(x: self.xTriangleLinePosition, y: y)
        let p33 = CGPoint(x: self.xTriangleLinePosition, y: h)
        path.move(to: p0)
        path.addLine(to: p3)
        path.addLine(to: p33)
        path.move(to: p1)
        path.addLine(to: p11)
        path.move(to: p2)
        path.addLine(to: p22)
        return path
    }
    
    public func drawFirstRow(heightOfFirstLine y: CGFloat) {
        // 1. Create the path of the first row
        let path = getFirstRowPath(heightOfFirstLine: y)
        path.lineWidth = 2.0
        UIColor.lightGray.setStroke()
        // 2. Make the animation of this cell
        let frontLayer = CAShapeLayer() 
        frontLayer.path = path.cgPath
        frontLayer.strokeColor = UIColor.gray.cgColor
        frontLayer.fillColor = UIColor.clear.cgColor
        frontLayer.lineWidth = 2.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.delegate = animationDelegate
        animation.setValue(self.level, forKey: "cellNumber")
        animation.setValue(false, forKey: "isFinished")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.2
        frontLayer.add(animation, forKey: "drawLineAnimation")
        self.layer.addSublayer(frontLayer)
    }
    
    public func drawRow() {
        // 1. Obtain the path
        let path = getLinePath()
        path.lineWidth = 2.0
        
        // 2. Create a layer that contains the path
        let frontLayer = CAShapeLayer()
        frontLayer.path = path.cgPath
        frontLayer.strokeColor = UIColor.gray.cgColor
        frontLayer.fillColor = UIColor.clear.cgColor
        frontLayer.lineWidth = 2.0
        self.layer.addSublayer(frontLayer)
        
        // 3. Create a new mask on top of the actual layer
        let mask = CAShapeLayer()
        let h = frame.height
        let w = frame.width
        let path1 = UIBezierPath(rect: CGRect(x: 0, y: 0, width: w, height: 0))
        let path2 = UIBezierPath(rect: CGRect(x: 0, y: 0, width: w, height: h))
        mask.path = path1.cgPath
        frontLayer.mask = mask
        
        // 4. Create the animation and sent it to work
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = animationDelegate
        animation.setValue(self.level, forKey: "cellNumber")
        animation.setValue(isFinished(), forKey: "isFinished")
        animation.fromValue = path1.cgPath
        animation.toValue = path2.cgPath
        animation.duration = 0.5
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        frontLayer.mask!.add(animation, forKey: "anim")
        
        
    }
    
    private func isFinished() -> Bool {
        return squareCellState == .notReachedYet && hexCellState == .notReachedYet && triangleCellState == .notReachedYet
    }
    
    
}
