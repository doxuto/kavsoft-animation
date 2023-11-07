//
//  Tag.swift
//  Tagging (iOS)
//
//  Created by Balaji on 07/10/21.
//

import SwiftUI

// Tag Model...
struct Tag: Identifiable,Hashable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}
