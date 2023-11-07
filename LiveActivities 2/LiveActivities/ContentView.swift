//
//  ContentView.swift
//  LiveActivities
//
//  Created by Balaji on 28/07/22.
//

import SwiftUI
import WidgetKit
import ActivityKit

struct ContentView: View {
    // MARK: Updating Live Acitivity
    @State var currentID: String = ""
    @State var currentSelection: Status = .received
    var body: some View {
        NavigationStack{
            VStack{
                Picker(selection: $currentSelection) {
                    Text("Received")
                        .tag(Status.received)
                    Text("Progress")
                        .tag(Status.progress)
                    Text("Ready")
                        .tag(Status.ready)
                } label: {
                }
                .labelsHidden()
                .pickerStyle(.segmented)

                
                // MARK: Intializing Activity
                Button("Start Activity"){
                    addLiveActivity()
                }
                .padding(.top)
                
                // MARK: Removing Activity
                Button("Remove Activity"){
                    removeActivity()
                }
                .padding(.top)
            }
            .navigationTitle("Live Activities")
            .padding(15)
            // MARK: Updating Live Activity
            .onChange(of: currentSelection) { newValue in
                // Retreiving Current Activity From the List Of Phone Acitivites
                if let activity = Activity.activities.first(where: { (activity: Activity<OrderAttributes>) in
                    activity.id == currentID
                }){
                    print("Activity Found")
                    // Since I Need to Show Animation I'm Delaying Action For 2s
                    // For Demo Purpose
                    // In Real Case Scenairo Remove the Delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        var updatedState = activity.contentState
                        updatedState.status = currentSelection
                        Task{
                            await activity.update(using: updatedState)
                        }
                    }
                }
            }
        }
    }
    
    func removeActivity(){
        if let activity = Activity.activities.first(where: { (activity: Activity<OrderAttributes>) in
            activity.id == currentID
        }){
            // FOR DEMO PURPOSE
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                Task{
                    await activity.end(using: activity.contentState,dismissalPolicy: .immediate)
                }
            }
        }
    }
    
    // NOTE: We Need to Add Key In Info.plist File
    func addLiveActivity(){
        let orderAtrributes = OrderAttributes(orderNumber: 26383, orderItems: "Burger & Milk Shake")
        // Since It Dosen't Requires Any Intial Values
        // If Your Content State Struct Contains Intializers Then You Must Pass it here
        let intialContentState = OrderAttributes.ContentState()
        
        do{
            let activity = try Activity<OrderAttributes>.request(attributes: orderAtrributes, contentState: intialContentState,pushType: nil)
            // MARK: Storing CurrentID For Updating Activity
            currentID = activity.id
            print("Activity Added Successfully. id: \(activity.id)")
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
