//
//  Step.swift
//  MinimalAnimation-2 (iOS)
//
//  Created by Balaji on 11/03/22.
//

import SwiftUI

// MARK: Steps Bar Graph Model and Sample Data
struct Step: Identifiable{
    
    var id = UUID().uuidString
    var value: CGFloat
    var key: String
    var color: Color = Color("Purple")
}

var steps: [Step] = [

    Step(value: 500, key: "1-4 AM"),
    Step(value: 240, key: "5-8 AM",color: Color("Green")),
    Step(value: 350, key: "9-11 AM"),
    Step(value: 430, key: "12-4 PM",color: Color("Green")),
    Step(value: 690, key: "5-8 PM"),
    Step(value: 540, key: "9-12 PM",color: Color("Green")),
]
