//
//  DashboardSessionInfo.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 30/08/25.
//

import SwiftUI

struct DashboardSessionInfo: View {
    @State var sessioninfo: UserTaskModel
    
    var body: some View {
        HStack {
            Text(sessioninfo.type.getEmojiForType())
            Text(sessioninfo.taskName)
            
            Spacer()
            
            Text("\(String(format: "%.2f", Double(sessioninfo.timeCompleted))) / \(String(format: "%.2f", Double(sessioninfo.timeAlloted)))")
        }
    }
}

#Preview {
    let userTaskModel = UserTaskModel(taskName: "Test", type: .chores, timeAlloted: 40.0)
    DashboardSessionInfo(sessioninfo: userTaskModel)
}
