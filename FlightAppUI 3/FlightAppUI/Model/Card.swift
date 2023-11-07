//
//  Card.swift
//  FlightAppUI
//
//  Created by Balaji on 24/11/22.
//

import SwiftUI

// MARK: Card Model And Sample Cards
struct Card: Identifiable{
    var id: UUID = .init()
    var cardImage: String
    /// Other Properties
}

var sampleCards: [Card] = [
    .init(cardImage: "Card 1"),
    .init(cardImage: "Card 2"),
    .init(cardImage: "Card 3"),
    .init(cardImage: "Card 4"),
    .init(cardImage: "Card 5"),
    .init(cardImage: "Card 6"),
    .init(cardImage: "Card 7"),
    .init(cardImage: "Card 8"),
    .init(cardImage: "Card 9"),
    .init(cardImage: "Card 10"),
]
