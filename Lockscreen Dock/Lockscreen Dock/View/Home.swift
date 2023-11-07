//
//  Home.swift
//  Lockscreen Dock
//
//  Created by Balaji on 10/12/22.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct Home: View {
    // MARK: Added Shortcuts Data
    @State var addedShortcuts: [AppLink] = []
    @State var availableAppLinks: [AppLink] = []
    var body: some View {
        List{
            Section {
                // MARK: Displaying Preview
                // Which will be almost same as the Lockscreen Dock Live Activity
                HStack(spacing: 0){
                    ForEach(addedShortcuts){link in
                        Image(link.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                withAnimation(.easeInOut){
                                    addedShortcuts.removeAll(where: {$0 == link})
                                }
                            }
                    }
                }
                .frame(height: 85)
            } header: {
                Text("Preview")
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15){
                        ForEach(availableAppLinks.filter({!addedShortcuts.contains($0)})){link in
                            VStack(spacing: 8){
                                Image(link.name)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                
                                Text(link.name)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if !addedShortcuts.contains(link){
                                    withAnimation(.easeInOut){
                                        addedShortcuts.append(link)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 100)
                    .padding(.horizontal,10)
                }
                // MARK: We're Only Allowing max of 4 Apps on the Dock
                // So Disabling it when the count exceeds 4
                .disabled(addedShortcuts.count >= 4)
                .opacity(addedShortcuts.count >= 4 ? 0.6 : 1)
            } header: {
                Text("Tap to add shortcut")
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            Button(action: removeExistingDock){
                HStack{
                    Text("Add Lockscreen Dock")
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Image(systemName: "dock.rectangle")
                }
            }
            // MARK: Minimum 2 Apps Needed to add Dock to Lockscreen
            .disabled(addedShortcuts.count < 2)
            .opacity(addedShortcuts.count < 2 ? 0.6 : 1)
        }
        .onAppear {
            // MARK: Checking Which App's are Available in the User's iPhone
            // And Updating AppLink Model based on that so that unavailable apps won't appear on the Home Screen
            for link in appLinks{
                if let url = URL(string: link.deepLink){
                    if UIApplication.shared.canOpenURL(url){
                        // Available On the iPhone
                        var updatedLink = link
                        updatedLink.appURL = url
                        availableAppLinks.append(updatedLink)
                    }
                    // Else App Not Found on the iPhone
                }
                // Else Invalid URL
            }
        }
    }
    
    func addDocktoLockScreen(){
        // MARK: Live Activity Code Goes Here
        
        // Step 1: Creating Live Activity Attribute
        let activityAttribute = DockAttributes(name: "LockScreen Dock", addedLinks: addedShortcuts)
        // Step 2: Creating Content State for the Live Activity Attribute
        let initialContentState = DockAttributes.ContentState()
        // Step 3: Adding Live activity to the Lock Screen
        do{
            // Step 4: Creating Activity
            let activity = try Activity<DockAttributes>.request(attributes: activityAttribute, contentState: initialContentState)
            print("Activity Added \(activity.id)")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func removeExistingDock(){
        Task{
            for activity in Activity<DockAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
            addDocktoLockScreen()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
