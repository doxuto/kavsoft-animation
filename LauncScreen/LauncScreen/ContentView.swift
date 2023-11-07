//
//  ContentView.swift
//  LauncScreen
//
//  Created by Balaji on 01/07/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AnimatedSplashScreen(color: "Orange", logo: "SwiftLogo",animationTiming: 0.65) {
            // MARK: Your Home View
            ScrollView{
                VStack(spacing: 15){
                    ForEach(1...5,id: \.self){index in
                        GeometryReader{proxy in
                            let size = proxy.size
                            Image("Thumb\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size.width, height: size.height)
                                .cornerRadius(15)
                        }
                        .frame(height: 200)
                    }
                }
                .padding(15)
            }
        } onAnimationEnd: {
            print("Animation Ended")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
