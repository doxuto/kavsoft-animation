//
//  ContentView.swift
//  iPhonePopOvers
//
//  Created by Balaji on 21/01/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            Home()
                .navigationTitle("iOS Popovers")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
