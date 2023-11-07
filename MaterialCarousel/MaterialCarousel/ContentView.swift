//
//  ContentView.swift
//  MaterialCarousel
//
//  Created by Balaji on 27/06/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Carousel")
        }
    }
}

#Preview {
    ContentView()
}
