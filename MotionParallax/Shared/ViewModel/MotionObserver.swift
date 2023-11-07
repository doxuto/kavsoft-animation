//
//  MotionObserver.swift
//  MotionParallax (iOS)
//
//  Created by Balaji on 23/11/21.
//

import SwiftUI
// Importing Core Motion..
import CoreMotion

class MotionObserver: ObservableObject {
    
    // Motion Manager...
    @Published var motionManager = CMMotionManager()
    
    // Storing Motion Data to animate view in parallax..
    // Note
    // roll -> X-Axis
    // pitch -> Y-Axis...
    @Published var xValue: CGFloat = 0
    @Published var yValue: CGFloat = 0
    
    // Moving Offset....
    @Published var movingOffset: CGSize = .zero
    
    func fetchMotionData(duration: CGFloat){
        
        // Calling Motion updates handler...
        motionManager.startDeviceMotionUpdates(to: .main) { data, err in
            
            if let error = err{
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else{
                print("ERROR IN DATA")
                return
            }
            
            // Animating Using Time Curve...
            // ROugh values for nice Animations...
            withAnimation(.timingCurve(0.18, 0.78, 0.18, 1, duration: 0.77)){
                self.xValue = data.attitude.roll
                self.yValue = data.attitude.pitch
                self.movingOffset = self.getOffset(duration: duration)
            }
        }
    }
    
    func getOffset(duration: CGFloat)->CGSize{
        
        var width = xValue * duration
        var height = yValue * duration
        
        width = (width < 0 ? (-width > duration ? -duration : width) : (width > duration ? duration : width))
        height = (height < 0 ? (-height > duration ? -duration : height) : (height > duration ? duration : height))
        
        // avoiding if view goes over duration...
        
        return CGSize(width: width, height: height)
    }
}
