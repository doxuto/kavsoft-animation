//
//  Tab.swift
//  FoodDeliveryApp
//
//  Created by Balaji on 08/09/22.
//

import SwiftUI

// MARK: Tab Model And Sample Data
struct Tab: Identifiable{
    var id: String = UUID().uuidString
    var tabImage: String
    var tabName: String
    var tabOffset: CGSize
}

var tabs: [Tab] = [
    .init(tabImage: "Coffee",tabName: "Hot\nCoffee", tabOffset: CGSize(width: 0, height: -40)),
    .init(tabImage: "Shake 5",tabName: "Frappo", tabOffset: CGSize(width: 0, height: -38)),
    .init(tabImage: "IceCream",tabName: "Ice Cream", tabOffset: CGSize(width: 0, height: -25)),
    .init(tabImage: "Waffles",tabName: "Waffles", tabOffset: CGSize(width: -12, height: 28))
]
