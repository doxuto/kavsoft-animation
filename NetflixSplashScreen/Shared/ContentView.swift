//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 04/10/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        SplashScreen()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
