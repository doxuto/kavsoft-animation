//
//  Navigation+Extension.swift
//  SwipeToHideNavBar
//
//  Created by Balaji Venkatesh on 09/09/23.
//

import SwiftUI

/// Custom View Modifier
extension View {
    @ViewBuilder
    func hideNavBarOnSwipe(_ isHidden: Bool) -> some View {
        self
            .modifier(NavBarModifier(isHidden: isHidden))
    }
}

private struct NavBarModifier: ViewModifier {
    var isHidden: Bool
    @State private var isNavBarHidden: Bool?
    func body(content: Content) -> some View {
        content
            .onChange(of: isHidden, initial: true, { oldValue, newValue in
                isNavBarHidden = newValue
            })
            .onDisappear(perform: {
                isNavBarHidden = nil
            })
            .background {
                NavigationControllerExtractor(isHidden: isNavBarHidden)
            }
    }
}

/// Extracting UINavigationController from SwiftUI View
private struct NavigationControllerExtractor: UIViewRepresentable {
    var isHidden: Bool?
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let parentController = uiView.parentController {
                if parentController.navigationController != nil {
                    if let isHidden {
                        parentController.navigationController?.hidesBarsOnSwipe = isHidden
                    }
                } else {
                    print("No Navigation Controller Found")
                }
            }
        }
    }
}

private extension UIView {
    var parentController: UIViewController? {
        sequence(first: self) { view in
            view.next
        }
        .first { responder in
            return responder is UIViewController
        } as? UIViewController
    }
}

#Preview {
    ContentView()
}
