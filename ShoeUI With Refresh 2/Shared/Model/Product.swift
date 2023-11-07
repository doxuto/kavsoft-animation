//
//  Product.swift
//  Product
//
//  Created by Balaji on 31/08/21.
//

import SwiftUI

// Product Model and sample Data....
struct Product: Identifiable{
    var id = UUID().uuidString
    var productImage: String
    var productTitle: String
    var productPrice: String
    var productBG: Color
    var isLiked: Bool = false
    var productRating: Int
}

var products = [

    Product(productImage: "p1", productTitle: "Nike Air Max 20", productPrice: "$240.0", productBG: Color("shoeBG1"), productRating: 4),
    Product(productImage: "p2", productTitle: "Excee Sneakers", productPrice: "$260.0", productBG: Color("shoeBG2"),isLiked: true, productRating: 3),
    Product(productImage: "p3", productTitle: "Air Max Motion 2", productPrice: "$290.0", productBG: Color("shoeBG3"), productRating: 5),
    Product(productImage: "p4", productTitle: "Leather Sneakers", productPrice: "$270.0", productBG: Color("shoeBG4"), productRating: 4),
]
