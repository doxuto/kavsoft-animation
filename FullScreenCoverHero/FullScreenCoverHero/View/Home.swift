//
//  Home.swift
//  FullScreenCoverHero
//
//  Created by Balaji on 05/02/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var show: Bool = false
    @State private var selectedRow: Row = .init(color: .clear)
    @Namespace private var animation
    @State private var regularSheet: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 5), count: 3), spacing: 5) {
                ForEach(rows){ row in
                    if selectedRow.id == row.id {
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 100)
                    } else {
                        Rectangle()
                            .fill(row.color.gradient)
                            .matchedGeometryEffect(id: row.id.uuidString, in: animation)
                            .frame(height: 100)
                            .onTapGesture {
                                /// Adding Animation
                                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                                    selectedRow = row
                                    show.toggle()
                                }
                            }
                    }
                }
            }
            .padding(15)
            .overlay(alignment: .bottom) {
                Button("Regular Screen Cover") {
                    regularSheet.toggle()
                }
                .offset(y: 25)
            }
        }
        .fullScreenCover(isPresented: $regularSheet, content: {
            Rectangle()
                .fill(.red.gradient)
                .ignoresSafeArea()
                .overlay {
                    Button("Close") {
                        regularSheet.toggle()
                    }
                    .tint(.white)
                }
        })
        .heroFullScreenCover(show: $show) {
            /// Detail View
            DetailView(row: $selectedRow, animationID: animation)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
