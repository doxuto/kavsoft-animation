//
//  TabBarSheetApp.swift
//  TabBarSheet
//
//  Created by Balaji on 21/08/23.
//

import SwiftUI

@main
struct TabBarSheetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @StateObject private var windowSharedModel = WindowSharedModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(windowSharedModel)
        }
    }
}

/// App Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}

/// Scene Delegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    weak var windowScene: UIWindowScene?
    var tabWindow: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
    }
    
    /// Adding Tab Bar as an another Window
    func addTabBar(_ windowSharedModel: WindowSharedModel) {
        guard let scene = windowScene else {
            return
        }
        
        let tabBarController = UIHostingController(rootView:
            CustomTabBar()
            .environmentObject(windowSharedModel)
            .frame(maxHeight: .infinity, alignment: .bottom)
            /// To Ignore Tab Bar moving to Top, When Keyboard is Active
            .ignoresSafeArea(.keyboard, edges: .all)
        )
        tabBarController.view.backgroundColor = .clear
        /// Window
        let tabWindow = PassThroughWindow(windowScene: scene)
        tabWindow.rootViewController = tabBarController
        tabWindow.isHidden = false
        /// Stroing TabWindow Reference, For Future Use
        self.tabWindow = tabWindow
    }
}

/// PassThrough UIWindow
class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}
