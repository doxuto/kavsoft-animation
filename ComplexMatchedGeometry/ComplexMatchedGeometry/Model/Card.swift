//
//  Card.swift
//  ComplexMatchedGeometry
//
//  Created by Balaji on 23/08/22.
//

import SwiftUI

// MARK: Card Model
struct Card: Identifiable{
    var id: String = UUID().uuidString
    var cardImage: String
    var rotation: CGFloat = 0
}
