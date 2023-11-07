//
//  View+Extensions.swift
//  DynamicSheet
//
//  Created by Balaji on 08/08/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func heightChangePreference(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader(content: { geometry in
                    Color.clear
                        .preference(key: SizeKey.self, value: geometry.size.height)
                        .onPreferenceChange(SizeKey.self, perform: { value in
                            completion(value)
                        })
                })
            }
    }
    
    @ViewBuilder
    func minXChangePreference(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader(content: { geometry in
                    Color.clear
                        .preference(key: OffsetKey.self, value: geometry.frame(in: .scrollView).minX)
                        .onPreferenceChange(OffsetKey.self, perform: { value in
                            completion(value)
                        })
                })
            }
    }
}
