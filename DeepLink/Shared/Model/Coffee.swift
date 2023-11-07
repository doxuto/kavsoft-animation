//
//  Coffee.swift
//  DeepLink (iOS)
//
//  Created by Balaji on 14/12/21.
//

import SwiftUI

// Coffee Model with Sample Data....
struct Coffee: Identifiable{
    var id: String
    var title: String
    var description: String
    var productImage: String
    var productPrice: String
}

// ID's are use to Link each page when Deep link are called....
var coffees: [Coffee] = [

    Coffee(id: "COFFB11", title: "Black Coffee", description: "No frills here: Black coffee is made from plain ground coffee beans that are brewed hot. It's served without added sugar, milk, or flavorings.", productImage: "Coffee1", productPrice: "$17"),
    Coffee(id: "COFFB12", title: "Decaf", description: "Coffee beans naturally contain caffeine, but roasters can use several different processes to remove almost all of it. Decaf coffee is brewed with these decaffeinated beans.", productImage: "Coffee2", productPrice: "$10"),
    Coffee(id: "COFFB13", title: "Espresso", description: "Most people know that a shot of espresso is stronger than the same amount of coffee, but what's the difference, exactly? There isn't anything inherently different about the beans themselves", productImage: "Coffee3", productPrice: "$19"),
    Coffee(id: "COFFB14", title: "Latte", description: "This classic drink is typically 1/3 espresso and 2/3 steamed milk, topped with a thin layer of foam, but coffee shops have come up with seemingly endless", productImage: "Coffee4", productPrice: "$22"),
    Coffee(id: "COFFB15", title: "Cappuccino", description: "This espresso-based drink is similar to a latte, but the frothy top layer is thicker. The standard ratio is equal parts espresso, steamed milk, and foam. It's often served in a 6-ounce cup (smaller than a latte cup) and can be topped with a sprinkling of cinnamon.", productImage: "Coffee5", productPrice: "$15"),
    Coffee(id: "COFFB16", title: "Macchiato", description: "A macchiato is a shot of espresso with just a touch of steamed milk or foam. In Italian, macchiato means stained or spotted, so a caffè macchiato refers to coffee that's been stained with milk.", productImage: "Coffee6", productPrice: "$25"),
]
