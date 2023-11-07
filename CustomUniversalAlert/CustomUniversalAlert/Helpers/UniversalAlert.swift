//
//  UniversalAlert.swift
//  CustomUniversalAlert
//
//  Created by Balaji Venkatesh on 18/09/23.
//

import SwiftUI

/// Alert Config
struct AlertConfig {
    fileprivate var enableBackgroundBlur: Bool = true
    fileprivate var disableOutsideTap: Bool = true
    fileprivate var transitionType: TransitionType = .slide
    fileprivate var slideEdge: Edge = .bottom
    fileprivate var show: Bool = false
    fileprivate var showView: Bool = false
    
    init(enableBackgroundBlur: Bool = true, disableOutsideTap: Bool = true, transitionType: TransitionType = .slide, slideEdge: Edge = .bottom) {
        self.enableBackgroundBlur = enableBackgroundBlur
        self.disableOutsideTap = disableOutsideTap
        self.transitionType = transitionType
        self.slideEdge = slideEdge
    }
    
    /// TransitionType
    enum TransitionType {
        case slide
        case opacity
    }
    
    /// Alert Present/Dismiss Methods
    mutating
    func present() {
        show = true
    }
    
    mutating
    func dismiss() {
        show = false
    }
}

/// App Delegate
@Observable
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        /// Setting SceneDelegate Class
        config.delegateClass = SceneDelegate.self
        return config
    }
}

/// Scene Delegate
@Observable
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    /// Current Scene
    weak var windowScene: UIWindowScene?
    var overlayWindow: UIWindow?
    var tag: Int = 0
    var alerts: [UIView] = []
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
        setupOverlayWindow()
    }
    
    /// Adding Overlay Window To Handle All our Alerts on the Top of the Current Window
    private func setupOverlayWindow() {
        guard let windowScene = windowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.isHidden = true
        window.isUserInteractionEnabled = false
        self.overlayWindow = window
        //print("Window Added")
    }
    
    fileprivate func alert<Content: View>(config: Binding<AlertConfig>, @ViewBuilder content: @escaping () -> Content, viewTag: @escaping (Int) -> ()) {
        guard let alertWindow = overlayWindow else { return }
        
        let viewController = UIHostingController(rootView:
            AlertView(config: config, tag: tag, content: {
                content()
            })
        )
        viewController.view.backgroundColor = .clear
        viewController.view.tag = tag
        viewTag(tag)
        tag += 1
        
        if alertWindow.rootViewController == nil {
            alertWindow.rootViewController = viewController
            alertWindow.isHidden = false
            alertWindow.isUserInteractionEnabled = true
        } else {
            //print("Exisiting Alert is Still Present")
            viewController.view.frame = alertWindow.rootViewController?.view.frame ?? .zero
            alerts.append(viewController.view)
        }
    }
}

/// Custom View Extensions
extension View {
    @ViewBuilder
    func alert<Content: View>(alertConfig: Binding<AlertConfig>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .modifier(AlertModifier(config: alertConfig, alertContent: content))
    }
}

/// Alert Handling View Modifier
fileprivate struct AlertModifier<AlertContent: View>: ViewModifier {
    @Binding var config: AlertConfig
    @ViewBuilder var alertContent: () -> AlertContent
    /// Scene Delegate
    @Environment(SceneDelegate.self) private var sceneDelegate
    /// View Tag
    @State private var viewTag: Int = 0
    func body(content: Content) -> some View {
        content
            .onChange(of: config.show, initial: false) { oldValue, newValue in
                if newValue {
                    /// Simply Call the Function we implemented on SCenedelegate
                    sceneDelegate.alert(config: $config, content: alertContent) { tag in
                        viewTag = tag
                    }
                } else {
                    guard let alertWindow = sceneDelegate.overlayWindow else { return }
                    if config.showView {
                        withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                            config.showView = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            if sceneDelegate.alerts.isEmpty {
                                alertWindow.rootViewController = nil
                                alertWindow.isHidden = true
                                alertWindow.isUserInteractionEnabled = false
                            } else {
                                /// Presenting Next Alert
                                if let first = sceneDelegate.alerts.first {
                                    /// Removing the Preview View
                                    alertWindow.rootViewController?.view.subviews.forEach({ view in
                                        view.removeFromSuperview()
                                    })
                                    
                                    alertWindow.rootViewController?.view.addSubview(first)
                                    /// Removing the Added alert from the Array
                                    sceneDelegate.alerts.removeFirst()
                                }
                            }
                        }
                    } else {
                        //print("View is Not Appeared")
                        /// Removing the view from the Array with the help of View Tag
                        sceneDelegate.alerts.removeAll(where: { $0.tag == viewTag })
                    }
                }
            }
    }
}

fileprivate struct AlertView<Content: View>: View {
    @Binding var config: AlertConfig
    /// View Tag
    var tag: Int
    @ViewBuilder var content: () -> Content
    /// View Properties
    @State private var showView: Bool = false
    var body: some View {
        GeometryReader(content: { geometry in
            if showView && config.transitionType == .slide {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: config.slideEdge))
            } else {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(showView ? 1 : 0)
            }
        })
        .background {
            ZStack {
                if config.enableBackgroundBlur {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.primary.opacity(0.25))
                }
            }
            .ignoresSafeArea()
            .contentShape(.rect)
            .onTapGesture {
                if !config.disableOutsideTap {
                    config.dismiss()
                }
            }
            .opacity(showView ? 1 : 0)
        }
        .onAppear(perform: {
            config.showView = true
        })
        .onChange(of: config.showView) { oldValue, newValue in
            withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                showView = newValue
            }
        }
    }
}
