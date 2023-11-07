//
//  Home.swift
//  TagTextField
//
//  Created by Balaji Venkatesh on 13/09/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var tags: [Tag] = []
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    TagField(tags: $tags)
                }
                .padding()
            }
            .navigationTitle("Tag Field")
        }
    }
}

#Preview {
    Home()
}
