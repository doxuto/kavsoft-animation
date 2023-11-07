//
//  Coffee.swift
//  CoffeeAppAnimation
//
//  Created by Balaji on 07/11/22.
//

import SwiftUI

// MARK: Coffee Model With Sample Data
struct Coffee: Identifiable{
    var id: UUID = .init()
    var imageName: String
    var title: String
    var price: String
}

var coffees: [Coffee] = [
    .init(imageName: "Item 1", title: "Caramel\nCold Drink", price: "$3.90"),
    .init(imageName: "Item 2", title: "Caramel\nMacchiato", price: "$2.30"),
    .init(imageName: "Item 3", title: "Iced Coffee\nMocha", price: "$9.20"),
    .init(imageName: "Item 4", title: "Toffee Nut\nCrunch Latte", price: "$12.30"),
    .init(imageName: "Item 5", title: "Styled Cold\nCoffee", price: "$8.90"),
    .init(imageName: "Item 6", title: "Classic Irish\nCoffee", price: "$6.10"),
    .init(imageName: "Item 7", title: "Black Tea\nLatte", price: "$2.20"),
    .init(imageName: "Item 8", title: "Iced Coffee\nMocha", price: "$5.90"),
]
