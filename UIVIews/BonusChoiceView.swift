//
//  BonusChoiceView.swift
//  Demineur
//
//  Created by Marin on 18/07/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

/*class BonusChoiceColor {
    var backgroundColorRuban: UIColor = UIColor(red: 0.522, green: 0.522, blue: 0.522, alpha: 1.000)
    var starColor: UIColor = UIColor(red: 0.800, green: 0.574, blue: 0.354, alpha: 1.000)
    var backgroundContainer: UIColor = UIColor.white //= UIColor(red: 0.796, green: 0.796, blue: 0.796, alpha: 1.000)
}

var bonusChoiceColor = BonusChoiceColor() // il s'agit des couleurs de la vue
*/

/// REQUIRED: Largeur = 6 Hauteur
class BonusChoiceView: UIView {
    
    // MARK: - Variables
    
    var viewOfGame: ViewOfGame?
    //var gameTimer: CountingTimer?
    private var scrollView: UIScrollView?
    private var isActivated: Bool = false
    var isTimerOn: Bool = true

    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("This class does not support NSCoding") }
    
    convenience init(frame: CGRect, viewOfGame: ViewOfGame, backgroundColor: UIColor, lineColor: UIColor) {
        self.init(frame: frame)
        self.viewOfGame = viewOfGame
        //self.gameTimer = viewOfGame.gameTimer
        self.backgroundColor = backgroundColor
        //self.progress = 0
        instantiateTopLine(lineColor: lineColor)
        instantiateScrollView()
    }
    
    
    // MARK: - Functions
    
    private func instantiateTopLine(lineColor: UIColor) {
        let line = LineView(lineWidth: 3, isVertical: false, strokeColor: lineColor)
        line.frame = CGRect(x: 0, y: 0, width: frame.width, height: line.lineWidth)
        self.addSubview(line)
    }
    
    private func instantiateScrollView() {
        let tmpScrollView = UIScrollView()
        let width = 0.9 * self.bounds.width
        let height = self.bounds.height - 50
        tmpScrollView.frame = CGRect(x: 0.05 * self.bounds.width, y: (self.frame.height - height)/2, width: width, height: height)
        tmpScrollView.backgroundColor = UIColor.clear
        tmpScrollView.isScrollEnabled = true
        //tmpScrollView.alpha = 0
        tmpScrollView.showsVerticalScrollIndicator = false
        tmpScrollView.showsHorizontalScrollIndicator = true
        tmpScrollView.indicatorStyle = .default
        scrollView = tmpScrollView
        self.addSubview(scrollView!)
        populateScrollView()
    }
    
    private func populateScrollView() {
        
        let y0: CGFloat = 2
        let c = self.scrollView!.frame.height - 10
        let esp: CGFloat = 40 // espacement entre les boutons
        
        scrollView!.contentSize = CGSize(width: 4*(c+esp) - esp/2 + 30 , height: self.scrollView!.frame.height )

        for i in (scrollView?.subviews)! {
            i.removeFromSuperview()
        }
        
        for i in 0..<4 {
            let v = BonusView() // v comme view
            v.frame = CGRect(x: 10 + CGFloat(i)*(c+esp), y: y0, width: c, height: c)
            v.index = i
            v.bonusBarView = self 
            v.backgroundColor = UIColor.clear
            let r = UILabel() // r comme rond
            let d = c/2 // diametre du rond avec le nombre de bonus
            r.backgroundColor = UIColor.clear
            r.textColor = UIColor(red: 0.522, green: 0.522, blue: 0.522, alpha: 1.000) //bonusChoiceColor.backgroundColorRuban
            r.font = UIFont(name: "PingFangSC-Semibold", size: 20)
            r.layer.zPosition = 10
            r.frame = CGRect(x: c+4, y: c-d/2-10, width: d+10, height: d)
            r.text = String(dataManager.quantityOfBonus(atIndex: i))
            r.tag = i
            v.addSubview(r)
            scrollView!.addSubview(v)
        }
        
        
        if isActivated {
            updateTheNumberLabels()
        } else {
            desactivateBonusButtons()
        }
        
        scrollView!.flashScrollIndicators()
        
        
    }
    
    /// Cette fonction permet de réactiver tous les bonus après le début de la partie.
    public func activateBonusButtons() {
        updateTheNumberLabels()
        isActivated = true
    }
    
    /// Cette fonction doit-être appelée au début d'une partie pour pas que les bonus soit accessibles au début. Elle permet aussi de mettre les bons numéros à l'écran.
    public func desactivateBonusButtons() {
        for tmp in scrollView!.subviews {
            if tmp is BonusView {
                let view = tmp as! BonusView
                guard let label = view.subviews[0] as? UILabel else { return } // il n'y a qu'un seul subview, il s'agit du label
                
                let number = dataManager.quantityOfBonus(atIndex: label.tag)
                view.alpha = 0.5
                view.isUserInteractionEnabled = false
                label.text = String(number)
            }
        }
    }
    
    /**
     Cette fonction permet de changer le nombre de bonus à l'ecran, elle fonctionne grâce à la propriété 'tag' qui est ajouté aux label par la fonction 'populateScrollView()'
    */
    func updateTheNumberLabels() {
        for subview in scrollView!.subviews {
            if subview is BonusView {
                let view = subview as! BonusView
                guard let label = view.subviews[0] as? UILabel else { return } // il n'y a qu'un seul subview, il s'agit du label
                
                let number = dataManager.quantityOfBonus(atIndex: label.tag)
                
                if number == 0 || (!isTimerOn && view.index == 0) { // permet d'annuler le bouttons temps ou d'annuler les cases qui n'ont plus de bonus.
                    view.alpha = 0.5
                    view.isUserInteractionEnabled = false
                } else {
                    view.alpha = 1.0
                    view.isUserInteractionEnabled = true
                }
                label.text = String(number)
            }
        }
    }
    
    /*@objc public dynamic var progress: CGFloat = 1 {
        didSet {
            progressLayer.progress = progress
            if progress == 0 || progress == 1 {
                progressLayer.setNeedsDisplay()
            }
        }
    }
    
    fileprivate var progressLayer: BonusChoiceLayer {
        return layer as! BonusChoiceLayer
    }

    override public class var layerClass: AnyClass {
        return BonusChoiceLayer.self
    }
    
    override public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == #keyPath(BonusChoiceLayer.progress), let action = action(for: layer, forKey: #keyPath(backgroundColor)) as? CAAnimation {
            let animation = CABasicAnimation()
            animation.keyPath = #keyPath(BonusChoiceLayer.progress)
            animation.fromValue = progressLayer.progress
            animation.toValue = progress
            animation.beginTime = action.beginTime
            animation.duration = action.duration
            animation.speed = action.speed
            animation.timeOffset = action.timeOffset
            animation.repeatCount = action.repeatCount
            animation.repeatDuration = action.repeatDuration
            animation.autoreverses = action.autoreverses
            animation.fillMode = action.fillMode
            animation.timingFunction = action.timingFunction
            animation.delegate = action.delegate
            self.layer.add(animation, forKey: #keyPath(BonusChoiceLayer.progress))
        }
        return super.action(for: layer, forKey: event)
    }
    */
    
    /*
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let point = touches.first?.location(in: self)
        
        if (point!.x > 5/6*bounds.width && point!.x < bounds.width) || (point!.x > 0 && point!.x < bounds.width/6) {
            if progress == 1 {
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.scrollView?.alpha = 0
                }) { (_) in
                    self.scrollView?.removeFromSuperview()
                    UIView.animate(withDuration: 1.0, animations: {
                        self.progress = 0
                    })
                }
            } else {
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.progress = 1
                }, completion: { (_) in
                    self.addSubview(self.scrollView!)
                    self.scrollView!.alpha = 0
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.scrollView?.alpha = 1
                    }, completion: { (_) in
                        self.populateScrollView()
                    })
                })
                
            }
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if progress == 0 {
            if point.x > 0 && point.x < bounds.width/6 {
                if point.y > 0 && point.y < bounds.height {
                    return true
                }
            }
        } else if progress == 1 {
            if point.x > 0 && point.x < bounds.width {
                if point.y > 0 && point.y < bounds.height {
                    return true
                }
            }
        }
        
        return false
    }
    */
    
    // MARK: - Actions when bonus button are tapped
    
    func tempsTapped() { // il faut ajouter du temps
        if dataManager.tempsQuantity > 0 {
            dataManager.tempsQuantity -= 1
            self.updateTheNumberLabels()
            let timeLevel: Int = dataManager.tempsLevel
            let values: [CGFloat] = [15,30,45,60] // temps à rajouter
            viewOfGame!.gameTimer.counter -= values[timeLevel]
            
            let messageManager = LineMessageManager(viewToAddIn: self.parentViewController!.view, yOrigin: self.frame.origin.y - 50, timeOnScreen: 1.5, textColor: UIColor.gray)
            messageManager.showMessage("Ajout de \(values[timeLevel]) secondes")
        }
    }
    
    func drapeauTapped() { // il faut ajouter des drapeaux
        if dataManager.drapeauQuantity > 0 {
            dataManager.drapeauQuantity -= 1
            self.updateTheNumberLabels()
            let drapeauLevel = dataManager.drapeauLevel
            let messageManager = LineMessageManager(viewToAddIn: self.parentViewController!.view, yOrigin: self.frame.origin.y - 50, timeOnScreen: 1.5, textColor: UIColor.gray)
            switch drapeauLevel {
            case 0:
                viewOfGame!.numberOfRemainingFlags += 1
                messageManager.showMessage("Ajout de 1 drapeau")
            case 1:
                viewOfGame!.numberOfRemainingFlags += 1
                if random(2) == 0 {
                    viewOfGame!.numberOfRemainingFlags += 1
                    messageManager.showMessage("Ajout de 2 drapeaux")
                } else {
                    messageManager.showMessage("Ajout de 1 drapeau")
                }
            case 3:
                viewOfGame!.numberOfRemainingFlags += 2
                messageManager.showMessage("Ajout de 2 drapeaux")
            default:
                fatalError("Level incorrect")
            }
        }
    }
    
    func bombeTapped() { // il faut marquer des bombes
        if dataManager.bombeQuantity > 0
        {
            dataManager.bombeQuantity -= 1
            self.updateTheNumberLabels()
            let messageManager = LineMessageManager(viewToAddIn: self.parentViewController!.view, yOrigin: self.frame.origin.y - 50, timeOnScreen: 1.5, textColor: UIColor.gray)
            switch dataManager.bombeLevel {
            case 0:
                viewOfGame!.markARandomBomb()
                viewOfGame!.numberOfRemainingFlags -= 1
                messageManager.showMessage("1 bombe marquée")
            case 1:
                viewOfGame!.markARandomBomb()
                messageManager.showMessage("1 bombe marquée")
            case 2:
                viewOfGame!.markARandomBomb()
                if random(2) == 0 {
                    viewOfGame!.markARandomBomb()
                    messageManager.showMessage("2 bombes marquées")
                } else {
                    messageManager.showMessage("1 bombe marquée")
                }
            default:
                fatalError("Level incorrect")
            }
            
        }
    }
    
    func verificationTapped() { // il faut verifier les drapeaux posée
        if dataManager.verificationQuantity > 0 {
            dataManager.verificationQuantity -= 1
            viewOfGame!.verificationBonusFunc(yOriginForMessage: self.frame.origin.y - 50)
            delay(seconds: 0.26) {
                self.updateTheNumberLabels()
            }
        }
    }
    
}


















/*
class BonusChoiceLayer: CALayer {
    
    @NSManaged var progress: CGFloat
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(progress) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        UIGraphicsPushContext(ctx)
        let frame = CGRect(x: 2, y: 2, width: bounds.width - 4, height: bounds.height - 4)
        BonusChoiceProgress.drawBonusChoice(frame: frame, resizing: .aspectFill, progress: progress)
        UIGraphicsPopContext()
    }
     
}

public class BonusChoiceProgress : NSObject {
    
    //// Drawing Methods
    
    @objc dynamic public class func drawBonusChoice(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 600, height: 100), resizing: ResizingBehavior = .aspectFit, progress: CGFloat = 0) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 600, height: 100), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 600, y: resizedFrame.height / 100)
        
        /// Color Declarations
        let backgroundColorRuban: UIColor = bonusChoiceColor.backgroundColorRuban
        let starColor: UIColor = bonusChoiceColor.starColor
        let backgroundContainer: UIColor = bonusChoiceColor.backgroundContainer
        
        //// Variable Declarations
        let widthOfRuban: CGFloat = 100 + progress * 500
        let xPosOfStar: CGFloat = 10 + progress * 495
        let widthOfContainer: CGFloat = progress * 450
        let starRotation: CGFloat = -progress * 144
        let alpha: CGFloat = progress
        
        //// Ruban Drawing
        let rubanPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: widthOfRuban, height: 100), cornerRadius: 50)
        backgroundColorRuban.setStroke()
        rubanPath.lineWidth = 2
        rubanPath.stroke()
        
        
        //// Container Drawing
        context.saveGState()
        context.setAlpha(alpha)
        
        let containerPath = UIBezierPath(roundedRect: CGRect(x: 42, y: 7.5, width: widthOfContainer, height: 85), cornerRadius: 0.5)
        backgroundContainer.setFill()
        containerPath.fill()
        
        context.restoreGState()
        
        
        //// Star Drawing
        context.saveGState()
        context.translateBy(x: (xPosOfStar + 40), y: 50)
        context.rotate(by: -starRotation * CGFloat.pi/180)
        
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 0, y: -40))
        starPath.addLine(to: CGPoint(x: 11.74, y: -16.15))
        starPath.addLine(to: CGPoint(x: 38.04, y: -12.36))
        starPath.addLine(to: CGPoint(x: 18.99, y: 6.17))
        starPath.addLine(to: CGPoint(x: 23.51, y: 32.36))
        starPath.addLine(to: CGPoint(x: 0, y: 19.97))
        starPath.addLine(to: CGPoint(x: -23.51, y: 32.36))
        starPath.addLine(to: CGPoint(x: -18.99, y: 6.17))
        starPath.addLine(to: CGPoint(x: -38.04, y: -12.36))
        starPath.addLine(to: CGPoint(x: -11.74, y: -16.15))
        starPath.close()
        starColor.setFill()
        starPath.fill()
        
        context.restoreGState()
        
        context.restoreGState()
        
    }
    
    
    
    
    @objc(BonusChoiceProgressResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
*/
