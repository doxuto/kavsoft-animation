//
//  Intro.swift
//  LiquidIntro (iOS)
//
//  Created by Balaji on 20/10/21.
//

import SwiftUI

// Intro Model and Sample Screens...
struct Intro: Identifiable{
    var id = UUID().uuidString
    var title: String
    var subTitle: String
    var description: String
    var pic: String
    var color: Color
    var offset: CGSize = .zero
}
