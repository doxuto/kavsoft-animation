//
//  Home.swift
//  PS TabBar
//
//  Created by Balaji on 20/02/23.
//

import SwiftUI

struct Home: View {
    /// Tab Bar Properties
    @State private var activeTab: Tab = .play
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            /// Custom Tab Bar
            CustomTabBar(activeTab: $activeTab)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(Color("BG"))
                .ignoresSafeArea()
        }
        /// Hiding the home view indicator at the bottom
        .persistentSystemOverlays(.hidden)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
