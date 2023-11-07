//
//  ContentView.swift
//  RadialView
//
//  Created by Balaji on 24/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Radial Layout")
        }
    }
}

#Preview {
    ContentView()
}
