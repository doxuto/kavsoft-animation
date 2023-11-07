//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 01/11/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        SplashScreen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

struct SplashScreen: View{
    
    // Animating...
    @State var splashAnimation: Bool = false
    
    @Environment(\.colorScheme) var scheme
    
    @State var removeSplashScreen: Bool = false
    
    var body: some View{
        
        ZStack{
            
            // Home VIew...
            // Were going to simply use image for demo purpose....
            
            Image(scheme == .dark ? "HomeDark" :  "HomeLight")
                .resizable()
                .aspectRatio(contentMode: .fill)
            // Hiding home until splash animation starts...
                .opacity(splashAnimation ? 1 : 0)
                .statusBar(hidden: true)
                .ignoresSafeArea()
            
            
            if !removeSplashScreen{
                
                Color("BG")
                // Masking With Twitter SVG Image...
                // From xcode 12 we can directly use svg from assets catalouge....
                    .mask(
                    
                        // Reverse masking with the help of bending....
                        Rectangle()
                            .overlay(
                            
                                Image("logo-svg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .scaleEffect(splashAnimation ? 35 : 1)
                                    .blendMode(.destinationOut)
                            )
                    )
                    .ignoresSafeArea()
            }
        }
        // avoiding dark twitter color...
        .preferredColorScheme(splashAnimation ? nil : .light)
        .onAppear {
            
            // Animating with slight delay of 0.4s...
            // for smooth animation...
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                
                withAnimation(.easeInOut(duration: 0.4)){
                    splashAnimation.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    
                    removeSplashScreen = true
                }
            }
        }
    }
}

// Note since we set the logo frame to 80
// We need the exact size of the image to be placed on inital splashscreen....
