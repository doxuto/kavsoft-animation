//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 30/09/21.
//

import SwiftUI
import Firebase
import WidgetKit

struct ContentView: View {
    var body: some View {

        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View{
    
    // Log Status
    @AppStorage("log_status") var status = false
    
    var body: some View{
        
        NavigationView{
            
            VStack(spacing: 15){
                
                if status{
                    
                    // Showing log out BUtton...
                    Text("Logged In")
                    
                    Button("LogOut"){
                        try? Auth.auth().signOut()
                        status = false
                        WidgetCenter.shared.reloadAllTimelines()

                    }
                }
                else{
                    
                    // Login BUtton...
                    Text("Logged Out")
                    
                    Button("LogIn"){

                        // Logging in
                        Auth.auth().signIn(withEmail: "test@kavsoft.dev", password: "123456") { _, err in
                            if let error = err{
                                print(error.localizedDescription)
                                return
                            }
                            
                            self.status = true
                            WidgetCenter.shared.reloadAllTimelines()

                        }
                    }
                }
            }
            .navigationTitle("Firebase Widgets")
            .animation(.easeInOut, value: status)
        }
    }
}

// Creating Widget....
