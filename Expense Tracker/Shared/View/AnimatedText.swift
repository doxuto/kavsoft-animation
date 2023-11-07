//
//  AnimatedText.swift
//  Expense Tracker (iOS)
//
//  Created by Balaji on 19/03/22.
//

import SwiftUI

struct AnimatedNumberText: Animatable,View {
    var value: CGFloat
    // Optional Properties
    var font: Font
    var floatingPoint: Int = 2
    var isCurrency: Bool = false
    var additionalString: String = ""
    
    var animatableData: CGFloat{
        get{value}
        set{value = newValue}
    }
    var body: some View {
        Text("\(isCurrency ? "$" : "")\(String(format: "%.\(floatingPoint)f", value))" + additionalString)
            .font(font)
    }
}
