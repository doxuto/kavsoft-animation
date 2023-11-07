//
//  View+Extensions.swift
//  CustomVideoPlayer
//
//  Created by Balaji on 28/04/23.
//

import SwiftUI


/// Device Rotation Modifier
struct DeviceRotationModifier: ViewModifier {
    let onRotate: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                onRotate(UIDevice.current.orientation)
            }
    }
}

/// Custom View Modifier, Which Detects and tells Device Rotation
extension View {
    func onRotate(onRotate: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationModifier(onRotate: onRotate))
    }
}
