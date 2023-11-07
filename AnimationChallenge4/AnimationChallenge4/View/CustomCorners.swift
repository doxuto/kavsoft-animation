//
//  CustomCorners.swift
//  AnimationChallenge4
//
//  Created by Balaji on 15/06/22.
//

import SwiftUI

struct CustomCorners: Shape{
    var corners: UIRectCorner
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return .init(path.cgPath)
    }
}
