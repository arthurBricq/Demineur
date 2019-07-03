//
//  ReglageViewController.swift
//  Demineur
//
//  Created by Arthur BRICQ on 24/08/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit

class ReglageViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK - Outlets
    @IBOutlet weak var vibrationChecker: CheckerButton!
    @IBOutlet weak var musicChecker: CheckerButton!
    @IBOutlet weak var effectChecker: CheckerButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var labelsCollection: [UILabel]!
    @IBOutlet weak var timeButton: NiceButton!
    @IBOutlet weak var languageButton: NiceButton!
    @IBOutlet var secondaryLineCollection: [LineView]!
    @IBOutlet weak var mainLine: LineView!
    
    
    // MARK: - Modele de données
    var allTimes: [String]?
    var allLanguages: [String]?
    
    

    // MARK: - Actions
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func vibrationCheckerTapped(_ sender: Any) {
        self.vibrationChecker.isChecked = !self.vibrationChecker.isChecked
        dataManager.isVibrationOn = !dataManager.isVibrationOn
    }
    
    
    @IBAction func musicCheckerTapped(_ sender: Any) {
        self.musicChecker.isChecked = !self.musicChecker.isChecked
        dataManager.isMusicOn = !dataManager.isMusicOn
        if dataManager.isMusicOn == false {
            musicPlayer!.stop()
        } else if dataManager.isMusicOn == true {
            playMusic()
        }
    }
    
    
    @IBAction func effectCheckerTapped(_ sender: Any) {
        self.effectChecker.isChecked = !self.effectChecker.isChecked
        dataManager.areEffectsOn = !dataManager.areEffectsOn
    }
    
    
    @IBAction func timeButtonTapped(_ sender: Any) {
        Vibrate().vibrate(style: .light)
        dataManager.timeToMantainIterator += (dataManager.timeToMantainIterator != allTimes!.count-1) ? 1 : -(allTimes!.count-1)
        updateView()
    }
    
    
    @IBAction func languageButtonTapped(_ sender: Any) {
        Vibrate().vibrate(style: .light)
        dataManager.languageIterator += (dataManager.languageIterator != allLanguages!.count-1) ? 1 : -(allLanguages!.count-1)
        updateView()
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Actualiser le modèle de donnée
        allTimes = UserDefaultsManager.allTimesToMantain
        allLanguages = UserDefaultsManager.allLanguages
        updateView()
        
        setColors()
    }
    
    func setColors() {
        self.view.backgroundColor = Color.getColor(index: 0)
        menuButton.setTitleColor(Color.getColor(index: 3), for: .normal)
        
        titleLabel.textColor = Color.getColor(index: 2)
        titleLabel.setNeedsDisplay()
        mainLine.strokeColor = Color.getColor(index: 1)
        mainLine.setNeedsDisplay()
        vibrationChecker.strokeColor = Color.getColor(index: 2)
        vibrationChecker.setNeedsDisplay()
        musicChecker.strokeColor = Color.getColor(index: 2)
        musicChecker.setNeedsDisplay()
        effectChecker.strokeColor = Color.getColor(index: 2)
        effectChecker.setNeedsDisplay()
        
        for label in labelsCollection {
            label.textColor = Color.getColor(index: 3)
            label.setNeedsDisplay()
            print(label)
        }
        for line in secondaryLineCollection {
            line.strokeColor = Color.getColor(index: 2)
            line.setNeedsDisplay()
        }
        
        timeButton.color = Color.getColor(index: 2)
        timeButton.textColor = Color.getColor(index: 2)
        languageButton.color = Color.getColor(index: 2)
        languageButton.textColor = Color.getColor(index: 2)
    }

    func updateView() {
        self.effectChecker.isChecked = dataManager.areEffectsOn
        self.musicChecker.isChecked = dataManager.isMusicOn
        self.vibrationChecker.isChecked = dataManager.isVibrationOn
        timeButton.text = allTimes![dataManager.timeToMantainIterator]
        languageButton.text = allLanguages![dataManager.languageIterator].uppercased()
    }

}
