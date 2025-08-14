//
//  ContentView.swift
//  FocusMode
//
//  Created by Tejeshwer Singh on 14/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showOverlay  = false
    @State private var focusTime    = "0"
    @State private var navPath      = [String]()
    @State private var showAlert    = false
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack(spacing: 20) {
                Text("Enter time for focus(in minutes): ")
                    .frame(alignment: .leading)
                
                TextField("Focus time", text: $focusTime)
                    .frame(width: 250)
                    .foregroundStyle(Color(uiColor: .label))
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.birthdateYear)
                
                Button {
                    self.showOverlay.toggle()
                    if Int(self.focusTime) != nil {
                        self.navPath = [NavigationViews.focusMode.rawValue]
                    } else {
                        self.showAlert.toggle()
                    }
                } label: {
                    Text("Start")
                        .padding(.horizontal, 50)
                        .padding()
                        .foregroundStyle(.black)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.green)
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .padding(.vertical, 20)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("FocusMode")
            .navigationDestination(for: String.self) { value in
                if value == NavigationViews.focusMode.rawValue {
                    if let time = Int(focusTime) {
                        let totalTime = CGFloat(time) * 60
                        FocusModeView(totalTime: totalTime)
                    }
                } else {
                    
                }
            }
        }
        .alert("Error",
               isPresented: $showAlert,
               actions: {
                    Button("Ok") {
                        self.showOverlay.toggle()
                    }
                },
               message: {
                    Text("Invalid input. Please enter correct time")
        })
    }
}

enum NavigationViews: String {
    case focusMode
    case relaxMode
}

#Preview {
    ContentView()
}
