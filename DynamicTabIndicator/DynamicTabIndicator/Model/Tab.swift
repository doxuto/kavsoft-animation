//
//  Tab.swift
//  DynamicTabIndicator
//
//  Created by Balaji on 15/07/22.
//

import SwiftUI

// MARK: Sample Tab Model And Data
struct Tab: Identifiable,Hashable{
    var id: String = UUID().uuidString
    var tabName: String
    var sampleImage: String
}

var sampleTabs: [Tab] = [
    .init(tabName: "Iceland", sampleImage: "Image1"),
    .init(tabName: "France", sampleImage: "Image2"),
    .init(tabName: "Brazil", sampleImage: "Image3"),
]
