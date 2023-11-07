//
//  WindowSharedModel.swift
//  TabBarSheet
//
//  Created by Balaji on 23/08/23.
//

import SwiftUI

@Observable
class WindowSharedModel {
    var activeTab: Tab = .devices
    var hideTabBar: Bool = false
}
