//
//  HexagonShape.swift
//  QuizGame (iOS)
//
//  Created by Balaji on 14/02/22.
//

import SwiftUI

struct HexagonShape: Shape {
    
    var radius: CGFloat = 15
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            
            let pt1 = CGPoint(x: 0, y: 20)
            let pt2 = CGPoint(x: 0, y: rect.height - 20)
            let pt3 = CGPoint(x: rect.width / 2, y: rect.height)
            let pt4 = CGPoint(x: rect.width, y: rect.height - 20)
            let pt5 = CGPoint(x: rect.width, y: 20)
            let pt6 = CGPoint(x: rect.width / 2, y: 0)
            
            path.move(to: pt6)
            
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: radius)
            path.addArc(tangent1End: pt2, tangent2End: pt3, radius: radius)
            path.addArc(tangent1End: pt3, tangent2End: pt4, radius: radius)
            path.addArc(tangent1End: pt4, tangent2End: pt5, radius: radius)
            path.addArc(tangent1End: pt5, tangent2End: pt6, radius: radius)
            path.addArc(tangent1End: pt6, tangent2End: pt1, radius: radius)
        }
    }
}
