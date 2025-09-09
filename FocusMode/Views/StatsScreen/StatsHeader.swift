//
//  StatsHeader.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 09/09/25.
//

import SwiftUI

struct StatsHeader: View {
    var body: some View {
        Section("Summary") {
            HStack {
                Text("Time focused today: ")
                Spacer()
                Text("5hr")
            }
            
            HStack {
                Text("Sessions Completed: ")
                Spacer()
                Text("10")
            }
            
            HStack {
                Text("Sessions Abandoned: ")
                Spacer()
                Text("2")
            }
            
            HStack {
                Text("Current Streak: ")
                Spacer()
                Text("5 Days")
            }
        }
    }
}

#Preview {
    StatsHeader()
}
