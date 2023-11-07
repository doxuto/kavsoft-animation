//
//  CustomTabView.swift
//  CustomTabBarMac
//
//  Created by Balaji Venkatesh on 22/10/23.
//

import SwiftUI

/// Custom Tab Bar Which will Have option to hide Native macOS Tab Bar
struct CustomTabView<Content: View, T: Hashable>: View {
    var hideTabBar: Bool = true
    @Binding var selection: T
    @ViewBuilder var content: Content
    var body: some View {
        ScrollView(.init()) {
            TabView(selection: $selection) {
                content
            }
            .background(TabFinder(hide: hideTabBar))
        }
    }
}

/// Finding NSTabView and Hiding It
fileprivate struct TabFinder: NSViewRepresentable {
    var hide: Bool
    func makeNSView(context: Context) -> NSView {
        return .init()
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let superView = nsView.superview?.superview {
                if let tabView = superView.subviews(type: NSTabView.self).first {
                    tabView.tabPosition = hide ? .none : .top
                    tabView.tabViewBorderType = hide ? .none : .bezel
                }
            }
        }
    }
}

/// Finding NSView's in Subviews based on Class Type
fileprivate extension NSView {
    func subviews<Type: NSView>(type: Type.Type) -> [Type] {
        var views = subviews.compactMap({ $0 as? Type })
        /// Iterating through Each Subviews
        for subView in subviews {
            views.append(contentsOf: subView.subviews(type: type))
        }
        
        return views
    }
}
