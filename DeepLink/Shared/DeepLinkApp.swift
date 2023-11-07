//
//  DeepLinkApp.swift
//  Shared
//
//  Created by Balaji on 14/12/21.
//

import SwiftUI

@main
struct DeepLinkApp: App {
    @StateObject var appData: AppDataModel = AppDataModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
                .onOpenURL { url in
                    // used to fetch the deep link url...
                    if appData.checkDeepLink(url: url){
                        print("FROM DEEP LINK")
                    }
                    else{
                        print("FALL BACK DEEP LINK")
                    }
                }
        }
    }
}

// Integrating Deep Link....
// First create a url scheme for how to call your url...
// EG: kavsoft
// ijustine.....
// calling will be done like kavsoft://....your values......
