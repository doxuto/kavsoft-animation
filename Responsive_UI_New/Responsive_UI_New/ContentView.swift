//
//  ContentView.swift
//  Responsive_UI_New
//
//  Created by Balaji on 03/09/22.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        ResponsiveView { props in
            Home(props: props)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
