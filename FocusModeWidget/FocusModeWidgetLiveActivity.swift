//
//  FocusModeWidgetLiveActivity.swift
//  FocusModeWidget
//
//  Created by Tejeshwer Singh on 09/11/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FocusModeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FocusModeWidgetAttributes.self) { context in
            VStack {
                HStack {
                    context.state.focusState.timerModeEmoji
                    Text("\(context.state.timeRemaining)")
                }
                
                Button {
                    
                } label: {
                    Text("Abandon Session")
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    context.state.focusState.timerModeEmoji
                        .foregroundStyle(context.state.focusState.timerModeColor)
                        .padding(.leading)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.timeRemaining)")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Button {
                        
                    } label: {
                        Text("Abandon Session")
                    }
                }
            } compactLeading: {
                context.state.focusState.timerModeEmoji
                    .foregroundStyle(context.state.focusState.timerModeColor)
            } compactTrailing: {
                Text("\(context.state.timeRemaining)")
            } minimal: {
                Text(context.state.timeRemaining)
                    .foregroundStyle(context.state.focusState.timerModeColor)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
        }
    }
}

extension FocusModeWidgetAttributes {
    fileprivate static var preview: FocusModeWidgetAttributes {
        FocusModeWidgetAttributes()
    }
}

extension FocusModeWidgetAttributes.ContentState {
    fileprivate static var smiley: FocusModeWidgetAttributes.ContentState {
        FocusModeWidgetAttributes.ContentState(timeRemaining: "1m", focusState: .focus)
     }
     
     fileprivate static var starEyes: FocusModeWidgetAttributes.ContentState {
         FocusModeWidgetAttributes.ContentState(timeRemaining: "1m", focusState: .shortBreak)
     }
}

#Preview("Notification", as: .content, using: FocusModeWidgetAttributes.preview) {
   FocusModeWidgetLiveActivity()
} contentStates: {
    FocusModeWidgetAttributes.ContentState.smiley
    FocusModeWidgetAttributes.ContentState.starEyes
}
