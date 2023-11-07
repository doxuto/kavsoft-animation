//
//  Profile.swift
//  ComplexMatchedGeometryEffect (iOS)
//
//  Created by Balaji on 01/06/22.
//

import SwiftUI

// MARK: Profile Model and Sample Data
struct Profile: Identifiable {
    var id = UUID().uuidString
    var userName: String
    var profilePicture: String
    var lastMsg: String
    var lastActive: String
}

var profiles = [
    Profile(userName: "iJustine", profilePicture: "Pic1", lastMsg: "Hi Kavsoft !!!", lastActive: "10:25 PM"),
    Profile(userName: "Jenna Ezarik", profilePicture: "Pic2", lastMsg: "No March Event🥲", lastActive: "06:25 AM"),
    Profile(userName: "Kaviya", profilePicture: "Pic6", lastMsg: "What's Up 🥳🥳🥳", lastActive: "11:25 AM"),
    Profile(userName: "Emily", profilePicture: "Pic3", lastMsg: "Need to Record Doumentation", lastActive: "10:25 PM"),
    Profile(userName: "Julie", profilePicture: "Pic4", lastMsg: "Simply Sitting", lastActive: "10:25 PM"),
    Profile(userName: "Steve", profilePicture: "Pic5", lastMsg: "Lying :(((((", lastActive: "10:25 PM"),
]
