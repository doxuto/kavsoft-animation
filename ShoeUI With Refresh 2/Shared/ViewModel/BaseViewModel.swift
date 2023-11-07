//
//  BaseViewModel.swift
//  BaseViewModel
//
//  Created by Balaji on 31/08/21.
//

import SwiftUI

class BaseViewModel: ObservableObject {
    
    // Tab Bar...
    @Published var currentTab: Tab = .Home
    
    @Published var homeTab = "Sneakers"
    
    // Detail View Properties...
    @Published var currentProduct: Product?
    @Published var showDetail = false
}

// Enum Case for Tab Items...
enum Tab: String{
    case Home = "home"
    case Heart = "heart"
    case ClipBoard = "clipboard"
    case Person = "person"
}
