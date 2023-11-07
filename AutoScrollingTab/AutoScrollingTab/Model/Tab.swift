//
//  Tab.swift
//  AutoScrollingTab
//
//  Created by Balaji on 12/03/23.
//

import SwiftUI

/// Enum Tab Cases
/// - rawValue: Asset Image Name
enum Tab: String, CaseIterable {
    case men = "Men"
    case women = "Women"
    case kids = "Kids"
    case living = "Living"
    case game = "Games"
    case outing = "Outing"
    
    /// Tab Index
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
    
    /// Total Count
    var count: Int {
        return Tab.allCases.count
    }
}
