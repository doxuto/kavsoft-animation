//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 26/11/21.
//

import SwiftUI

struct ContentView: View {
    // Log Status..
    @AppStorage("log_Status") var log_Status: Bool = false
    var body: some View {
        Group{
            if log_Status{
                MainPage()
            }
            else{
                OnBoardingPage()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
