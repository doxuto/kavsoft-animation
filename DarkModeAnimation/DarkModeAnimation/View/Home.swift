//
//  Home.swift
//  DarkModeAnimation
//
//  Created by Balaji Venkatesh on 05/10/23.
//

import SwiftUI

struct Home: View {
    @State private var activeTab: Int = 0
    /// Sample Toggle States
    @State private var toggles: [Bool] = Array(repeating: false, count: 10)
    var body: some View {
        /// Sample View
        TabView(selection: $activeTab) {
            NavigationStack {
                List {
                    Section("Text Section") {
                        Toggle("Show Sheet", isOn: $toggles[0])
                        Toggle("Bold Text", isOn: $toggles[1])
                    }
                    
                    Section {
                        Toggle("Night Light", isOn: $toggles[2])
                        Toggle("True Tone", isOn: $toggles[3])
                    } header: {
                        Text("Display Section")
                    } footer: {
                        Text("This is a Sample Footer.")
                    }
                }
                .navigationTitle("Dark Mode")
                .sheet(isPresented: $toggles[0]) {
                    DarkModeButton()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding()
                        .presentationDetents([.medium, .large, .height(100)])
                }
            }
            .tag(0)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            Text("Setting's")
                .tag(1)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .overlay(alignment: .topTrailing) {
            DarkModeButton()
                .padding()
        }
    }
}

#Preview {
    Home()
}
