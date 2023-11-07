//
//  TabTintAdjustment.swift
//  ShowcaseView
//
//  Created by Balaji on 13/05/23.
//

import SwiftUI

extension TabView {
    @ViewBuilder
    func tabTintAdjustment(color: Color = .blue, adjustment: UIView.TintAdjustmentMode = .automatic) -> some View {
        self
            .background {
                TabExtractor(color: color, adjustment: adjustment)
                    .frame(width: .zero, height: .zero)
            }
    }
}

fileprivate struct TabExtractor: UIViewRepresentable {
    var color: Color
    var adjustment: UIView.TintAdjustmentMode
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let subviews = uiView.superview?.superview?.subviews {
                for view in subviews {
                    if let tabbar = view.findTabBar {
                        tabbar.tintAdjustmentMode = adjustment
                        tabbar.tintColor = UIColor(color)
                    }
                }
            }
        }
    }
}

/// Extracting UITabbar From the Subviews
fileprivate extension UIView {
    var allSubViews: [UIView] {
        return subviews.flatMap { [$0] + $0.subviews }
    }
    
    /// Finiding the UIView is TextField or Not
    var findTabBar: UITabBar? {
        if let tabbar = allSubViews.first(where: { view in
            view is UITabBar
        }) as? UITabBar {
            return tabbar
        }
        
        return nil
    }
}
