//
//  Home.swift
//  RadialView
//
//  Created by Balaji on 24/07/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var colors: [ColorValue] = [.red, .yellow, .green, .purple, .pink, .orange, .brown, .cyan, .indigo, .mint].compactMap { color -> ColorValue? in
        return .init(color: color)
    }
    @State private var activeIndex: Int = 0
    var body: some View {
        GeometryReader(content: { geometry in
            VStack {
                //Spacer(minLength: 0)
                
                RadialLayout(items: colors, id: \.id, spacing: 120) { colorValue, index, size in
                    /// Sample View
                    Circle()
                        .fill(colorValue.color.gradient)
                        .overlay {
                            Text("\(index)")
                                .fontWeight(.semibold)
                        }
                } onIndexChange: { index in
                    /// Updating Index
                    activeIndex = index
                }
                //.padding(.horizontal, -100)
                .frame(width: geometry.size.width, height: geometry.size.width / 1)
                //.offset(y: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        .padding(15)
    }
}

#Preview {
    ContentView()
}
