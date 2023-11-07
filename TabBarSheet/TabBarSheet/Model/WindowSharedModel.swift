//
//  WindowSharedModel.swift
//  TabBarSheet
//
//  Created by Balaji on 23/08/23.
//

import SwiftUI

class WindowSharedModel: ObservableObject {
    @Published var activeTab: Tab = .devices
    @Published var hideTabBar: Bool = false
}
