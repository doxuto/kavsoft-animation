//
//  User.swift
//  TinderUI (iOS)
//
//  Created by Balaji on 07/12/21.
//

import SwiftUI

// User Model...
struct User: Identifiable {
    
    var id = UUID().uuidString
    var name: String
    var place: String
    var profilePic: String
}
