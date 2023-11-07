//
//  FloatingWindowApp.swift
//  FloatingWindow
//
//  Created by Balaji on 25/01/23.
//

import SwiftUI

@main
struct FloatingWindowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
