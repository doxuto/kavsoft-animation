//
//  AnimatedIcon.swift
//  AnimatedTabIcons
//
//  Created by Balaji on 03/08/22.
//

import SwiftUI
import Lottie

// MARK: Animated Icon Model
struct AnimatedIcon: Identifiable{
    var id: String = UUID().uuidString
    var tabIcon: Tab
    var lottieView: AnimationView
}
