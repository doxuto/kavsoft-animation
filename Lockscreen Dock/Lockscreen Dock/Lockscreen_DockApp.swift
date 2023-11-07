//
//  Lockscreen_DockApp.swift
//  Lockscreen Dock
//
//  Created by Balaji on 10/12/22.
//

import SwiftUI

@main
struct Lockscreen_DockApp: App {
    @Environment(\.openURL) var openURL
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Simply Pass the URL
                    openURL(url)
                }
        }
    }
}
