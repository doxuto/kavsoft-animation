//
//  IAPGlassfyApp.swift
//  IAPGlassfy
//
//  Created by Balaji on 09/11/22.
//

import SwiftUI
import Glassfy

@main
struct IAPGlassfyApp: App {
    init(){
        // MARK: Add Your API Key
        Glassfy.initialize(apiKey: "", watcherMode: false)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
