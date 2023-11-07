//
//  Tab.swift
//  DotInversionIntro (iOS)
//
//  Created by Balaji on 27/10/21.
//

import SwiftUI

// Tab Model and sample Intro Tabs....
struct Tab: Identifiable{
    var id = UUID().uuidString
    var title: String
    var subTitle: String
    var description: String
    var image: String
    var color: Color
}

// Add more tabs for more intro screens....
var tabs: [Tab] = [

    Tab(title: "Plan", subTitle: "your routes", description: "View your collection route Follow, change or add to your route yourself", image: "Pic1",color: Color("Green")),
    Tab(title: "Quick Waste", subTitle: "Transfer Note", description: "Record oil collections easily and accurately. No more paper!", image: "Pic2",color: Color("DarkGrey")),
    Tab(title: "Invite", subTitle: "restaurants", description: "Know some restaurant who want to optimize oil collection? Invite them with one click", image: "Pic3",color: Color("Yellow")),
]
