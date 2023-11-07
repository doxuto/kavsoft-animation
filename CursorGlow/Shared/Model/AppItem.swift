//
//  AppItem.swift
//  CursorGlow (iOS)
//
//  Created by Balaji on 30/04/22.
//

import SwiftUI

// MARK: Sample App Items
struct AppItem: Identifiable {
    var id = UUID().uuidString
    var imageName: String
}

var appItems = [

    AppItem(imageName: "App Store"),
    AppItem(imageName: "Calculator"),
    AppItem(imageName: "Calendar"),
    AppItem(imageName: "Camera"),
    AppItem(imageName: "Clock"),
    AppItem(imageName: "Facetime"),
    AppItem(imageName: "Health"),
    AppItem(imageName: "Mail"),
    AppItem(imageName: "Maps"),
    AppItem(imageName: "Messages"),
    AppItem(imageName: "News"),
    AppItem(imageName: "Phone"),
    AppItem(imageName: "Photos"),
    AppItem(imageName: "Safari"),
    AppItem(imageName: "Settings"),
    AppItem(imageName: "Stocks"),
    AppItem(imageName: "Wallet"),
    AppItem(imageName: "Weather"),
]

