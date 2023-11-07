//
//  MultiWindowAppApp.swift
//  MultiWindowApp
//
//  Created by Balaji on 01/11/22.
//

import SwiftUI

@main
struct MultiWindowAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        // MARK: macOS 13+ API
        .commandsRemoved()
        .windowResizability(.contentSize)
        
        // MARK: Multi-Tab Window Group
        WindowGroup(id: "New Tab", for: Tab.self) { $tab in
            NewTabView(tab: tab, isRootView: false)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
