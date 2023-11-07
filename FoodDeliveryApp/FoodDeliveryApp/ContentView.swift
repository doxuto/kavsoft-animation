//
//  ContentView.swift
//  FoodDeliveryApp
//
//  Created by Balaji on 07/09/22.
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
