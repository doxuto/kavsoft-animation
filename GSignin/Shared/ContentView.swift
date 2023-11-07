//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 07/11/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
    @AppStorage("log_Status") var log_Status = false
    var body: some View {

        if log_Status{
            
            // Your Home View...
            
            NavigationView{
                VStack(spacing: 15){
                    Text("Logged In")
                    
                    Button("Logout"){
                        
                        GIDSignIn.sharedInstance.signOut()
                        try? Auth.auth().signOut()
                        
                        withAnimation{
                            log_Status = false
                        }
                    }
                }
            }
        }
        else{
            
            LoginPage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
