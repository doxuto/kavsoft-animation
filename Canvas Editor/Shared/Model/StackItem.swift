//
//  StackItem.swift
//  Canvas Editor (iOS)
//
//  Created by Balaji on 05/05/22.
//

import SwiftUI

// MARK: Holds Each Stack Item View
struct StackItem: Identifiable {
    var id = UUID().uuidString
    // MARK: Any View For More Customisation
    var view: AnyView
    
    // MARK: Gesture Properties
    // For Dragging
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    // For Scaling
    var scale: CGFloat = 1
    var lastScale: CGFloat = 1
    // For Rotation
    var rotation: Angle = .zero
    var lastRotation: Angle = .zero
}
