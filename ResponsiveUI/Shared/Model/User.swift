//
//  User.swift
//  ResponsiveUI (iOS)
//
//  Created by Balaji on 04/03/22.
//

import SwiftUI

// MARK: User Model and Sample Data
struct User: Identifiable{
    var id = UUID().uuidString
    var name: String
    var image: String
    var title: String
}

var users: [User] = [

    User(name: "iJustine", image: "User1",title: "Apple Event is here"),
    User(name: "Jenna", image: "User2",title: "Xbox Gaming"),
    User(name: "Jessica", image: "User3",title: "New iPhone 14 Design"),
    User(name: "Rebecca", image: "User4",title: "MacBook With Multiple Colors"),
]
