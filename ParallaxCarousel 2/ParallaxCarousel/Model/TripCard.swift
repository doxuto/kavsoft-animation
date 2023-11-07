//
//  TripCard.swift
//  ParallaxCarousel
//
//  Created by Balaji on 12/08/23.
//

import SwiftUI

/// Trip Card Model
struct TripCard: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

/// Sample Cards
var tripCards: [TripCard] = [
    .init(title: "London", subTitle: "England", image: "Pic 1"),
    .init(title: "New York", subTitle: "USA", image: "Pic 2"),
    .init(title: "Prague", subTitle: "Czech Republic", image: "Pic 3"),
]
