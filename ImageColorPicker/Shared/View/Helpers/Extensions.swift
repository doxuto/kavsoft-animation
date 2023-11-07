//
//  Extensions.swift
//  ImageColorPicker (iOS)
//
//  Created by Balaji on 13/01/23.
//

import SwiftUI

// MARK: Simple Extension to find whether the color is dark or light
extension Color{
    var isDarkColor: Bool {
        return UIColor(self).isDarkColor
    }
}

extension UIColor{
    var isDarkColor: Bool {
        var (r, g, b, a): (CGFloat,CGFloat,CGFloat,CGFloat) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
    
    var hexString: String? {
        guard let components = self.cgColor.components else { return nil }

        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
}
