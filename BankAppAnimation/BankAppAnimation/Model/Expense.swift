//
//  Expense.swift
//  BankAppAnimation
//
//  Created by Balaji on 14/04/23.
//

import SwiftUI

/// Expense Model
struct Expense: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var amountSpent: String
    var product: String
    var productIcon: String
    var spendType: String
}
