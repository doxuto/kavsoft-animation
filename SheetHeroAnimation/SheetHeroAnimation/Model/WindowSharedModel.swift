//
//  WindowSharedModel.swift
//  SheetHeroAnimation
//
//  Created by Balaji on 24/08/23.
//

import SwiftUI

class WindowSharedModel: ObservableObject {
    @Published var sourceRect: CGRect = .zero
    @Published var previousSourceRect: CGRect = .zero
    @Published var hideNativeView: Bool = false
    @Published var selectedProfile: Profile?
    @Published var cornerRadius: CGFloat = 0
    @Published var showGradient: Bool = false
    
    /// Reseting Properties
    func reset() {
        sourceRect = .zero
        previousSourceRect = .zero
        hideNativeView = false
        selectedProfile = nil
        cornerRadius = 0
        showGradient = false
    }
}
