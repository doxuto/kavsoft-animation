//
//  WidgetsFirebaseApp.swift
//  Shared
//
//  Created by Balaji on 30/09/21.
//

import SwiftUI
// Intializing Firebase
import Firebase

@main
struct WidgetsFirebaseApp: App {
    
    init(){
        FirebaseApp.configure()
        do{
        
            try Auth.auth().useUserAccessGroup("\(teamID).com.kavsoft.WidgetsFirebase")
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
