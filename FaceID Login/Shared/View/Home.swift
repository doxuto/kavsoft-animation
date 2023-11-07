//
//  Home.swift
//  FaceID Login
//
//  Created by Balaji on 01/01/22.
//

import SwiftUI
import Firebase

struct Home: View {
    // Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    // MARK: FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false

    @KeyChain(key: "use_face_email",account: "FaceIDLogin") var storedEmail
    @KeyChain(key: "use_face_password",account: "FaceIDLogin") var storedPassword
    
    var body: some View {
        
        VStack(spacing: 20){
            
            if logStatus{
                Text("Logged In")
                
                Button("Logout"){
                    try? Auth.auth().signOut()
                    logStatus = false
                }
            }
            else{
                Text("Came as Guest")
            }
            
            if useFaceID{
                // Clearing Face ID
                Button("Disable Face ID"){
                    useFaceID = false
                    storedEmail = nil
                    storedPassword = nil
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Home")
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
