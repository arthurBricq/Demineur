//
//  HistoryPresentationCell.swift
//  Demineur
//
//  Created by Arthur BRICQ on 10/06/2019.
//  Copyright © 2019 Arthur BRICQ. All rights reserved.
//

import UIKit

/**
 This cell is to present the levels for the history mode.
*/
class HistoryPresentationCell: UIView {
    
    // MARK: - Outlet
    
    var levelButton: RoundButtonWithNumber?
    
    // MARK: - Variables
    
    var cellIndex: Int = 0 // This is the level index of the cell
    var buttonTappedClosure: (()->Void)?
    var cellState: PresentationCellState?
    var isAlreadyDrawn: Bool = false
    var frontLayer = CAShapeLayer()
    var animationDelegate: CAAnimationDelegate?
    
    // MARK: - Constants
    
    let buttonSize: CGFloat = 40
    
    // MARK: - Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add the button in the middle.
        let w = frame.width
        let h = frame.height
        levelButton = RoundButtonWithNumber(frame: CGRect(x: w/2-buttonSize/2, y: h/2-buttonSize/2, width: buttonSize, height: buttonSize))
        levelButton!.setTitleColor(Color.getColor(index: 1), for: .normal)
        levelButton!.backgroundColor = UIColor.clear
        self.addSubview(levelButton!)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Call this function to set a cell that is not the first row. Make sure that the closure was defined before.
    public func setCell(displayedLevel level: Int, cellState state: PresentationCellState, delegate: CAAnimationDelegate) {
        levelButton!.buttonTappedClosure = buttonTappedClosure
        self.cellIndex = level
        self.animationDelegate = delegate
        self.levelButton?.isHidden = false
        self.levelButton?.setTitle(String(level), for: .normal)
        self.levelButton?.setNeedsDisplay()
        self.cellState = state
        if state == .notReachedYet {
            levelButton?.setDisable()
        } else {
            levelButton?.setEnable()
        }
    }
    
    /// Call this function to set a cell that is the first row only.
    public func setFirstRowCell(delegate: CAAnimationDelegate) {
        self.cellIndex = 0
        self.animationDelegate = delegate
        self.levelButton?.isHidden = true
        self.cellState = .firstRow
    }
    
    /// Returns the path of the line drawn on this cell. There is no linewith
    private func getLinePath(size: CGSize) -> UIBezierPath {
        let path = UIBezierPath()
        
        // Dimension of the box and variables to be used
        let h = size.height
        let w = size.width
        let r: CGFloat = buttonSize/2
        let dec: CGFloat = 3
        
        if let state = self.cellState {
            print("will now draw")
            switch state {
            case .firstRow:
                // This line must be animated
                let p1 = CGPoint(x: 0, y: h/2)
                let p2 = CGPoint(x: w/2, y: h/2)
                let p3 = CGPoint(x: w/2, y: h)
                path.move(to: p1)
                path.addLine(to: p2)
                path.addLine(to: p3)
                
            case .notReachedYet:
                // Nothing to do ...
                break
                
            case .completed:
                // 1. Line from the top
                let p1 = CGPoint(x: w/2, y: 0)
                let p2 = CGPoint(x: w/2, y: h/2 - r - dec)
                path.move(to: p1)
                path.addLine(to: p2)
                
                // 2. Circle around the level
                let center = CGPoint(x: w/2, y: h/2)
                let pi: CGFloat = 3.1416
                let arc = UIBezierPath(arcCenter: center, radius: r+dec, startAngle: pi/2, endAngle: pi/2+7, clockwise: true)
                arc.lineWidth = 2.0
                path.append(arc)
                
                // 3. Line going below the circle
                let p3 = CGPoint(x: w/2, y: h/2 + r + dec)
                let p4 = CGPoint(x: w/2, y: h)
                path.move(to: p3)
                path.addLine(to: p4)
                
            case .reached:
                // 1. Line from the top
                let p1 = CGPoint(x: w/2, y: 0)
                let p2 = CGPoint(x: w/2, y: h/2 - r - dec)
                path.move(to: p1)
                path.addLine(to: p2)
                
                // 2. Make a point at point p2
                let point = UIBezierPath(arcCenter: p2, radius: 1.5, startAngle: 0, endAngle: 6.3, clockwise: true)
                point.lineWidth = 2
                path.append(point)
            }
        }
        
        return path
    }
    
    public func animateLine() {
        isAlreadyDrawn = true
        if self.cellState! == .firstRow {
            
            frontLayer.path = getLinePath(size: self.frame.size).cgPath
            frontLayer.strokeColor = Color.getColor(index: 2).cgColor
            frontLayer.fillColor = UIColor.clear.cgColor
            frontLayer.lineWidth = 2.0
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.delegate = animationDelegate
            animation.setValue(cellIndex, forKey: "cellNumber")
            animation.setValue(false, forKey: "isFinished")
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 1.2
            frontLayer.add(animation, forKey: "drawLineAnimation")
            self.layer.addSublayer(frontLayer)
            
        
        } else {
            
            /// Create a layer that contains the path
            frontLayer.path = getLinePath(size: self.frame.size).cgPath
            frontLayer.strokeColor = Color.getColor(index: 2).cgColor
            frontLayer.fillColor = UIColor.clear.cgColor
            frontLayer.lineWidth = 2.0
            self.layer.addSublayer(frontLayer)
            
            /// Create a new mask on top of the actual layer
            let mask = CAShapeLayer()
            let h = frame.height
            let w = frame.width
            let path1 = UIBezierPath(rect: CGRect(x: 0, y: 0, width: w, height: 0))
            let path2 = UIBezierPath(rect: CGRect(x: 0, y: 0, width: w, height: h))
            mask.path = path1.cgPath
            frontLayer.mask = mask
            
            /// Create the animation and sent it to work 
            let animation = CABasicAnimation(keyPath: "path")
            animation.delegate = animationDelegate
            animation.setValue(cellIndex, forKey: "cellNumber")
            animation.setValue(cellState! == .reached, forKey: "isFinished")
            animation.fromValue = path1.cgPath
            animation.toValue = path2.cgPath
            animation.duration = 0.3
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.isRemovedOnCompletion = false
            frontLayer.mask?.add(animation, forKey: "anim")
        }
    }


}
 
