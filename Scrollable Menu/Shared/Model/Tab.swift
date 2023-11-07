//
//  Tab.swift
//  Scrollable Menu (iOS)
//
//  Created by Balaji on 23/10/21.
//

import SwiftUI

// Sample Tabs with sample foods....
struct Food: Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var price: String
    var image: String
}


var foods = [

    Food(title: "Choclate Cake", description: "Chocolate cake or chocolate gâteau is a cake flavored with melted chocolate, cocoa powder, or both", price: "$19",image: "choclates"),
    Food(title: "Cookies", description: "A biscuit is a flour-based baked food product. Outside North America the biscuit is typically hard, flat, and unleavened", price: "$10",image: "cookies"),
    Food(title: "Sandwich", description: "Trim the bread from all sides and apply butter on one bread, then apply the green chutney all over.", price: "$9",image: "sandwich"),
    Food(title: "French Fries", description: "French fries, or simply fries, chips, finger chips, or French-fried potatoes, are batonnet or allumette-cut deep-fried potatoes.", price: "$15",image: "fries"),
    Food(title: "Pizza", description: "Pizza is a savory dish of Italian origin consisting of a usually round, flattened base of leavened wheat-based dough topped", price: "$39",image: "pizza"),
]

// Tab Model...
struct Tab: Identifiable {
    
    var id = UUID().uuidString
    var tab : String
    var foods: [Food]
}

// Tab Items...
var tabsItems = [

    Tab(tab: "Home Style", foods: foods.shuffled()),
    Tab(tab: "Promotions", foods: foods.shuffled()),
    Tab(tab: "Snacks", foods: foods.shuffled()),
    Tab(tab: "McCafe", foods: foods.shuffled()),
]
