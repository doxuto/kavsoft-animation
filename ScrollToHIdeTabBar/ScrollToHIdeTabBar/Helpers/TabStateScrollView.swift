//
//  TabStateScrollView.swift
//  ScrollToHIdeTabBar
//
//  Created by Balaji on 30/07/23.
//

import SwiftUI

/// Custom View
struct TabStateScrollView<Content: View>: View {
    var axis: Axis.Set
    var showsIndicator: Bool
    @Binding var tabState: Visibility
    var content: Content
    init(axis: Axis.Set, showsIndicator: Bool, tabState: Binding<Visibility>, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.showsIndicator = showsIndicator
        self._tabState = tabState
        self.content = content()
    }
        
    var body: some View {
        /// This Project Supports iOS 16 & iOS 17
        if #available(iOS 17, *) {
            ScrollView(axis) {
                content
            }
            .scrollIndicators(showsIndicator ? .visible : .hidden)
            .background {
                CustomGesture {
                    handleTabState($0)
                }
            }
        } else {
            ScrollView(axis, showsIndicators: showsIndicator, content: {
                content
            })
            .background {
                CustomGesture {
                    handleTabState($0)
                }
            }
        }
    }
    
    /// Handling Tab State on Swipe
    func handleTabState(_ gesture: UIPanGestureRecognizer) {
        let velocityY = gesture.velocity(in: gesture.view).y
        
        /// Method 1 - Using Velocity
        if velocityY < 0 {
            /// Swiping Up
            if -(velocityY / 5) > 60 && tabState == .visible {
                tabState = .hidden
            }
        } else {
            /// Swiping Down
            if (velocityY / 5) > 40 && tabState == .hidden {
                tabState = .visible
            }
        }
        
        /// Method 2 - Using Translation + Velocity
        
//        let offsetY = gesture.translation(in: gesture.view).y + (velocityY / 10)
//
//        if velocityY < 0 {
//            /// Swiping Up
//            if -offsetY > 60 && tabState == .visible {
//                tabState = .hidden
//            }
//        } else {
//            /// Swiping Down
//            if offsetY > 40 && tabState == .hidden {
//                tabState = .visible
//            }
//        }
    }
}

/// Adding a Custom Simultaneous UIPan Gesture to know about what direction did the user is swiping
fileprivate struct CustomGesture: UIViewRepresentable {
    var onChange: (UIPanGestureRecognizer) -> ()
    /// Gesture ID
    private let gestureID = UUID().uuidString
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onChange: onChange)
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            /// Verifying if there is already any gesture is Added
            if let superView = uiView.superview?.superview, !(superView.gestureRecognizers?.contains(where: { $0.name == gestureID }) ?? false) {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                gesture.name = gestureID
                gesture.delegate = context.coordinator
                /// Adding Gesture to the SuperView
                superView.addGestureRecognizer(gesture)
            }
        }
    }
    
    /// Selector Class
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChange: (UIPanGestureRecognizer) -> ()
        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }
        
        @objc
        func gestureChange(gesture: UIPanGestureRecognizer) {
            /// Simply Calling the onChange Callback
            onChange(gesture)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}

#Preview {
    ContentView()
}
