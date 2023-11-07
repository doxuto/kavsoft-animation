//
//  Trending.swift
//  Responsive_UI_New
//
//  Created by Balaji on 03/09/22.
//

import SwiftUI

// MARK: Trending Dished Model and Sample Data
struct Trending: Identifiable{
    var id: String = UUID().uuidString
    var title: String
    var subTitle: String
    var count: Int
    var image: String
}

var trendingDishes: [Trending] = [
    Trending(title: "American Favourite", subTitle: "Order", count: 120, image: "Pizza1"),
    Trending(title: "Super Supreme", subTitle: "Order", count: 90, image: "Pizza2"),
    Trending(title: "Orange Juice", subTitle: "Order", count: 110, image: "Pizza3"),
    Trending(title: "Chicken Mushroom", subTitle: "Order", count: 70, image: "OrangeJuice"),
]
