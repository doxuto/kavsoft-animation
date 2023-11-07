//
//  Home.swift
//  ParticleEmitter
//
//  Created by Balaji on 22/04/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var isLiked: [Bool] = [false, false, false]
    var body: some View {
        VStack {
            GeometryReader {
                let size = $0.size
                
                HStack(spacing: 20) {
                    CustomButton(systemImage: "suit.heart.fill", status: isLiked[0], activeTint: .pink, inActiveTint: .gray) {
                        isLiked[0].toggle()
                    }
                    
                    CustomButton(systemImage: "star.fill", status: isLiked[1], activeTint: .yellow, inActiveTint: .gray) {
                        isLiked[1].toggle()
                    }
                    
                    CustomButton(systemImage: "square.and.arrow.up.fill", status: isLiked[2], activeTint: .blue, inActiveTint: .gray) {
                        isLiked[2].toggle()
                    }
                }
                  .frame(width: size.width, height: size.height)
            }
            
            GeometryReader {
                 let size = $0.size
                 
                 VStack(alignment: .leading, spacing: 20) {
                     Text("Usage")
                         .fontWeight(.semibold)
                         .underline()
                     
                     Text("""
                     .particleEffect(
                         systemImage: "suit.heart.fill",
                         font: .title2,
                         status: isLiked,
                         inActiveColor: .gray,
                         activeColor: .pink
                     )
                     """
                     )
                     .lineSpacing(5)
                     .foregroundColor(.white.opacity(0.8))
                 }
                 .padding([.horizontal, .vertical], 15)
                 .background {
                     RoundedRectangle(cornerRadius: 15, style: .continuous)
                         .fill(Color("ButtonColor"))
                 }
                 .frame(width: size.width, height: size.height)
             }
             .padding(.vertical, 50)
        }
    }
    
    /// Custom Button View
    @ViewBuilder
    func CustomButton(systemImage: String, status: Bool, activeTint: Color, inActiveTint: Color, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.title2)
                .particleEffect(
                    systemImage: systemImage,
                    font: .body,
                    status: status,
                    activeTint: activeTint,
                    inActiveTint: inActiveTint
                )
                .foregroundColor(status ? activeTint : inActiveTint)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(status ? activeTint.opacity(0.25) : Color("ButtonColor"))
                }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
