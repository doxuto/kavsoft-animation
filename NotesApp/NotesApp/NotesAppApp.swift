//
//  NotesAppApp.swift
//  NotesApp
//
//  Created by Balaji Venkatesh on 23/10/23.
//

import SwiftUI

@main
struct NotesAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                /// Setting Min Frame
                .frame(minWidth: 320, minHeight: 400)
        }
        .windowResizability(.contentSize)
        /// Adding Data Model to the App
        .modelContainer(for: [Note.self, NoteCategory.self])
    }
}
