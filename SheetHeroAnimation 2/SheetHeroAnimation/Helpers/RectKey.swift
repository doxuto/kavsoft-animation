//
//  RectKey.swift
//  SheetHeroAnimation
//
//  Created by Balaji on 25/08/23.
//

import SwiftUI

/// Prefernce Key to Read View Bounds
struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
