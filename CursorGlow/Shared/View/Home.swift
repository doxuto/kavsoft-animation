//
//  Home.swift
//  CursorGlow (iOS)
//
//  Created by Balaji on 30/04/22.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ZStack{
            Image("BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 20), count: 4), spacing: 20) {
                ForEach(appItems){appItem in
                    CursorGlowView(glowOpacity: 0.5,blurRadius: 35) {
                        Image(appItem.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 70, height: 70)
                }
            }
            .padding()
            .padding(.top,30)
            .frame(maxHeight: .infinity,alignment: .top)
        }
        .frame(width: 350, height: 700)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//ZStack{
//    LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 20), count: 3), spacing: 30) {
//        ForEach(1...6,id: \.self){appItem in
//            CursorGlowView(glowOpacity: 0.5, blurRadius: 50, content: {
//                Rectangle()
//                    .fill(Color("Card"))
//            })
//
//            .frame(width: 200, height: 200)
//        }
//    }
//    .padding()
//    .frame(maxHeight: .infinity,alignment: .top)
//}
//.frame(width: 750, height: 650)
//.background(Color("BG"))
