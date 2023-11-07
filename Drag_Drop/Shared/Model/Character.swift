//
//  Character.swift
//  Drag_Drop (iOS)
//
//  Created by Balaji on 27/03/22.
//

import SwiftUI

// MARK: Character Model and Sample Data
struct Character: Identifiable,Hashable,Equatable{
    var id = UUID().uuidString
    var value: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 19
    var isShowing: Bool = false
}

var characters_: [Character] = [

    Character(value: "Lorem"),
    Character(value: "Ipsum"),
    Character(value: "is"),
    Character(value: "simply"),
    Character(value: "dummy"),
    Character(value: "text"),
    Character(value: "of"),
    Character(value: "the"),
    Character(value: "design"),
]

