//
//  ContentView.swift
//  BookAppUI
//
//  Created by Balaji on 05/03/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .preferredColorScheme(.light)
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
