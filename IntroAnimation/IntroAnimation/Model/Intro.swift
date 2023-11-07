//
//  Intro.swift
//  IntroAnimation
//
//  Created by Balaji on 15/10/22.
//

import SwiftUI

// MARK: Intro Model And Sample Intro's
struct Intro: Identifiable{
    var id: String = UUID().uuidString
    var imageName: String
    var title: String
}

var intros: [Intro] = [
    .init(imageName: "Image 1", title: "Relax"),
    .init(imageName: "Image 2", title: "Care"),
    .init(imageName: "Image 3", title: "Mood Dairy"),
]

// MARK: Font String's
let sansBold = "WorkSans-Bold"
let sansSemiBold = "WorkSans-SemiBold"
let sansRegular = "WorkSans-Regular"
// MARK: Dummy Text
let dummyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.\nLorem Ipsum is dummy text."
