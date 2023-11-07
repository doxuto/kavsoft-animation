//
//  NotesMacOSApp.swift
//  Shared
//
//  Created by Balaji on 05/10/21.
//

import SwiftUI

@main
struct NotesMacOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Hiding Title Bar...
        // Use XCode 13....
        // The app will work for macOS 11,12
        // iOS 14,15..
        #if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}

// Hiding Focus Ring...
#if os(macOS)
extension NSTextField{
    open override var focusRingType: NSFocusRingType{
        get{.none}
        set{}
    }
}
#endif
