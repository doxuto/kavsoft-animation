//
//  Letter.swift
//  ScrollDetection (iOS)
//
//  Created by Balaji on 05/11/21.
//

import SwiftUI

// Sample Model and Data....
struct Letter: Identifiable,Hashable{
    var id = UUID().uuidString
    var date: String
    var title: String
}

var letters: [Letter] = [

    Letter(date: "December 8 2021", title: "Happy birthday"),
    Letter(date: "June 18 2021", title: "Happy birthday"),
    Letter(date: "October 8 2021", title: "Happy birthday"),
]

