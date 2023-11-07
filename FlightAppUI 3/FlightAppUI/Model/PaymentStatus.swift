//
//  PaymentStatus.swift
//  FlightAppUI
//
//  Created by Balaji on 26/11/22.
//

import SwiftUI

enum PaymentStatus: String,CaseIterable{
    case started = "Connected..."
    case initated = "Secure payment..."
    case finished = "Purchased"
    
    var symbolImage: String{
        switch self {
        case .started:
            return "wifi"
        case .initated:
            return "checkmark.shield"
        case .finished:
            return "checkmark"
        }
    }
}
