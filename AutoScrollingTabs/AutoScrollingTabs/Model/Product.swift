//
//  Product.swift
//  AutoScrollingTabs
//
//  Created by Balaji on 14/02/23.
//

import SwiftUI

/// Product Model & Sample Products
struct Product: Identifiable,Hashable {
    var id: UUID = UUID()
    var type: ProductType
    var title: String
    var subtitle: String
    var price: String
    var productImage: String = ""
}

enum ProductType: String,CaseIterable {
    case iphone = "iPhone"
    case ipad = "iPad"
    case macbook = "MacBook"
    case desktop = "Mac Desktop"
    case appleWatch = "Apple Watch"
    case airpods = "Airpods"
    
    var tabID: String {
        /// Creating Another UniqueID for Tab Scrolling
        return self.rawValue + self.rawValue.prefix(4)
    }
}

var products: [Product] = [
    /// Apple Watch
    Product(type: .appleWatch, title: "Apple Watch", subtitle: "Ultra: Alphine Loop", price: "$999",productImage: "AppleWatchUltra"),
    Product(type: .appleWatch, title: "Apple Watch", subtitle: "Series 8: Black", price: "$599",productImage: "AppleWatch8"),
    Product(type: .appleWatch, title: "Apple Watch", subtitle: "Series 6: Red", price: "$359",productImage: "AppleWatch6"),
    Product(type: .appleWatch, title: "Apple Watch", subtitle: "Series 4: Black", price: "$250", productImage: "AppleWatch4"),
    /// iPhone's
    Product(type: .iphone, title: "iPhone 14 Pro Max", subtitle: "A16 - Purple", price: "$1299", productImage: "iPhone14"),
    Product(type: .iphone, title: "iPhone 13", subtitle: "A15 - Pink", price: "$699", productImage: "iPhone13"),
    Product(type: .iphone, title: "iPhone 12", subtitle: "A14 - Blue", price: "$599", productImage: "iPhone12"),
    Product(type: .iphone, title: "iPhone 11", subtitle: "A13 - Purple", price: "$499", productImage: "iPhone11"),
    Product(type: .iphone, title: "iPhone SE 2", subtitle: "A13 - White", price: "$399", productImage: "iPhoneSE"),
    /// MacBook's
    Product(type: .macbook, title: "MacBook Pro 16", subtitle: "M2 Max - Silver", price: "$2499", productImage: "MacBookPro16"),
    Product(type: .macbook, title: "MacBook Pro", subtitle: "M1 - Space Grey", price: "$1299", productImage: "MacBookPro"),
    Product(type: .macbook, title: "MacBook Air", subtitle: "M1 - Gold", price: "$999", productImage: "MacBookAir"),
    /// iPad's
    Product(type: .ipad, title: "iPad Pro", subtitle: "M1 - Silver", price: "$999", productImage: "iPadPro"),
    Product(type: .ipad, title: "iPad Air 4", subtitle: "A14 - Pink", price: "$699", productImage: "iPadAir"),
    Product(type: .ipad, title: "iPad Mini", subtitle: "A15 - Grey", price: "$599", productImage: "iPadMini"),
    /// Desktop's
    Product(type: .desktop, title: "Mac Studio", subtitle: "M1 Max - Silver", price: "$1999", productImage: "MacStudio"),
    Product(type: .desktop, title: "Mac Mini", subtitle: "M2 Pro - Space Gray", price: "$999", productImage: "MacMini"),
    Product(type: .desktop, title: "iMac", subtitle: "M1 - Purple", price: "$1599", productImage: "iMac"),
    /// Airpods
    Product(type: .airpods, title: "Airpods", subtitle: "Pro 2nd Gen", price: "$249",productImage: "AirpodsPro"),
    Product(type: .airpods, title: "Airpods", subtitle: "3rd Gen", price: "$179",productImage: "Airpods3"),
    Product(type: .airpods, title: "Airpods", subtitle: "2nd Gen", price: "$129",productImage: "Airpods2"),
]

