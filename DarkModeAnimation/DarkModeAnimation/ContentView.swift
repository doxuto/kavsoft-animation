//
//  ContentView.swift
//  DarkModeAnimation
//
//  Created by Balaji Venkatesh on 17/09/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DarkModeWrapper {
            Home()
        }
    }
}

#Preview {
    ContentView()
}
