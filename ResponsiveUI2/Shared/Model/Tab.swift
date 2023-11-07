//
//  Tab.swift
//  ResponsiveUI2 (iOS)
//
//  Created by Balaji on 03/06/22.
//

import SwiftUI

// MARK: Tab Enum Model, RawValue = Image File Name in Asset
enum Tab: String,CaseIterable{
    case dashboard = "Dashboard"
    case transaction = "Transaction"
    case task = "Task"
    case documents = "Documents"
    case store = "Store"
    case notification = "Notifications"
    case profile = "Profile"
    case settings = "Settings"
}
