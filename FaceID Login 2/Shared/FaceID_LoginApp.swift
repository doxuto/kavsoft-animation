//
//  FaceID_LoginApp.swift
//  Shared
//
//  Created by Balaji on 01/01/22.
//

import SwiftUI
import Firebase

@main
struct FaceID_LoginApp: App {
    // MARK: Intialize Firebase
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
