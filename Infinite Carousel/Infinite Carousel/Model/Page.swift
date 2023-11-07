//
//  Page.swift
//  Infinite Carousel
//
//  Created by Balaji on 27/03/23.
//

import SwiftUI

/// Page Model
struct Page: Identifiable, Hashable {
    var id: UUID = .init()
    var color: Color
}
