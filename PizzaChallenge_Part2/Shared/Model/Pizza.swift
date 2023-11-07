//
//  Pizza.swift
//  PizzaChallenge (iOS)
//
//  Created by Balaji on 11/12/21.
//

import SwiftUI

// MARK: Pizza model
struct Pizza: Identifiable{
    var id = UUID().uuidString
    var breadName: String
    var toppings: [Topping] = []
}

