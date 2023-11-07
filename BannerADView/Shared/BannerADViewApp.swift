//
//  BannerADViewApp.swift
//  Shared
//
//  Created by Balaji on 21/11/21.
//

import SwiftUI
import GoogleMobileAds

@main
struct BannerADViewApp: App {
    init(){
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// From Xcode 13 info.plist file wont be shown in project navigator until you add any keys manually in app's info...
