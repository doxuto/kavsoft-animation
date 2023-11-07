//
//  IndicatorShape.swift
//  Expense Tracker (iOS)
//
//  Created by Balaji on 19/03/22.
//

import SwiftUI

struct IndicatorShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path{path in
            let width = rect.width
            let height = rect.height
            
            path.move(to: CGPoint(x: width / 2, y: 0))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
        }
    }
}
