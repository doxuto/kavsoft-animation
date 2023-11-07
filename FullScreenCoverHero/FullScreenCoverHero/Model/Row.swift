//
//  Row.swift
//  FullScreenCoverHero
//
//  Created by Balaji on 05/02/23.
//

import SwiftUI

/// Row Model with sample data
struct Row: Identifiable, Hashable {
    var id = UUID()
    var color: Color
}

var rows: [Row] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .black),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .pink),
    .init(color: .purple),
    .init(color: .cyan),
]
