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
class HistoryPresentationCell: UITableViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var levelButton: RoundButtonWithNumber!
    @IBOutlet weak var historyLabel: UILabel!
    
    // MARK: - Variables
    
    var buttonTappedClosure: (()->Void)?
    var cellState: PresentationCellState?
    
    // MARK: - Actions
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.buttonTappedClosure?()
    }
    
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
        self.contentView.superview?.clipsToBounds = false 
    }
    
    /// Call this function to set a cell that is not the first row
    public func setCell(displayedLevel level: Int, cellState state: PresentationCellState) {
        self.levelButton.isHidden = false
        self.historyLabel.isHidden = true
        self.levelButton.setTitle(String(level), for: .normal)
        self.cellState = state
        if state == .notReachedYet {
            levelButton.setDisable()
        } else {
            levelButton.setEnable()
        }
    }
    
    /// Call this function to set a cell that is the first row only s
    public func disableAndHideButton() {
        self.levelButton.isHidden = true
        self.historyLabel.isHidden = false
        self.cellState = .firstRow
    }
    
    override func draw(_ rect: CGRect) {
        
        // Dimension of the box and variables to be used
        let h = rect.height
        let w = rect.width
        let r:CGFloat = 20
        let dec: CGFloat = 3
        let linewidth: CGFloat = 2.0
        UIColor.gray.setStroke()
        
        if let state = self.cellState {
            print("will now draw")
            switch state {
            case .firstRow:
                // This line must be animated
                let p1 = CGPoint(x: 0, y: h/2)
                let p2 = CGPoint(x: w/2, y: h/2)
                let p3 = CGPoint(x: w/2, y: h)
                let path = UIBezierPath()
                path.move(to: p1)
                path.addLine(to: p2)
                path.addLine(to: p3)
                path.lineWidth = linewidth
                path.stroke()
                
            case .notReachedYet:
                // Nothing to do ...
                break
            case .completed:
                 // 1. Line from the top
                 let p1 = CGPoint(x: w/2, y: 0)
                 let p2 = CGPoint(x: w/2/**/, y: h/2 - r - dec)
                 let path = UIBezierPath()
                 path.move(to: p1)
                 path.addLine(to: p2)
                 
                 // 2. Circle around the level
                 let center = CGPoint(x: w/2, y: h/2)
                 let circle = UIBezierPath(arcCenter: center, radius: r + dec, startAngle: 0, endAngle: 7, clockwise: true)
                 circle.lineWidth = linewidth
                 circle.stroke()
                 
                // 3. Line going below the circle
                 let p3 = CGPoint(x: w/2, y: h/2 + r + dec)
                 let p4 = CGPoint(x: w/2, y: h)
                 path.move(to: p3)
                 path.addLine(to: p4)
                 path.lineWidth = linewidth
                 path.stroke()
                
            case .reached:
                // 1. Line from the top
                let p1 = CGPoint(x: w/2, y: 0)
                let p2 = CGPoint(x: w/2, y: h/2 - r - dec)
                let path = UIBezierPath()
                path.move(to: p1)
                path.addLine(to: p2)
                path.lineWidth = linewidth
                path.stroke()
                
                // 2. Make a point at point p2
                let point = UIBezierPath(arcCenter: p2, radius: 1.5, startAngle: 0, endAngle: 6.3, clockwise: true)
                point.lineWidth = 2
                point.stroke()
            }
        }
        
        
        
    }
    
}
