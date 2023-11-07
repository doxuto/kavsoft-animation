//
//  View+Extensions.swift
//  DarkModeAnimation
//
//  Created by Balaji Venkatesh on 27/09/23.
//

import SwiftUI

// MARK: Steps
/// Step 1
/// Wrap the App's Main Content with DarkModeWrapper.
/// Step 2
/// Now Simply Use Dark Mode Button where ever you actually want to place the dark mode button.

/// Create's an Overlay for Dark Mode Animation
struct DarkModeWrapper<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var overlayWindow: UIWindow?
    @AppStorage("activateDarkMode") private var activateDarkMode: Bool = false
    var body: some View {
        content
            .onAppear(perform: {
                if overlayWindow == nil {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let overlayWindow = UIWindow(windowScene: windowScene)
                        overlayWindow.tag = 0320
                        overlayWindow.isHidden = false
                        overlayWindow.isUserInteractionEnabled = false
                        self.overlayWindow = overlayWindow
                    }
                }
            })
            .onChange(of: activateDarkMode, initial: true) { oldValue, newValue in
                if let keyWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow }) {
                    keyWindow.overrideUserInterfaceStyle = newValue ? .dark : .light
                }
            }
    }
}

/// Simple to use Dark Mode Button
struct DarkModeButton: View {
    @State private var buttonRect: CGRect = .zero
    @AppStorage("toggleDarkMode") private var toggleDarkMode: Bool = false
    @AppStorage("activateDarkMode") private var activateDarkMode: Bool = false
    var body: some View {
        Button(action: {
            toggleDarkMode.toggle()
            animateScheme()
        }, label: {
            Image(systemName: toggleDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.title2)
                .foregroundStyle(Color.primary)
                .symbolEffect(.bounce, value: toggleDarkMode)
                .frame(width: 40, height: 40)
        })
        .buttonStyle(.plain)
        .rect { rect in
            buttonRect = rect
        }
    }
    
    @MainActor
    func animateScheme() {
        Task {
            if let windows = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows, let window = windows.first(where: { $0.isKeyWindow }), let overlayWindow = windows.first(where: { $0.tag == 0320 }) {
                
                overlayWindow.isUserInteractionEnabled = true
                let imageView = UIImageView()
                imageView.frame = window.frame
                imageView.image = window.image(window.frame.size)
                imageView.contentMode = .scaleAspectFit
                overlayWindow.addSubview(imageView)
                
                let frameSize = window.frame.size
                /// Creating Snapshots
                /// Old One
                activateDarkMode = !toggleDarkMode
                let previousImage = window.image(frameSize)
                /// New One with Updated Trait State
                activateDarkMode = toggleDarkMode
                /// Giving some time to complete the transition
                try await Task.sleep(for: .seconds(0.01))
                let currentImage = window.image(frameSize)
                
                try await Task.sleep(for: .seconds(0.01))
                
                let swiftUIView = OverlayView(buttonRect: buttonRect, previousImage: previousImage, currentImage: currentImage)
                
                let hostingController = UIHostingController(rootView: swiftUIView)
                hostingController.view.backgroundColor = .clear
                hostingController.view.frame = window.frame
                hostingController.view.tag = 1009
                overlayWindow.addSubview(hostingController.view)
                imageView.removeFromSuperview()
            }
        }
    }
}

/// Finding View's Position on the screen Coordinate Space
struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func rect(value: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader(content: { geometry in
                    let rect = geometry.frame(in: .global)
                    
                    Color.clear
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: { rect in
                            value(rect)
                        })
                })
            }
    }
}

/// Dark Mode Animation View
fileprivate struct OverlayView: View {
    var buttonRect: CGRect
    @State var previousImage: UIImage?
    @State var currentImage: UIImage?
    /// View Properties
    @State private var maskAnimation: Bool = false
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let maskRadius = size.height / 10
            
            if let previousImage, let currentImage {
                ZStack {
                    Image(uiImage: previousImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width, height: size.height)
                    
                    Image(uiImage: currentImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width, height: size.height)
                        .mask(alignment: .topLeading) {
                            Circle()
                                .frame(width: buttonRect.width * (maskAnimation ? maskRadius : 1), height: buttonRect.height * (maskAnimation ? maskRadius : 1), alignment: .bottomLeading)
                                .frame(width: buttonRect.width, height: buttonRect.height)
                                .offset(x: buttonRect.minX, y: buttonRect.minY)
                                .ignoresSafeArea()
                        }
                }
                .task {
                    guard !maskAnimation else { return }
                    
                    withAnimation(.easeInOut(duration: 0.9), completionCriteria: .logicallyComplete) {
                        maskAnimation = true
                    } completion: {
                        self.previousImage = nil
                        self.currentImage = nil
                        maskAnimation = false
                        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == 0320 }) {
                            /// Removing all views from the Overlay Window
                            for view in window.subviews {
                                view.removeFromSuperview()
                            }
                            window.isUserInteractionEnabled = false
                        }
                    }
                }
            }
        })
        /// Reverse Masking
        .mask({
            Rectangle()
                .overlay(alignment: .topLeading) {
                    Circle()
                        .frame(width: buttonRect.width, height: buttonRect.height)
                        .offset(x: buttonRect.minX, y: buttonRect.minY)
                        .blendMode(.destinationOut)
                }
        })
        .ignoresSafeArea()
    }
}

/// Converting UIView to UIImage
fileprivate extension UIView {
    func image(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            drawHierarchy(in: .init(origin: .zero, size: size), afterScreenUpdates: true)
        }
    }
}
