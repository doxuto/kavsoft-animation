//
//  Home.swift
//  CustomTransition (iOS)
//
//  Created by Balaji on 23/02/22.
//

import SwiftUI

struct Home: View {
    @State var show: Bool = false
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            
            CubicTransition(show: $show) {
                
                ZStack{
                    Image("Pic1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                    
                    Button {
                        show.toggle()
                    } label: {
                     
                        Text("Navigate")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .environment(\.colorScheme, .dark)
                    }
                    .offset(y: 150)
                }
                
            } detail: {
                
                Image("Pic2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            
            HStack(spacing: 12){
                
                if show{
                    Button {
                        show.toggle()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                
                Text(show ? "Back" : "Custom Transition")
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
            .padding()
            .padding(.top,4)
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
