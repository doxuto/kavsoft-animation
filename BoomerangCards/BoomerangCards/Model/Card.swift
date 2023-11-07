//
//  Card.swift
//  BoomerangCards
//
//  Created by Balaji on 10/10/22.
//

import SwiftUI

// MARK: Card Model
struct Card: Identifiable{
    var id: String = UUID().uuidString
    var imageName: String
    var isRotated: Bool = false
    var extraOffset: CGFloat = 0
    var scale: CGFloat = 1
    var zIndex: Double = 0
}
