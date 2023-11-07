//
//  ExpenseTrackerAppApp.swift
//  ExpenseTrackerApp
//
//  Created by Balaji Venkatesh on 03/09/23.
//

import SwiftUI

@main
struct ExpenseTrackerAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        /// Setting Up the Container
        .modelContainer(for: [Expense.self, Category.self])
    }
}
