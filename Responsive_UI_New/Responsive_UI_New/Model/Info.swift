//
//  Info.swift
//  Responsive_UI_New
//
//  Created by Balaji on 03/09/22.
//

import SwiftUI

// MARK: Info Cards And Sample Data
struct Info: Identifiable{
    var id: String = UUID().uuidString
    var title: String
    var amount: String
    var percentage: Int
    var loss: Bool = false
    var icon: String
    var iconColor: Color
}

var infos: [Info] = [
    Info(title: "Revenue", amount: "$2.047", percentage: 10, loss: true, icon: "arrow.up.right", iconColor: Color("Orange")),
    Info(title: "Orders", amount: "356", percentage: 20, icon: "cart", iconColor: Color.green),
    Info(title: "Dine in", amount: "220", percentage: 10, icon: "fork.knife", iconColor: Color.red),
    Info(title: "Take away", amount: "135", percentage: 5, loss: true, icon: "takeoutbag.and.cup.and.straw.fill", iconColor: Color.yellow)
]
