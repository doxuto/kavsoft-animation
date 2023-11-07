//
//  MotionManager.swift
//  ParallaxCards
//
//  Created by Balaji on 11/07/22.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    // MARK: Motion Manager Properties
    @Published var manager: CMMotionManager = .init()
    @Published var xValue: CGFloat = 0
    // MARK: Current Slide
    @Published var currentSlide: Place = sample_places.first!
    
    func detectMotion(){
        if !manager.isDeviceMotionActive{
            // MARK: For Memory Usage
            // I'm Limiting it to 40 FPS Per sec
            // You Can Update for that Your wish
            // But Please Conisder Memory Usage Too
            manager.deviceMotionUpdateInterval = 1/40
            manager.startDeviceMotionUpdates(to: .main) {[weak self] motion, err in
                if let attitude = motion?.attitude{
                    // MARK: Obtaining Device Roll Value
                    self?.xValue = attitude.roll
                    print(attitude.roll)
                }
            }
        }
    }
    
    // MARK: Stopping Updates When It's Not Necessary
    func stopMotionUpdates(){
        manager.stopDeviceMotionUpdates()
    }
}
