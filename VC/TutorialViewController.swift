//
//  TutorialViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 27/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    // MARK: - Variables
    var button1: UIButton?
    var button2: UIButton?
    var button3: UIButton?
    var button4: UIButton?

    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uniquement un scroll vertical
        scrollView.contentSize.width = scrollView.bounds.width
        scrollView.contentSize.height = 2000
        
        
        addMenuButton()
        addTitleAndTiters()
        let endOfFirstPart = addTheFirstPart()
        addTheSecondPart(startintAt: endOfFirstPart+30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func addMenuButton() {
        let button = UIButton()
        button.setTitle("Menu", for: .normal)
        button.setTitleColor(colorForRGB(r: 94, g: 94, b: 94), for: .normal)
        button.addTarget(self, action: #selector(exitToMenu), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 22)
        button.frame = CGRect(x: 2, y: 10, width: 60, height: 40)
        self.scrollView.addSubview(button)
    }
    
    func addTitleAndTiters() {
        let titleLabel = UILabel()
        titleLabel.text = "key6".localized(lang: reglages.giveCurrentLanguage())
        titleLabel.font = UIFont(name: "PingFangSC-Thin", size: 50)
        titleLabel.textColor = colorForRGB(r: 66, g: 66, b: 66)
        titleLabel.frame = CGRect(x: 2, y: 60, width: 300, height: 70)
        self.scrollView.addSubview(titleLabel)
        
        let sommaireLabel = UILabel()
        sommaireLabel.text = "key7".localized(lang: reglages.giveCurrentLanguage())
        sommaireLabel.font = UIFont(name: "PingFangSC-Thin", size: 25)
        sommaireLabel.textColor = colorForRGB(r: 66, g: 66, b: 66)
        sommaireLabel.frame = CGRect(x: 2, y: 140, width: 400, height: 40)
        self.scrollView.addSubview(sommaireLabel)
        
        let line = LineView()
        line.isVertical = false
        line.frame = CGRect(x: 4, y: 180, width: self.scrollView.frame.width - 8, height: 0.5)
        line.strokeColor = UIColor.lightGray
        line.lineWidth = 1.0
        self.scrollView.addSubview(line)
        
        // Pour le somaire, il y a 4 parties différentes //
        // 1 - Le jeu
        // 2 - Les bonus
        // 3 - Les types de parties
        // 4 - Les modes de jeu
        
        let font = UIFont(name: "PingFangSC-Regular", size: 25)
        
        button1 = UIButton()
        button1!.titleLabel?.font = font
        button1!.setTitleColor(colorForRGB(r: 66, g: 66, b: 66), for: .normal)
        button1!.setTitle("key8".localized(lang: reglages.giveCurrentLanguage()), for: .normal)
        button1!.addTarget(self, action: #selector(button1Tapped), for: .touchUpInside)
        
        let w1 = "key8".localized(lang: reglages.giveCurrentLanguage()).width(withConstrainedHeight: 60, font: font!)
        button1!.frame = CGRect(x: 22, y: 190, width: w1, height: 40)
        self.scrollView.addSubview(button1!)
        
        button2 = UIButton()
        button2!.titleLabel?.font = font
        button2!.setTitleColor(colorForRGB(r: 66, g: 66, b: 66), for: .normal)
        button2!.setTitle("key9".localized(lang: reglages.giveCurrentLanguage()), for: .normal)
        button2!.addTarget(self, action: #selector(button2Tapped), for: .touchUpInside)
        let w2 = "key9".localized(lang: reglages.giveCurrentLanguage()).width(withConstrainedHeight: 60, font: font!)
        button2!.frame = CGRect(x: 22, y: 230, width: w2, height: 40)
        self.scrollView.addSubview(button2!)
        
        button3 = UIButton()
        button3!.titleLabel?.font = font
        button3!.setTitleColor(colorForRGB(r: 66, g: 66, b: 66), for: .normal)
        button3!.setTitle("key10".localized(lang: reglages.giveCurrentLanguage()), for: .normal)
        button3!.addTarget(self, action: #selector(button3Tapped), for: .touchUpInside)
        let w3 = "key10".localized(lang: reglages.giveCurrentLanguage()).width(withConstrainedHeight: 60, font: font!)
        button3!.frame = CGRect(x: 22, y: 270, width: w3, height: 40)
        self.scrollView.addSubview(button3!)
        
        button4 = UIButton()
        button4!.titleLabel?.font = font
        button4!.setTitleColor(colorForRGB(r: 66, g: 66, b: 66), for: .normal)
        button4!.setTitle("key11".localized(lang: reglages.giveCurrentLanguage()), for: .normal)
        button4!.addTarget(self, action: #selector(button4Tapped), for: .touchUpInside)
        let w4 = "key11".localized(lang: reglages.giveCurrentLanguage()).width(withConstrainedHeight: 60, font: font!)
        button4!.frame = CGRect(x: 22, y: 310, width: w4, height: 40)
        self.scrollView.addSubview(button4!)
        
        
    }
    
    /// Cette fonction ajoute les labels qu'il faut pour la partie "Le jeu" et retourne la valeur du dernier y, pour indiquer où doit commencer la deuxième partie.
    @discardableResult func addTheFirstPart() -> CGFloat {
        let y0: CGFloat = 370
        var lastY: CGFloat = y0

        // Titre "Le jeu"
        let gameLabel = UILabel()
        gameLabel.text = "key8bis".localized(lang: reglages.giveCurrentLanguage())
        gameLabel.font = UIFont(name: "PingFangSC-Thin", size: 25)
        gameLabel.textColor = colorForRGB(r: 66, g: 66, b: 66)
        gameLabel.frame = CGRect(x: 2, y: y0, width: 400, height: 40)
        self.scrollView.addSubview(gameLabel)
        
        let line = LineView()
        line.isVertical = false
        line.frame = CGRect(x: 4, y: y0+40, width: self.scrollView.frame.width - 8, height: 0.5)
        line.strokeColor = UIColor.lightGray
        line.lineWidth = 1.0
        self.scrollView.addSubview(line)
        
        let textFont = UIFont(name: "PingFangSC-Regular", size: 16)
        let y1 = y0 + 50
        
        // Premier paragraphe de texte
        let lbl1 = UILabel()
        lbl1.text = "key12".localized(lang: reglages.giveCurrentLanguage())
        lbl1.textColor = colorForRGB(r: 66, g: 66, b: 66)
        lbl1.font = textFont
        lbl1.numberOfLines = 0
        let h1 = "key12".localized(lang: reglages.giveCurrentLanguage()).height(withConstrainedWidth: self.scrollView.frame.width, font: textFont!)
        lbl1.frame = CGRect(x: 8, y: y1, width: self.scrollView.frame.width, height: h1)
        self.scrollView.addSubview(lbl1)
        
        // Première reponse
        let numberLbl1 = UILabel()
        numberLbl1.textColor = colorForRGB(r: 66, g: 66, b: 66)
        numberLbl1.text = "1."
        numberLbl1.frame = CGRect(x: 8, y: y1+h1+10, width: 10, height: 30)
        self.scrollView.addSubview(numberLbl1)
        
        let answerLbl1 = UILabel()
        answerLbl1.text = "key13".localized(lang: reglages.giveCurrentLanguage())
        answerLbl1.textColor = colorForRGB(r: 66+30, g: 66+30, b: 66+30)
        answerLbl1.font = textFont
        let w = "key13".localized(lang: reglages.giveCurrentLanguage()).width(withConstrainedHeight: 30, font: textFont!)
        answerLbl1.frame = CGRect(x: 28, y: y1+h1+10, width: w, height: 30)
        self.scrollView.addSubview(answerLbl1)
        
        // Deuxieme reponse
        let numberLbl2 = UILabel()
        numberLbl2.textColor = colorForRGB(r: 66, g: 66, b: 66)
        numberLbl2.text = "2."
        numberLbl2.frame = CGRect(x: 8, y: y1+h1+10+40, width: 10, height: 30)
        self.scrollView.addSubview(numberLbl2)
        
        let answerLbl2 = UILabel()
        answerLbl2.text = "key14".localized(lang: reglages.giveCurrentLanguage())
        answerLbl2.textColor = colorForRGB(r: 66, g: 66, b: 66)
        answerLbl2.font = textFont
        answerLbl2.numberOfLines = 0
        var h2 = "key14".localized(lang: reglages.giveCurrentLanguage()).height(withConstrainedWidth: self.scrollView.frame.width, font: textFont!)
        answerLbl2.frame = CGRect(x: 28, y: y1+h1+10+40, width: self.scrollView.frame.width, height: h2)
        self.scrollView.addSubview(answerLbl2)
        
        
        let y2 = y1+h1+10+40+h2+10
        
        // Header "Comment gagner ?"
        let header1Label = UILabel()
        header1Label.text = "key15".localized(lang: reglages.giveCurrentLanguage())
        header1Label.font = UIFont(name: "PingFangSC-Thin", size: 25)
        header1Label.textColor = colorForRGB(r: 66+30, g: 66+30, b: 66+30)
        header1Label.frame = CGRect(x: 2, y: y2, width: 400, height: 40)
        self.scrollView.addSubview(header1Label)
        
        // Deuxieme paragraphe de cette partie
        let lbl2 = UILabel()
        lbl2.text = "key16".localized(lang: reglages.giveCurrentLanguage())
        lbl2.textColor = colorForRGB(r: 66, g: 66, b: 66)
        lbl2.font = textFont
        lbl2.numberOfLines = 0
        h2 = "key16".localized(lang: reglages.giveCurrentLanguage()).height(withConstrainedWidth: self.scrollView.frame.width, font: textFont!)
        lbl2.frame = CGRect(x: 8, y: y2+40, width: self.scrollView.frame.width, height: h2)
        self.scrollView.addSubview(lbl2)
        
        let y3 = y2+40+h2+10
        
        // Troisième paragraphe de cette partie
        let lbl3 = UILabel()
        lbl3.text = "key17".localized(lang: reglages.giveCurrentLanguage())
        lbl3.textColor = colorForRGB(r: 66, g: 66, b: 66)
        lbl3.font = textFont
        lbl3.numberOfLines = 0
        let h3 = "key17".localized(lang: reglages.giveCurrentLanguage()).height(withConstrainedWidth: self.scrollView.frame.width, font: textFont!)
        lbl3.frame = CGRect(x: 8, y: y3, width: self.scrollView.frame.width, height: h3)
        self.scrollView.addSubview(lbl3)
        
        let y4 = y3 + h3
        
        // Header "Voisins des bombes"
        let header2Label = UILabel()
        header2Label.text = "key18".localized(lang: reglages.giveCurrentLanguage())
        header2Label.font = UIFont(name: "PingFangSC-Thin", size: 25)
        header2Label.textColor = colorForRGB(r: 66+30, g: 66+30, b: 66+30)
        header2Label.frame = CGRect(x: 2, y: y4, width: 400, height: 40)
        self.scrollView.addSubview(header2Label)
        
        // Quatrieme paragraphe de cette partie
        let lbl4 = UILabel()
        lbl4.text = "key19".localized(lang: reglages.giveCurrentLanguage())
        lbl4.textColor = colorForRGB(r: 66, g: 66, b: 66)
        lbl4.font = textFont
        lbl4.numberOfLines = 0
        let h4 = "key19".localized(lang: reglages.giveCurrentLanguage()).height(withConstrainedWidth: self.scrollView.frame.width, font: textFont!)
        lbl4.frame = CGRect(x: 8, y: y4 + 40, width: self.scrollView.frame.width, height: h4)
        self.scrollView.addSubview(lbl4)
        
        let y5 = y4 + 40 + h4 + 20
        
        // Vue qui contient les images à integrer
        let pictureView = UIView()
        pictureView.layer.borderColor = UIColor.red.cgColor
        pictureView.layer.borderWidth = 1.0
        pictureView.frame = CGRect(x: 8, y: y5, width: self.scrollView.frame.width-16, height: 160)
        self.scrollView.addSubview(pictureView)
        
        let y6 = y5 + pictureView.frame.height + 20
        
        lastY = y6
        
        return lastY
    }
    
    @discardableResult func addTheSecondPart(startintAt y0: CGFloat) -> CGFloat {
        var lastY: CGFloat = y0
        
        
        // Titre "Les bonus"
        let gameLabel = UILabel()
        gameLabel.text = "key9bis".localized(lang: reglages.giveCurrentLanguage())
        gameLabel.font = UIFont(name: "PingFangSC-Thin", size: 25)
        gameLabel.textColor = colorForRGB(r: 66, g: 66, b: 66)
        gameLabel.frame = CGRect(x: 2, y: y0, width: 400, height: 40)
        self.scrollView.addSubview(gameLabel)
        
        let line = LineView()
        line.isVertical = false
        line.frame = CGRect(x: 4, y: y0+40, width: self.scrollView.frame.width - 8, height: 0.5)
        line.strokeColor = UIColor.lightGray
        line.lineWidth = 1.0
        self.scrollView.addSubview(line)
        
        let textFont = UIFont(name: "PingFangSC-Regular", size: 16)

        
        // Premier paragraphe
        let y1 = y0 + 60
        let lbl1 = UILabel()
        lbl1.text = "key20".localized(lang: reglages.giveCurrentLanguage())
        lbl1.textColor = colorForRGB(r: 66, g: 66, b: 66)
        lbl1.font = textFont
        lbl1.numberOfLines = 0
        let h1 = "key20".localized(lang: reglages.giveCurrentLanguage()).height(withConstrainedWidth: self.scrollView.frame.width, font: textFont!)
        lbl1.frame = CGRect(x: 8, y: y1, width: self.scrollView.frame.width-8, height: h1)
        self.scrollView.addSubview(lbl1)
        
        // Deuxieme paragraphe
        let y2 = y1 + h1 + 10
        let lbl2 = UILabel()
        lbl2.text = "key21".localized(lang: reglages.giveCurrentLanguage())
        lbl2.textColor = colorForRGB(r: 66, g: 66, b: 66)
        lbl2.font = textFont
        lbl2.numberOfLines = 0
        let h2 = "key21".localized(lang: reglages.giveCurrentLanguage()).height(withConstrainedWidth: self.scrollView.frame.width, font: textFont!)
        lbl2.frame = CGRect(x: 8, y: y2, width: self.scrollView.frame.width-8, height: h2)
        self.scrollView.addSubview(lbl2)
        
        
        // Image de la bar de bonus
        let ybonus = y2 + h2 + 20
        let bonusView = UIView()
        bonusView.layer.borderColor = UIColor.red.cgColor
        bonusView.layer.borderWidth = 1.0
        bonusView.frame = CGRect(x: 8, y: ybonus, width: scrollView.frame.width - 16, height: 80)
        self.scrollView.addSubview(bonusView)
        
        lastY += 10
        return lastY
    }
    
    // MARK: - Fonctions des boutons
    
    @objc func exitToMenu() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func button1Tapped() {
        
        self.button1!.alpha = 0.5
        UIView.animateKeyframes(withDuration: 0.4, delay: 0.5, options: [], animations: {
            self.button1!.alpha = 1.0
        }) { (tmp) in
            // Faire le scroll ici
            
        }
    }
    
    @objc func button2Tapped() {
        self.button2!.alpha = 0.5
        UIView.animateKeyframes(withDuration: 0.4, delay: 0.5, options: [], animations: {
            self.button2!.alpha = 1.0
        }) { (tmp) in
            // Faire le scroll ici
            
        }    }
    
    @objc func button3Tapped() {
        self.button3!.alpha = 0.5
        UIView.animateKeyframes(withDuration: 0.4, delay: 0.5, options: [], animations: {
            self.button3!.alpha = 1.0
        }) { (tmp) in
            // Faire le scroll ici
            
        }
    }
    
    @objc func button4Tapped() {
        self.button4!.alpha = 0.5
        UIView.animateKeyframes(withDuration: 0.4, delay: 0.5, options: [], animations: {
            self.button4!.alpha = 1.0
        }) { (tmp) in
            // Faire le scroll ici
            
        }
    }
    
    
    
}
