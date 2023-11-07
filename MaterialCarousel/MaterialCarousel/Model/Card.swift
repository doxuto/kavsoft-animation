//
//  Card.swift
//  MaterialCarousel
//
//  Created by Balaji on 27/06/23.
//

import SwiftUI

/// Card Model
struct Card: Identifiable, Hashable, Equatable {
    var id: UUID = .init()
    var image: String
    var previousOffset: CGFloat = 0
}
