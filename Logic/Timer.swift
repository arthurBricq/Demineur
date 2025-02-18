//
//  MyTimerHandlerObject.swift
//  03-@selector - TIMER CALLBACK
//

import Foundation
import UIKit



/**
 This timer is a waiter : it waits exactly the amount of time "limit" and then calls the method of the delegate named 'timeLimitReached(id: String)'
 */
class LimitedTimer: NSObject {
    var timer = Timer()
    var delegate: LimitedTimerProtocol?
    var id: String = ""
    
    var isRunning: Bool = false
    var isPaused: Bool = false
    
    private var timeLeftWhenPaused: TimeInterval = 0
    
    @objc func timerAction() {
        delegate?.timeLimitReached(id: id)
    }
    
    /// Lance le timer, appelle son delegate à la fin de la limite
    func start(limit: TimeInterval, id: String) {
        isRunning = true
        self.id = id
        self.timer = Timer.scheduledTimer(timeInterval: limit, target: self, selector: #selector(CountingTimer.timerAction), userInfo: nil, repeats: false)
    }
    
    /// Arrete le timer
    func stop() {
        isRunning = false
        isPaused = false
        id = ""
        timeLeftWhenPaused = 0
        timer.invalidate()
    }
    
    /// Met le timer en pause, s'il est en marche
    func pause() {
        if isRunning && !isPaused {
            isPaused = true
            timeLeftWhenPaused = timer.fireDate.timeIntervalSinceNow
            timer.invalidate()
        }
    }
    
    /// Relance le timer s'il était en pause
    func play() {
        if isPaused {
            isPaused = false
            timer = Timer.scheduledTimer(timeInterval: timeLeftWhenPaused, target: self, selector: #selector(CountingTimer.timerAction), userInfo: nil, repeats: false)
            timeLeftWhenPaused = 0
        }
    }
}
