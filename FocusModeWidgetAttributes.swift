//
//  FocusModeWidgetAttributes.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/11/25.
//

import ActivityKit
import SwiftUI

struct FocusModeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var timeRemaining: String
        var focusState: TimerMode
    }
    
    enum TimerMode: Codable, Hashable {
        case focus
        case shortBreak
        case longBreak
        
        var timerModeEmoji: some View {
            switch self {
            case .focus:
                return Image(systemName: "hourglass.and.lock")
            case .longBreak:
                return Image(systemName: "powersleep")
            case .shortBreak:
                return Image(systemName: "sleep")
            }
        }
        
        var timerModeColor: Color {
            switch self {
            case .focus: return .red
            case .shortBreak: return .yellow
            case .longBreak: return .green
            }
        }
    }
}
