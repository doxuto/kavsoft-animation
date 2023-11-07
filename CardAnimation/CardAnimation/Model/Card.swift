//
//  Card.swift
//  CardAnimation
//
//  Created by Balaji on 05/05/23.
//

import SwiftUI

/// Card Model & Sample Cards
struct Card: Identifiable {
    var id: UUID = .init()
    var cardColor: Color
    var cardName: String
    var cardBalance: String
}

var cards: [Card] = [
    .init(cardColor: Color("Card 1"), cardName: "iJustine", cardBalance: "$5890"),
    .init(cardColor: Color("Card 2"), cardName: "Kaviya", cardBalance: "$2598"),
    .init(cardColor: Color("Card 3"), cardName: "Jenna", cardBalance: "$8971"),
    .init(cardColor: Color("Card 4"), cardName: "iJustine", cardBalance: "$5681"),
]
