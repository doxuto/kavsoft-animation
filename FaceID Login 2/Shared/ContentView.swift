//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 01/01/22.
//

import SwiftUI

struct ContentView: View {
    // Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {

        NavigationView{

            if logStatus{
                Home()
            }
            else{
                LoginPage()
                    .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
