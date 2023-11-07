//
//  AnchorKeys.swift
//  FlightAppUI
//
//  Created by Balaji on 26/11/22.
//

import SwiftUI

// MARK: Anchor Preference Key
struct RectKey: PreferenceKey{
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){$1}
    }
}
