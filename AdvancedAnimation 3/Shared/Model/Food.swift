//
//  Food.swift
//  AdvancedAnimation (iOS)
//
//  Created by Balaji on 29/12/21.
//

import SwiftUI

// Sample Data Model
struct Food: Identifiable{
    var id = UUID().uuidString
    var itemImage: String
    var itemTitle: String
}

var foods = [

    Food(itemImage: "Food1", itemTitle: "Yummy Chocalate Cake"),
    Food(itemImage: "Food2", itemTitle: "Delicious Pizza"),
    Food(itemImage: "Food3", itemTitle: "Yummy scrummy\ncarrot cake"),
]
