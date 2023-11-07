//
//  Profile.swift
//  NavigationHeroAnimation
//
//  Created by Balaji on 20/07/23.
//

import SwiftUI

/// Sample Profile Model
struct Profile: Identifiable {
    var id = UUID().uuidString
    var userName: String
    var profilePicture: String
    var lastMsg: String
    var lastActive: String
}

/// Sample Profile Data
var profiles = [
    Profile(userName: "iJustine", profilePicture: "Pic1", lastMsg: "Hi Kavsoft !!!", lastActive: "10:25 PM"),
    Profile(userName: "Jenna Ezarik", profilePicture: "Pic2", lastMsg: "Nothing!", lastActive: "06:25 AM"),
    Profile(userName: "Emily", profilePicture: "Pic3", lastMsg: "Binge Watching...", lastActive: "10:25 PM"),
    Profile(userName: "Julie", profilePicture: "Pic4", lastMsg: "404 Page not Found!", lastActive: "10:25 PM"),
    Profile(userName: "Kaviya", profilePicture: "Pic5", lastMsg: "Do not Disturb.", lastActive: "10:25 PM"),
]
