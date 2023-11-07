//
//  SheetHeroAnimationApp.swift
//  SheetHeroAnimation
//
//  Created by Balaji on 23/08/23.
//

import SwiftUI

@main
struct SheetHeroAnimationApp: App {
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
        /// Connection Scene Delegate
        config.delegateClass = SceneDelegate.self
        return config
    }
}

/// Scene Delegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    weak var windowScene: UIWindowScene?
    
    /// Hero Overlay Window
    var heroWindow: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
    }
    
    /// Adding Hero Window to the Scene
    func addHeroWindow(_ windowSharedModel: WindowSharedModel) {
        guard let scene = windowScene else { return }
        
        let heroViewController = UIHostingController(rootView:
            CustomHeroAnimationView()
            .environmentObject(windowSharedModel)
             /// Since We Don't Need Any Interaction
            .allowsHitTesting(false)
        )
        heroViewController.view.backgroundColor = .clear
        let heroWindow = UIWindow(windowScene: scene)
        heroWindow.rootViewController = heroViewController
        heroWindow.isHidden = false
        heroWindow.isUserInteractionEnabled = false
        /// Storing Window Reference
        self.heroWindow = heroWindow
    }
}
