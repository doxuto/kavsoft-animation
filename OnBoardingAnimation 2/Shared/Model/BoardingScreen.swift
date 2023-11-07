//
//  BoardingScreen.swift
//  BoardingScreen
//
//  Created by Balaji on 27/08/21.
//

import SwiftUI

struct BoardingScreen: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
}

// Same Title and desc...
let title = "Easy Payments with \nWalletory"
let description = "Small business can receive device \npayment super fast and super easy"

// Since image name and BG color name are same....

// Sample Model SCreens....
var boardingScreens: [BoardingScreen] = [

    BoardingScreen(image: "screen1", title: title, description: description),
    BoardingScreen(image: "screen2", title: title, description: description),
    BoardingScreen(image: "screen3", title: title, description: description),
    BoardingScreen(image: "screen4", title: title, description: description),
]
