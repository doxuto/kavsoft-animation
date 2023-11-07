//
//  AppDataModel.swift
//  DeepLink (iOS)
//
//  Created by Balaji on 14/12/21.
//

import SwiftUI

class AppDataModel: ObservableObject {

    @Published var currentTab: Tab = .home
    @Published var currentDetailPage: String?
    
    func checkDeepLink(url: URL)->Bool{
        
        guard let host = URLComponents(url: url, resolvingAgainstBaseURL: true)?.host else{
            return false
        }
        
        // Updating Tabs...
        if host == Tab.home.rawValue{
            currentTab = .home
        }
        else if host == Tab.search.rawValue{
            currentTab = .search
        }
        else if host == Tab.settings.rawValue{
            currentTab = .settings
        }
        else{
            return checkInternalLinks(host: host)
        }
        
        return true
    }
    
    func checkInternalLinks(host: String)->Bool{
        
        // checking if host contains any navigation link ids....
        if let index = coffees.firstIndex(where: { coffee in
            return coffee.id == host
        }){
            
            // Changing to search tab...
            // since navigation links are in search tab
            currentTab = .search
            // setting nav Link selection...
            currentDetailPage = coffees[index].id
            
            return true
        }
        
        return false
    }
}

// Tab enum...
enum Tab: String{
    case home = "home"
    case search = "search"
    case settings = "settings"
}
