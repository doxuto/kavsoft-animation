//
//  ContentView.swift
//  ScrollToHIdeTabBar
//
//  Created by Balaji on 30/07/23.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var tabState: Visibility = .visible
    var body: some View {
        TabView {
            NavigationStack {
                TabStateScrollView(axis: .vertical, showsIndicator: false, tabState: $tabState) {
                    /// Any Scroll Content
                    VStack(spacing: 15) {
                        ForEach(1...8, id: \.self) { index in
                            GeometryReader(content: { geometry in
                                let size = geometry.size
                                
                                Rectangle()
                                    .fill(.red.gradient)
                                    .frame(width: size.width, height: size.height)
                                    .clipShape(.rect(cornerRadius: 12))
                            })
                            .frame(height: 180)
                        }
                    }
                    .padding(15)
                }
                .navigationTitle("Home")
            }
            .toolbar(tabState, for: .tabBar)
            .animation(.easeInOut(duration: 0.3), value: tabState)
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            /// Other Sample Tab's
            NavigationStack {
                TabStateScrollView(axis: .vertical, showsIndicator: false, tabState: $tabState, content: {
                    VStack(spacing: 10) {
                        ForEach(1...30, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.red.gradient)
                                .frame(height: 50)
                        }
                    }
                    .padding(15)
                })
                .navigationTitle("Favourites")
            }
            .toolbar(tabState, for: .tabBar)
            .animation(.easeInOut(duration: 0.3), value: tabState)
            .tabItem {
                Image(systemName: "suit.heart")
                Text("Favourites")
            }
            
            Text("Notifications")
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            
            Text("Account")
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
        }
    }
}

#Preview {
    ContentView()
}
