//
//  CursorGlowApp.swift
//  Shared
//
//  Created by Balaji on 29/04/22.
//

import SwiftUI

@main
struct CursorGlowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // MARK: Hiding Title Bar
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
