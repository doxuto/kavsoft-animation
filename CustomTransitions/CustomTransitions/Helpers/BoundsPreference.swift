//
//  BoundsPreference.swift
//  CustomTransitions
//
//  Created by Balaji on 09/07/22.
//

import SwiftUI

struct BoundsPreference: PreferenceKey {
    // MARK: Storing All the Bounds Value With Message ID as Key
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){$1}
    }
}
