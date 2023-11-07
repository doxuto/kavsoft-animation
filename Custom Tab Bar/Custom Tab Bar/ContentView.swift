//
//  ContentView.swift
//  Custom Tab Bar
//
//  Created by Balaji on 08/05/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
