//
//  Tag.swift
//  TagTextField
//
//  Created by Balaji Venkatesh on 13/09/23.
//

import SwiftUI

/// Tag Model
struct Tag: Identifiable, Hashable {
    var id: UUID = .init()
    var value: String
    var isInitial: Bool = false
    var isFocused: Bool = false
}
