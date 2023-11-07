//
//  DeepLinkAppApp.swift
//  DeepLinkApp
//
//  Created by Balaji on 06/04/23.
//

import SwiftUI

@main
struct DeepLinkAppApp: App {
    /// State Object, Contains Whole App Data and Passes it VIA Environment Object
    @StateObject private var appData: AppData = .init()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
                /// Called When Deep Link was Triggered
                .onOpenURL { url in
                    let string = url.absoluteString.replacingOccurrences(of: "myapp://", with: "")
                    /// Spliting URL Component's
                    let components = string.components(separatedBy: "?")
                    
                    for component in components {
                        if component.contains("tab=") {
                            /// Tab Change Request
                            let tabRawValue = component.replacingOccurrences(of: "tab=", with: "")
                            if let requestedTab = Tab.convert(from: tabRawValue) {
                                appData.activeTab = requestedTab
                            }
                        }
                        
                        /// Navigation will only be updated if the link contains or specifies which tab navigation needs to be changed.
                        if component.contains("nav=") && string.contains("tab") {
                            /// Nav Change Request
                            let requestedNavPath = component
                                .replacingOccurrences(of: "nav=", with: "")
                                .replacingOccurrences(of: "_", with: " ")
                            
                            switch appData.activeTab {
                            case .home:
                                if let navPath = HomeStack.convert(from: requestedNavPath) {
                                    appData.homeNavStack.append(navPath)
                                }
                            case .favourite:
                                if let navPath = FavouriteStack.convert(from: requestedNavPath) {
                                    appData.favouriteNavStack.append(navPath)
                                }
                            case .settings:
                                if let navPath = SettingsStack.convert(from: requestedNavPath) {
                                    appData.settingNavStack.append(navPath)
                                }
                            }
                        }
                    }
                }
        }
    }
}
