//
//  ContentView.swift
//  SequencedAnimation
//
//  Created by Balaji on 03/11/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ViewThatFits{
            Home()
            ScrollView(.vertical,showsIndicators: false){
                Home()
            }
        }
        .preferredColorScheme(.dark)
        .statusBarHidden()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
