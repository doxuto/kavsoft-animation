//
//  Animator.swift
//  FlightAppUI
//
//  Created by Balaji on 26/11/22.
//

import SwiftUI

// MARK: ObservableObject that holds all animation properties
class Animator: ObservableObject{
    /// Animation Properties
    @Published var startAnimation: Bool = false
    /// Initial Plane Position
    @Published var initialPlanePosition: CGRect = .zero
    @Published var currentPaymentStatus: PaymentStatus = .initated
    /// Rings Status
    @Published var ringAnimation: [Bool] = [false,false]
    /// Loading Status
    @Published var showLoadingView: Bool = false
    /// Cloud View Status
    @Published var showClouds: Bool = false
    /// Final View Status
    @Published var showFinalView: Bool = false
}
