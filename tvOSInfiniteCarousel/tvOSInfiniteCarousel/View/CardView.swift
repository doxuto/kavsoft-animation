//
//  CardView.swift
//  tvOSInfiniteCarousel
//
//  Created by Balaji on 19/04/23.
//

import SwiftUI

struct CardView: View {
    @Binding var link: Page
    var size: CGSize
    @FocusState private var isFocused: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(link.color.gradient)
            .frame(width: size.width - 50, height: size.height)
            .frame(width: size.width)
            .focusable()
            .focused($isFocused)
            .onChange(of: link.isFocused) { newValue in
                if newValue {
                    isFocused = true
                    link.isFocused = false
                }
            }
    }
}
