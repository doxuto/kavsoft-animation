//
//  Profile.swift
//  ProgressHeroEffect
//
//  Created by Balaji Venkatesh on 13/10/23.
//

import SwiftUI

/// Profile Model With Sample Data
struct Profile: Identifiable {
    var id = UUID()
    var userName: String
    var profilePicture: String
    var lastMsg: String
}

var profiles = [
    Profile(userName: "iJustine", profilePicture: "Pic1", lastMsg: "Hi Kavsoft !!!"),
    Profile(userName: "Jenna Ezarik", profilePicture: "Pic2", lastMsg: "Nothing!"),
    Profile(userName: "Emily", profilePicture: "Pic3", lastMsg: "Binge Watching..."),
    Profile(userName: "Julie", profilePicture: "Pic4", lastMsg: "404 Page not Found!"),
    Profile(userName: "Kaviya", profilePicture: "Pic5", lastMsg: "Do not Disturb."),
]
