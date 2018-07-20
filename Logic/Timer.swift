//
//  MyTimerHandlerObject.swift
//  03-@selector - TIMER CALLBACK
//

import Foundation
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
        counter += CGFloat(timeInterval)
        delegate?.timerFires(id: id)
    }
    
    /// Lance le timer avec un temps d'intervalle
    func start(timeInterval: TimeInterval, id: String) {
        isRunning = true
        counter = 0
        self.timeInterval = timeInterval
        self.id = id
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(CountingTimer.timerAction), userInfo: nil, repeats: true)
    }
    
    /// Arrete le timer et retourne le temps final
    @discardableResult func stop() -> CGFloat {
        isRunning = false
        let toRet = counter
        timer.invalidate()
        counter = 0
        id = ""
        return toRet
    }
    
    /// Met le timer en pause
    func pause() {
        timer.invalidate()
        isPaused = true
    }
    
    /// Relance le timer s'il est en pause
    func play() {
        if isPaused && isRunning {
            isPaused = false
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(CountingTimer.timerAction), userInfo: nil, repeats: true)
        }
    }
}


/**
 This timer is a waiter : it waits exactly the amount of time "limit" and then calls the method of the delegate named 'timeLimitReached(id: String)'
 */
class LimitedTimer: NSObject {
    var timer = Timer()
    var delegate: LimitedTimerProtocol?
    var id: String = ""
    
    @objc func timerAction() {
        delegate?.timeLimitReached(id: id)
    }
    
    /// Lance le timer, appelle son delegate à la fin de la limite
    func start(limit: TimeInterval, id: String) {
        self.id = id
        self.timer = Timer.scheduledTimer(timeInterval: limit, target: self, selector: #selector(CountingTimer.timerAction), userInfo: nil, repeats: false)
    }
    
    /// Arrete le timer
    func stop() {
        id = ""
        timer.invalidate()
    }
}
