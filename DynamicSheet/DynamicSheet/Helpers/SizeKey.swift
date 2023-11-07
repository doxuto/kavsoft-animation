//
//  SizeKey.swift
//  DynamicSheet
//
//  Created by Balaji on 08/08/23.
//

import SwiftUI

struct SizeKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
