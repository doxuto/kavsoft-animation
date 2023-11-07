//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 05/10/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        Home()
            .buttonStyle(BorderlessButtonStyle())
            .textFieldStyle(PlainTextFieldStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
