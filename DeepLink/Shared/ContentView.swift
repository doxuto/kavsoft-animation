//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 14/12/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appData: AppDataModel
    var body: some View {

        Home()
            .environmentObject(appData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
