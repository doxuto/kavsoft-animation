//
//  ContentView.swift
//  Rolling Counter
//
//  Created by Balaji on 08/07/22.
//

import SwiftUI

struct ContentView: View {
    @State var value: Int = 0
    var body: some View {
        NavigationView{
            VStack(spacing: 25){
                RollingText(font: .system(size: 55), weight: .black, value: $value)
                
                Button("Change Value"){
                    value = .random(in: 200...1300)
                }
            }
            .padding()
            .navigationTitle("Rolling Counter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
