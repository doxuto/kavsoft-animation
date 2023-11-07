//
//  ContentView.swift
//  Shared
//
//  Created by Balaji on 10/03/22.
//

import SwiftUI

struct ContentView: View {
    // Optional
    @State var showView: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if showView{
                Home()
            }
        }
        .frame(maxWidth: .infinity)
        .background{
            ZStack{
                VStack{
                    Circle()
                        .fill(Color("Green"))
                        .scaleEffect(0.6)
                        .offset(x: 20)
                        .blur(radius: 120)
                    
                    Circle()
                        .fill(Color("Red"))
                        .scaleEffect(0.6,anchor: .leading)
                        .offset(y: -20)
                        .blur(radius: 120)
                }
                
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showView = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
