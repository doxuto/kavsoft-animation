//
//  View+Extensions.swift
//  TabBarSheet
//
//  Created by Balaji on 23/08/23.
//

import SwiftUI

/// Custom View Modifiers
extension View {
    @ViewBuilder
    func hideNativeTabBar() -> some View {
        self
            .toolbar(.hidden, for: .tabBar)
    }
}

/// Custom TabView Modifier
extension TabView {
    @ViewBuilder
    func tabSheet<SheetContent: View>(initialHeight: CGFloat = 100, sheetCornerRadius: CGFloat = 15, @ViewBuilder content: @escaping () -> SheetContent) -> some View {
        self
            .modifier(BottomSheetModifier(initialHeight: initialHeight, sheetCornerRadius: sheetCornerRadius, sheetView: content()))
    }
}

/// Helper View Modifier
fileprivate struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    var initialHeight: CGFloat
    var sheetCornerRadius: CGFloat
    var sheetView: SheetContent
    /// View Properties
    @State private var showSheet: Bool = true
    @EnvironmentObject private var sceneDelegate: SceneDelegate
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showSheet, content: {
                VStack(spacing: 0) {
                    sheetView
                        .background(.regularMaterial)
                        .zIndex(0)
                    
                    Divider()
                        .hidden()
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 55)
                }
                .presentationDetents([.height(initialHeight), .medium, .fraction(0.99)])
                .addSheetProperties(sheetCornerRadius)
                .interactiveDismissDisabled()
                .onAppear {
                    if let controller = sceneDelegate.windowScene?.windows.first?.rootViewController?.presentedViewController, let sheet = controller.presentationController as? UISheetPresentationController, #unavailable(iOS 16.4) {
                        sheet.preferredCornerRadius = sheetCornerRadius
                        sheet.largestUndimmedDetentIdentifier = .medium
                        controller.view.backgroundColor = .clear
                    }
                }
            })
    }
}

extension View {
    @ViewBuilder
    func addSheetProperties(_ cornerRadius: CGFloat) -> some View {
        if #available(iOS 16.4, *) {
            self
                .presentationCornerRadius(cornerRadius)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .presentationBackground(.clear)
        } else {
            self
        }
    }
}

/// Clearing Background's Of View like NavigationStack and TabView
struct ClearBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
}
