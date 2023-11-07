//
//  SocialMediaApp.swift
//  SocialMedia
//
//  Created by Balaji on 07/12/22.
//

import SwiftUI
import Firebase

@main
struct SocialMediaApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
