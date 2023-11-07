//
//  WindowSharedModel.swift
//  SheetHeroAnimation
//
//  Created by Balaji on 24/08/23.
//

import SwiftUI

@Observable
class WindowSharedModel {
    var sourceRect: CGRect = .zero
    var previousSourceRect: CGRect = .zero
    var hideNativeView: Bool = false
    var selectedProfile: Profile?
    var cornerRadius: CGFloat = 0
    var showGradient: Bool = false
    
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
