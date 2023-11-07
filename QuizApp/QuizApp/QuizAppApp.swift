//
//  QuizAppApp.swift
//  QuizApp
//
//  Created by Balaji on 15/01/23.
//

import SwiftUI
import Firebase

@main
struct QuizAppApp: App {
    /// - Initializing Firebase
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
