//
//  SwiftUIRealmApp.swift
//  Shared
//
//  Created by Balaji on 24/12/21.
//

import SwiftUI
import RealmSwift

@main
struct SwiftUIRealmApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realmConfiguration, Realm.Configuration())
        }
    }
}
