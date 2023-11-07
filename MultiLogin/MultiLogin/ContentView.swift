//
//  ContentView.swift
//  MultiLogin
//
//  Created by Balaji on 20/08/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        if logStatus{
            // MARK: YOUR HOME VIEW
            DemoHome()
        }else{
            Login()
        }
    }
    
    @ViewBuilder
    func DemoHome()->some View{
        NavigationStack{
            Text("Logged In")
                .navigationTitle("Multi-Login")
                .toolbar {
                    ToolbarItem{
                        Button("Logout"){
                            try? Auth.auth().signOut()
                            GIDSignIn.sharedInstance.signOut()
                            withAnimation(.easeInOut){
                                logStatus = false
                            }
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
