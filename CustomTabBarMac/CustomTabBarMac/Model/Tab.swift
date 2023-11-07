//
//  Tab.swift
//  CustomTabBarMac
//
//  Created by Balaji Venkatesh on 22/10/23.
//

import SwiftUI

/// Tab's
enum Tab: String, CaseIterable {
    case today = "Today"
    case inbox = "Inbox"
    case draft = "Draft"
    case sent = "Sent"
    case junk = "Junk"
    case bin = "Bin"
    case archive = "Archive"
    
    var sfSymbol: String {
        switch self {
        case .today:
            return "calendar"
        case .inbox:
            return "tray"
        case .draft:
            return "folder"
        case .sent:
            return "paperplane"
        case .junk:
            return "xmark.bin"
        case .bin:
            return "trash"
        case .archive:
            return "archivebox"
        }
    }
}
