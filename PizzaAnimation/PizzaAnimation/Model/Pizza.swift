//
//  Pizza.swift
//  PizzaAnimation
//
//  Created by Balaji on 03/07/22.
//

import SwiftUI

// MARK: Pizza Model And Sample Data
struct Pizza: Identifiable{
    var id: String = UUID().uuidString
    var pizzaImage: String
    var pizzaTitle: String
    var pizzaDescription: String
    var pizzaPrice: String
}

var pizzas: [Pizza] = [
    Pizza(pizzaImage: "Pizza1", pizzaTitle: "Classic Red", pizzaDescription: "Special pizza sauce, tomatoes, mozzarella, parmesan cheese, red pepper flakes.", pizzaPrice: "$10.50"),
    Pizza(pizzaImage: "Pizza2", pizzaTitle: "Chicken Carbonara", pizzaDescription: "Creamy sauce, mozzarella, chicken, bacon, mushrooms and crushed red pepper flakes.", pizzaPrice: "$12.50"),
    Pizza(pizzaImage: "Pizza3", pizzaTitle: "Mediterranean", pizzaDescription: "Hummus, mozzarella, feta, spinach, red onion, banana pepper, green bell pepper, olives.", pizzaPrice: "$11.90"),
]
