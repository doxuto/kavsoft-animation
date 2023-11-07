//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 26/09/21.
//

import SwiftUI

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
    
    @State var titleText = ""
    @State var bodyText = ""
    // Fetch from Firestore in real time Usage...
    @State var deviceToken = ""
    
    var body: some View{
        
        NavigationView{
            
            List{
                
                Section {
                    TextField("", text: $titleText)
                } header: {
                    Text("Message Title")
                }
                
                Section {
                    TextField("", text: $bodyText)
                } header: {
                    Text("Message Body")
                }
                
                Section {
                    TextField("", text: $deviceToken)
                } header: {
                    Text("Device Token")
                }
                
                Button {
                    sendMessageToDevice()
                } label: {
                    Text("Send Push Notification")
                }


            }
            .listStyle(.insetGrouped)
            .navigationTitle("Push Notification")
        }
    }
    
    func sendMessageToDevice(){
        
        // Simple Logic
        // Using Firebase API to send Push Notification to another device using token
        // Without having server....
        
        // Converting That to URL Request Format....
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else{
            return
        }
        
        let json: [String: Any] = [
        
            "to": deviceToken,
            "notification": [
            
                "title": titleText,
                "body": bodyText
            ],
            "data": [
            
                // Data to be Sent....
                // Dont pass empty or remove the block..
                "user_name": "iJustine"
            ]
        ]
        
        
        // Use Your Firebase Server Key !!!
        let serverKey = ""
        
        // URL Request...
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // COnverting json Dict to JSON...
        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
        // Setting COntent Type and Authoritzation...
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Authorization key will be Your Server Key...
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        // Passing request using URL session...
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { _, _, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            // Else Success
            // CLearing Fields..
            // Or Your Action when message sends...
            print("Success")
            DispatchQueue.main.async {[self] in
                titleText = ""
                bodyText = ""
                deviceToken = ""
            }
        }
        .resume()
    }
}

// Note Push Notification will work only on Real Devices....
