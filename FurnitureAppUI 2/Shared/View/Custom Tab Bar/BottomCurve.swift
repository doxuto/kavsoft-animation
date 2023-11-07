//
//  BottomCurve.swift
//  BottomCurve
//
//  Created by Balaji on 09/09/21.
//

import SwiftUI

// Tab Bar Curve...
struct BottomCurve: Shape {

    var currentXValue: CGFloat
    
    // Animating Path...
    // it wont work on previews....
    var animatableData: CGFloat{
        get{currentXValue}
        set{currentXValue = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            // mid will be current XValue..
            let mid = currentXValue
            path.move(to: CGPoint(x: mid - 50, y: 0))
            
            let to1 = CGPoint(x: mid, y: 35)
            let control1 = CGPoint(x: mid - 25, y: 0)
            let control2 = CGPoint(x: mid - 25, y: 35)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            
            let to2 = CGPoint(x: mid + 50, y: 0)
            let control3 = CGPoint(x: mid + 25, y: 35)
            let control4 = CGPoint(x: mid + 25, y: 0)
            
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}

struct CustomTabBarShape_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
