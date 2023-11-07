//
//  ContentView.swift
//  SwipeToHideNavBar
//
//  Created by Balaji Venkatesh on 09/09/23.
//

import SwiftUI

struct ContentView: View {
    @State private var hideNavBar: Bool = true
    var body: some View {
        NavigationStack {
            List {
                ForEach(1...50, id: \.self) { index in
                    NavigationLink {
                        List {
                            ForEach(1...50, id: \.self) { index in
                                Text("Sub Item \(index)")
                            }
                        }
                        .navigationTitle("Item \(index)")
                        .hideNavBarOnSwipe(false)
                    } label: {
                        Text("List Item \(index)")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Chat App")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        hideNavBar.toggle()
                    }, label: {
                        Image(systemName: !hideNavBar ? "eye.slash" : "eye")
                    })
                }
            })
            .hideNavBarOnSwipe(hideNavBar)
        }
    }
}

#Preview {
    ContentView()
}
