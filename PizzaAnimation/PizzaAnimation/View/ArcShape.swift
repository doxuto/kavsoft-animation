//
//  ArcShape.swift
//  PizzaAnimation
//
//  Created by Balaji on 03/07/22.
//

import SwiftUI

// MARK: Arc Shape Arrows For Swipe Direction
struct ArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path{path in
            let midWidth = rect.width / 2
            let width = rect.width
            path.move(to: .zero)
            path.addCurve(to: CGPoint(x: width, y: 0), control1: CGPoint(x: midWidth, y: -80), control2: CGPoint(x: midWidth, y: -80))
        }
    }
}
