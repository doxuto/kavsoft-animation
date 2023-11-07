//
//  History.swift
//  BankingMacApp
//
//  Created by Balaji on 26/10/21.
//

import SwiftUI

// Sample History Model and Data....
struct History: Identifiable{
    var id = UUID().uuidString
    var image: String
    var description: String
    var time: String
    var amount: String
}

var histories: [History] = [

    History(image: "Pic1", description: "Loan", time: "10:39 PM", amount: "$320"),
    History(image: "Pic2", description: "MacBook Pro", time: "11:39 PM", amount: "$2200"),
    History(image: "Pic3", description: "Google", time: "08:39 AM", amount: "$120"),
]
