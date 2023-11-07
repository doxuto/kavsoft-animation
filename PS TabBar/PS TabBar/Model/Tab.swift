//
//  Tab.swift
//  PS TabBar
//
//  Created by Balaji on 20/02/23.
//

import SwiftUI

/// Enum Tab Cases
/// Raw Value: Asset Image Name
enum Tab: String, CaseIterable {
    case play = "Play"
    case explore = "Explore"
    case store = "PS Store"
    case library = "Game Library"
    case search = "Search"
    
    var index: CGFloat {
        return CGFloat(Tab.allCases.firstIndex(of: self) ?? 0)
    }
    
    static var count: CGFloat {
        return CGFloat(Tab.allCases.count)
    }
}
