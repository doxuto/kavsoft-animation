//
//  ContentView.swift
//  SheetHeroAnimation
//
//  Created by Balaji on 23/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Chat App")
        }
    }
}

#Preview {
    ContentView()
}
