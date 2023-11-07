//
//  ColorGrid.swift
//  AnimationsTutorial (iOS)
//
//  Created by Balaji on 20/01/22.
//

import SwiftUI

// MARK: Sample Model
struct ColorGrid: Identifiable{
    var id = UUID().uuidString
    var hexValue: String
    var color: Color
    // MARK: Animation Properties for Each Card
    var rotateCards: Bool = false
    var addToGrid: Bool = false
    var showText: Bool = false
    var removeFromView: Bool = false
}
