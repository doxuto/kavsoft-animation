//
//  Sale.swift
//  Responsive_UI_New
//
//  Created by Balaji on 03/09/22.
//

import SwiftUI

// MARK: Sale Graph Model and Plot Data
struct Sale: Identifiable{
    var id: String = UUID().uuidString
    var sales: Int
    var time: String
}

var dailySales: [Sale] = [
    .init(sales: 20, time: "11:00"),
    .init(sales: 40, time: "12:00"),
    .init(sales: 40, time: "1:00"),
    .init(sales: 150, time: "2:00"),
    .init(sales: 260, time: "3:00"),
    .init(sales: 80, time: "4:00"),
    .init(sales: 120, time: "5:00"),
    .init(sales: 50, time: "6:00"),
    .init(sales: 30, time: "7:00"),
]
