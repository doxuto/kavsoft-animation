//
//  ContentView.swift
//  ShimmerText
//
//  Created by Balaji on 15/03/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Hello World!")
                    .font(.title)
                    .fontWeight(.black)
                    /// Shimmer Effect
                    .shimmer(.init(tint: .white.opacity(0.5), highlight: .white, blur: 5))
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.red.gradient)
                    }
                
                HStack(spacing: 15) {
                    ForEach(["suit.heart.fill", "box.truck.badge.clock.fill", "sun.max.trianglebadge.exclamationmark.fill"], id: \.self) { sfImage in
                        Image(systemName: sfImage)
                            .font(.title)
                            .fontWeight(.black)
                            .shimmer(.init(tint: .white.opacity(0.4), highlight: .white, blur: 5))
                            .frame(width: 40, height: 40)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .fill(.indigo.gradient)
                            }
                    }
                }
                
                /// Another Example
                HStack {
                    Circle()
                        .frame(width: 55, height: 55)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 10)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 10)
                            .padding(.trailing, 50)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 10)
                            .padding(.trailing, 100)
                    }
                }
                .padding(15)
                .padding(.horizontal, 30)
                .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
                
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .frame(height: 180)
                    .padding(15)
                    .padding(.horizontal, 30)
                    .shimmer(.init(tint: .gray.opacity(0.2), highlight: .white, blur: 15, highlightOpacity: 1, speed: 2, blendMode: .overlay))
            }
            .navigationTitle("Shimmer Effect")

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
