//
//  iOSOnboardingStyle26App.swift
//  iOSOnboardingStyle26
//
//  Created by Toan Doan on 4/3/26.
//

import SwiftUI

@main
struct iOSOnboardingStyle26App: App {
    var body: some Scene {
        let image = UIImage(named: "screen")
        let title = "Welcome to iOS 26"
        let subtitle = "Introducting a new desgin with \n Liquid Glass."
        WindowGroup {
            OnboardingView(items: [
                .init(
                    id: 0,
                    title: title,
                    subtitle: subtitle,
                    screenshot: image,
                    zoomScale: 1.2,
                    zoomAnchor: .center,
                    offset: CGSize.init(width: 0, height: 50)
                ),
                .init(
                    id: 1,
                    title: title,
                    subtitle: subtitle,
                    screenshot: image,
                    zoomScale: 1.0,
                    zoomAnchor: .center
                ),
                .init(
                    id: 2,
                    title: title,
                    subtitle: subtitle,
                    screenshot: image,
                    zoomScale: 1.3,
                    zoomAnchor: .bottom
                ),
                .init(
                    id: 3,
                    title: title,
                    subtitle: subtitle,
                    screenshot: image,
                    zoomScale: 1.2,
                    zoomAnchor: .init(x: 0.5, y: -0.15)
                ),
                .init(
                    id: 4,
                    title: title,
                    subtitle: subtitle,
                    screenshot: image,
                    zoomScale: 1.1,
                    zoomAnchor: .init(x: 0.5, y: -0.2)
                ),

            ])
        }
    }
}
