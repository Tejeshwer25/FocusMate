//
//  TabBarViewController.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 17/08/25.
//

import SwiftUI

struct TabBarViewController: View {
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "house.fill") {
                DashboardView()
            }
            
            Tab("Statistics", systemImage: "chart.bar.xaxis") {
                StatsContainerView()
            }
        }
    }
}

#Preview {
    TabBarViewController()
}
