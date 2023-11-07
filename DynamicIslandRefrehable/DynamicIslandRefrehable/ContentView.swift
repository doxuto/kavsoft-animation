//
//  ContentView.swift
//  DynamicIslandRefrehable
//
//  Created by Balaji on 26/09/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Let's Implement this our Resposnive UI Project
        CustomRefreshView(showsIndicator: false) {
            // MARK: Sample VIEW
            VStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.red.gradient)
                    .frame(height: 100)
                
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.blue.gradient)
                    .frame(height: 100)
            }
            .padding(15)
        } onRefresh: {
            // MARK: Your Action
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
