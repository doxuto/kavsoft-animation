//
//  ContentView.swift
//  InteractiveCharts
//
//  Created by Balaji on 12/06/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Interactive Chart's")
        }
    }
}

#Preview  {
    ContentView()
}
