//
//  ContentView.swift
//  Custom Slider
//
//  Created by Balaji Venkatesh on 20/09/23.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var items: [Item] = [
        .init(color: .red, title: "World Clock", subTitle: "View the time in multiple cities around the world."),
        .init(color: .blue, title: "City Digital", subTitle: "Add a clock for a city to check the time at that location."),
        .init(color: .green, title: "City Analouge", subTitle: "Add a clock for a city to check the time at that location."),
        .init(color: .yellow, title: "Next Alarm", subTitle: "Display upcomiong alarm.")
    ]
    /// Customization Properties
    @State private var showPagingControl: Bool = false
    @State private var disablePagingInteraction: Bool = false
    @State private var pagingSpacing: CGFloat = 20
    @State private var titleScrollSpeed: CGFloat = 0.6
    @State private var stretchContent: Bool = false
    var body: some View {
        VStack {
            CustomPagingSlider(
                showPagingControl: showPagingControl,
                disablePagingInteraction: disablePagingInteraction,
                titleScrollSpeed: titleScrollSpeed,
                pagingControlSpacing: pagingSpacing,
                data: $items
            ) { $item in
                /// Content View
                RoundedRectangle(cornerRadius: 15)
                    .fill(item.color.gradient)
                    .frame(width: stretchContent ? nil : 150, height: stretchContent ? 220 : 120)
            } titleContent: { $item in
                /// Title View
                VStack(spacing: 5) {
                    Text(item.title)
                        .font(.largeTitle.bold())
                    
                    Text(item.subTitle)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .frame(height: 45)
                }
                .padding(.bottom, 35)
            }
            /// Use Safe Area Padding to avoid Clipping of ScrollView
            .safeAreaPadding([.horizontal, .top], 35)
            
            List {
                Toggle("Show Paging Control", isOn: $showPagingControl)
                
                Toggle("Disable Page Interaction", isOn: $disablePagingInteraction)
                
                Toggle("Stretch Content", isOn: $stretchContent)
                
                Section("Title Scroll Speed") {
                    Slider(value: $titleScrollSpeed)
                }
                
                Section("Paging Spacing") {
                    Slider(value: $pagingSpacing, in: 20...40)
                }
            }
            .clipShape(.rect(cornerRadius: 15))
            .padding(15)
        }
    }
}

#Preview {
    ContentView()
}
