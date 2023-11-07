//
//  Story.swift
//  SideMenuWithCustomShape (iOS)
//
//  Created by Balaji on 15/10/21.
//

import SwiftUI

// Model and Sample Data....
var stories = [
    
    Story(image: "Pic1",title: "Jack the Persian and the Black Castel"),
    Story(image: "Pic2",title: "The Dreaming Moon"),
    Story(image: "Pic3",title: "Fallen In Love"),
    Story(image: "Pic4",title: "Hounted Ground"),
]

struct Story : Identifiable {
    
    var id = UUID().uuidString
    var image : String
    var title : String
}
