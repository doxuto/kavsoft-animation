//
//  Page.swift
//  tvOSInfiniteCarousel
//
//  Created by Balaji on 19/04/23.
//

import Foundation
import SwiftUI

/// Page Model
struct Page: Identifiable, Hashable {
    var id: UUID = .init()
    var color: Color
    var isFocused: Bool = false
}
