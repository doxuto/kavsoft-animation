//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 17/10/21.
//

import SwiftUI

struct ContentView: View {
    // Do actions when animation has been finished....
    @State var endAnimation: Bool = false
    @State var animateHome: Bool = false
    
    var body: some View {

        ZStack{
            
            // Home...
            Home()
            // Animating Home like its moving from bottom...
                .offset(y: endAnimation ? 0 : getRect().height)
            
            SplashScreen(endAnimation: $endAnimation)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
