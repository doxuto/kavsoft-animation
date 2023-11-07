//
//  OffsetModifier.swift
//  AppleWalletScroll (iOS)
//
//  Created by Balaji on 17/02/22.
//

import SwiftUI

struct OffsetModifier: ViewModifier {
    // Optional
    var coordinateSpace: String = ""
    var rect: (CGRect)->()
    
    func body(content: Content) -> some View {
        
        content
            .overlay {
                GeometryReader{proxy in
                    Color.clear
                        .preference(key: OffsetKey.self, value: proxy.frame(in: .named(coordinateSpace)))
                }
            }
            .onPreferenceChange(OffsetKey.self) { rect in
                self.rect(rect)
            }
    }
}

// OffsetKey
struct OffsetKey: PreferenceKey{
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
