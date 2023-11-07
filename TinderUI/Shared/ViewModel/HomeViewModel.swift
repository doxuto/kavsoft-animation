//
//  HomeViewModel.swift
//  TinderUI (iOS)
//
//  Created by Balaji on 07/12/21.
//

import SwiftUI

// View model and it holds all user data...

class HomeViewModel: ObservableObject {
    
    // Store All the fetched Users here...
    // Since we're building UI so using sample Users here....
    @Published var fetched_users: [User] = []
    
    @Published var displaying_users: [User]?
    
    init(){
        
        // fetching users...
        fetched_users = [
        
            User(name: "Natalia", place: "Vadalia NYC", profilePic: "User1"),
            User(name: "Elisa", place: "Central Park NYC", profilePic: "User2"),
            User(name: "Jasmine", place: "Metropolitan Museum NYC", profilePic: "User3"),
            User(name: "Zahra", place: "Liberty NYC", profilePic: "User4"),
            User(name: "Angelina", place: "Empier State NYC", profilePic: "User5"),
            User(name: "Brittany", place: "Time Square NYC", profilePic: "User6")
        ]
        
        // storing it in displaying users..
        // what is displaying users?
        // it will be updated/removed based on user interaction to reduce memory usage...
        // and the same time we need all the fetched users data....
        displaying_users = fetched_users
    }
    
    // retreiving index...
    func getIndex(user: User)->Int{
        
        let index = displaying_users?.firstIndex(where: { currentUser in
            return user.id == currentUser.id
        }) ?? 0
        
        return index
    }
}
