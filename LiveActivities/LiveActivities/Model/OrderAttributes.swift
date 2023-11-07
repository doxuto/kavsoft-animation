//
//  OrderAttributes.swift
//  LiveActivities
//
//  Created by Balaji on 28/07/22.
//

import SwiftUI
// MARK: Available From Xcode 14 Beta 4
import ActivityKit

struct OrderAttributes: ActivityAttributes {
    struct ContentState: Codable,Hashable{
        // MARK: Live Activities Will Update Its View When Content State is Updated
        var status: Status = .received
    }
    
    // MARK: Other Properties
    var orderNumber: Int
    var orderItems: String
}

// MARK: Order Status
// For This Demo Project
// Change For Your Project Usage
enum Status: String,CaseIterable,Codable,Equatable{
    // MARK: String Values Are SFSymbol Images
    case received = "shippingbox.fill"
    case progress = "person.bust"
    case ready = "takeoutbag.and.cup.and.straw.fill"
}
