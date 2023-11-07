//
//  Card.swift
//  InfiniteStackedCarousel (iOS)
//
//  Created by Balaji on 09/11/21.
//

import SwiftUI

// Sample Card Model and Sample Data....
struct Card: Identifiable {
    
    var id = UUID().uuidString
    var cardColor: Color
    var date: String = ""
    var title: String
}
