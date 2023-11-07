//
//  ContentView.swift
//  DynamicIslandAnimation
//
//  Created by Balaji on 10/09/22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        Text("In App Push Notifications\nUsing Dynamic Island")
            .font(.title)
            .fontWeight(.semibold)
            .lineSpacing(12)
            .kerning(1.1)
            .multilineTextAlignment(.center)
            .onAppear(perform: authorizeNotifications)
    }
    
    // MARK: Notification Request
    func authorizeNotifications(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { _, _ in
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
