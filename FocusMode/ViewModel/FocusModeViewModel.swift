//
//  FocusModeViewModel.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 19/08/25.
//

import SwiftUI

class FocusModeViewModel: ObservableObject {
    @Published private var timeRemaining: CGFloat
    private var startTime: Date? {
        didSet {
            self.saveStartTime(startTime)
        }
    }
    
    init() {
        self.timeRemaining = 0
        
        if let startTime = self.getStartTime() {
            self.startTime = startTime
        }
    }
    
    /// Method to calculate and return remaining time
    /// - Returns: time remaining
    func getTimeRemaining() -> CGFloat {
        return self.timeRemaining
    }
    
    /// Method to get time remaining
    /// - Returns: time remaining
    func calculateTimeRemaining() {
        let startTime = self.startTime
        let now = Date()
        let timeInterval = now.timeIntervalSince(startTime ?? now)
        self.timeRemaining = 60 - CGFloat(timeInterval)
    }
    
    /// Method to add start time to user defaults
    /// - Parameter startTime: start time before app foes into backfround
    func saveStartTime(_ startTime: Date?) {
        if let startTime {
            UserDefaults.standard.set(startTime, forKey: "startTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "startTime")
        }
    }
    
    /// Method to get timer start time from user defaults
    /// - Returns: start time
    func getStartTime() -> Date? {
        return UserDefaults.standard.object(forKey: "startTime") as? Date
    }
}
