//
//  Pizza.swift
//  PizzaChallenge (iOS)
//
//  Created by Balaji on 11/12/21.
//

import SwiftUI

// Pizza model and sample Pizzas....
struct Pizza: Identifiable{
    var id = UUID().uuidString
    var breadName: String
    var toppings: [Topping] = []
}

