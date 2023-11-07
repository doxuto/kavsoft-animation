//
//  FullSwipeNavigationStack.swift
//  FullScreenPop
//
//  Created by Balaji Venkatesh on 08/10/23.
//

import SwiftUI

/// Custom View
struct FullSwipeNavigationStack<Content: View>: View {
    @ViewBuilder var content: Content
    /// Full Swipe Custom Gesture
    @State private var customGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = UUID().uuidString
        gesture.isEnabled = false
        return gesture
    }()
    var body: some View {
        NavigationStack {
            content
                .background {
                    AttachGestureView(gesture: $customGesture)
                }
        }
        .environment(\.popGestureID, customGesture.name)
        .onReceive(NotificationCenter.default.publisher(for: .init(customGesture.name ?? "")), perform: { info in
            if let userInfo = info.userInfo, let status = userInfo["status"] as? Bool {
                customGesture.isEnabled = status
            }
        })
    }
}

extension View {
    @ViewBuilder
    func enableFullSwipePop(_ isEnabled: Bool) -> some View {
        self
            .modifier(FullSwipeModifier(isEnabled: isEnabled))
    }
}

/// Custom Environment Key for Passing Gesture ID to it's subviews
fileprivate struct PopNotificationID: EnvironmentKey {
    static var defaultValue: String?
}

fileprivate extension EnvironmentValues {
    var popGestureID: String? {
        get {
            self[PopNotificationID.self]
        }
        
        set {
            self[PopNotificationID.self] = newValue
        }
    }
}

/// Helper View Modifier
fileprivate struct FullSwipeModifier: ViewModifier {
    var isEnabled: Bool
    /// Gesture ID
    @Environment(\.popGestureID) private var gestureID
    func body(content: Content) -> some View {
        content
            .onChange(of: isEnabled, initial: true) { oldValue, newValue in
                guard let gestureID = gestureID else { return }
                NotificationCenter.default.post(name: .init(gestureID), object: nil, userInfo: [
                    "status": newValue
                ])
            }
            .onDisappear(perform: {
                guard let gestureID = gestureID else { return }
                NotificationCenter.default.post(name: .init(gestureID), object: nil, userInfo: [
                    "status": false
                ])
            })
    }
}

/// Helper Files
fileprivate struct AttachGestureView: UIViewRepresentable {
    @Binding var gesture: UIPanGestureRecognizer
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            /// Finding Parent Controller
            if let parentViewController = uiView.parentViewController {
                if let navigationController = parentViewController.navigationController {
                    /// Checking if already the gesture has been added to the controller
                    if let _ = navigationController.view.gestureRecognizers?.first(where: { $0.name == gesture.name }) {
                        print("Already Attached")
                    } else {
                        navigationController.addFullSwipeGesture(gesture)
                        print("Attached")
                    }
                }
            }
        }
    }
}

fileprivate extension UINavigationController {
    /// Adding Custom FullSwipe Gesture
    /// Special thanks for this SO Answer
    /// https://stackoverflow.com/questions/20714595/extend-default-interactivepopgesturerecognizer-beyond-screen-edge
    func addFullSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureSelector = interactivePopGestureRecognizer?.value(forKey: "targets") else { return }
        
        gesture.setValue(gestureSelector, forKey: "targets")
        view.addGestureRecognizer(gesture)
    }
}

fileprivate extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) {
            $0.next
        }.first(where: { $0 is UIViewController}) as? UIViewController
    }
}

#Preview {
    ContentView()
}
