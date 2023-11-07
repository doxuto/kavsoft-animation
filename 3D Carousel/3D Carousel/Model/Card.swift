//
//  Card.swift
//  3D Carousel
//
//  Created by Balaji on 28/10/22.
//

import SwiftUI

// MARK: Card Model
struct Card: Identifiable,Equatable{
    var id: String = UUID().uuidString
    var imageFile: String
}
