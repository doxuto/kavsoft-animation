//
//  StatusBarUpdateApp.swift
//  StatusBarUpdate
//
//  Created by Balaji Venkatesh on 03/10/23.
//

import SwiftUI

@main
struct StatusBarUpdateApp: App {
    var body: some Scene {
        WindowGroup {
            StatusBarView {
                ContentView()
            }
        }
    }
}
