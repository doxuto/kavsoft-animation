//
//  Task_ManagementApp.swift
//  Task Management
//
//  Created by Balaji on 07/07/23.
//

import SwiftUI

@main
struct Task_ManagementApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Task.self)
    }
}
