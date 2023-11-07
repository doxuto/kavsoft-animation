//
//  CustomCorner.swift
//  AnimationsTutorial (iOS)
//
//  Created by Balaji on 20/01/22.
//

import SwiftUI

struct CustomCorner: Shape{
    var corners: UIRectCorner
    var radius: CGFloat
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
