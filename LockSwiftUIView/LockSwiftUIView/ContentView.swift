//
//  ContentView.swift
//  LockSwiftUIView
//
//  Created by Balaji Venkatesh on 19/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LockView(lockType: .both, lockPin: "0320", isEnabled: true) {
            VStack(spacing: 15) {
                Image(systemName: "globe")
                    .imageScale(.large)
                
                Text("Hello World!")
            }
        } forgotPin: {
            // TODO:
        }
    }
}

#Preview {
    ContentView()
}
