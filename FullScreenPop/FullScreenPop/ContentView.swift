//
//  ContentView.swift
//  FullScreenPop
//
//  Created by Balaji Venkatesh on 06/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isEnabled: Bool = false
    var body: some View {
        /// Sample View
        FullSwipeNavigationStack {
            List {
                Section("Sample Header") {
                    NavigationLink("Full Swipe View") {
                        List {
                            Toggle("Enable Full Swipe Pop", isOn: $isEnabled)
                        }
                        .navigationTitle("Full Swipe View")
                        .enableFullSwipePop(isEnabled)
                    }
                    
                    NavigationLink("Leading Swipe View") {
                        Text("")
                            .navigationTitle("Leading Swipe View")
                    }
                }
            }
            .navigationTitle("Full Swipe Pop")
        }
    }
}

#Preview {
    ContentView()
}
