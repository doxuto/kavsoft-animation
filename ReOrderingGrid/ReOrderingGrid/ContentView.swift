//
//  ContentView.swift
//  ReOrderingGrid
//
//  Created by Balaji on 01/07/23.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var colors: [Color] = [.red, .blue, .purple, .yellow, .black, .indigo, .cyan, .brown, .mint, .orange]
    @State private var draggingItem: Color?
    @State private var dualGrid: Bool = false
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                let columns = Array(repeating: GridItem(spacing: 10), count: dualGrid ? 2 : 3)
                LazyVGrid(columns: columns, spacing: 10, content: {
                    ForEach(colors, id: \.self) { color in
                        GeometryReader {
                            let size = $0.size
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(color.gradient)
                                /// Drag
                                .draggable(color) {
                                    /// Custom Preview View
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.ultraThinMaterial)
                                        .frame(width: size.width, height: size.height)
                                        .onAppear {
                                            draggingItem = color
                                        }
                                }
                                /// Drop
                                .dropDestination(for: Color.self) { items, location in
                                    draggingItem = nil
                                    return false
                                } isTargeted: { status in
                                    if let draggingItem, status, draggingItem != color {
                                        /// Moving Color from source to destination
                                        if let sourceIndex = colors.firstIndex(of: draggingItem),
                                           let destinationIndex = colors.firstIndex(of: color) {
                                            withAnimation(.bouncy) {
                                                let sourceItem = colors.remove(at: sourceIndex)
                                                colors.insert(sourceItem, at: destinationIndex)
                                            }
                                        }
                                    }
                                }

                        }
                        .frame(height: dualGrid ? 180 : 100)
                    }
                })
                .padding(15)
            }
            .navigationTitle("Movable Grid")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.bouncy) {
                            dualGrid.toggle()
                        }
                    } label: {
                        Image(systemName: dualGrid ? "square.grid.3x2" : "square.grid.2x2")
                            .font(.title3)
                    }
                }
            })
        }
    }
}

#Preview {
    ContentView()
}
