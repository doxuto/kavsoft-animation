//
//  Topping.swift
//  PizzaChallenge (iOS)
//
//  Created by Balaji on 12/12/21.
//

import SwiftUI

// MARK: Topping Model
struct Topping: Identifiable{
    var id = UUID().uuidString
    var toppingName: String
    var isAdded: Bool = false
    var randomToppingPostions: [CGSize] = []
}
