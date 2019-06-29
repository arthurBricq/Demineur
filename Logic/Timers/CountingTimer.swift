//
//  CountingTimer.swift
//  Demineur
//
//  Created by Arthur BRICQ on 17/11/2018.
//  Copyright © 2018 Arthur BRICQ. All rights reserved.
//

import UIKit


/**
 This timer is a clock : you give it a time interval and it calls the function each time interval for you, and also call the delegate method 'timerFires(id: String)'
 */
class CountingTimer: NSObject {
    
    var timer = Timer()
    var counter: CGFloat = 0 {
        didSet {
            if counter < 0 {
                counter = 0
            }
        }
    }
    var timeInterval: TimeInterval = 1
    var delegate: CountingTimerProtocol?
    var id: String = ""
    var isPaused: Bool = false
    var isRunning: Bool = false
    
    @objc func timerAction() {
        //print("action of \(id)")
        counter += CGFloat(timeInterval)
        delegate?.timerFires(id: id)
    }
    
    /// Lance le timer avec un temps d'intervalle
    func start(timeInterval: TimeInterval, id: String) {
        //print("start \(id)")
        isRunning = true
        counter = 0
        self.timeInterval = timeInterval
        self.id = id
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(CountingTimer.timerAction), userInfo: nil, repeats: true)
    }
    
    /// Arrete le timer et retourne le temps final
    @discardableResult func stop() -> CGFloat {
        //print("stop \(id)")
        isRunning = false
        isPaused = false
        let toRet = counter
        timer.invalidate()
        counter = 0
        id = ""
        return toRet
    }
    
    /// Met le timer en pause, s'il est en marche
    func pause() {
        //print("trying to pause \(id)")
        if isRunning {
            //print("pausing \(id)")
            timer.invalidate()
            isPaused = true
        }
    }
    
    /// Relance le timer s'il est en pause
    func play() {
        //print("play \(id)")
        if isPaused && isRunning {
            isPaused = false
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(CountingTimer.timerAction), userInfo: nil, repeats: true)
        }
    }
}
