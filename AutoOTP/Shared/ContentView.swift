//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 14/04/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var log_status = false
    var body: some View {
        NavigationView{
            if log_status{
                Text("Home")
                    .navigationTitle("Home")
            }
            else{
                Login()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
