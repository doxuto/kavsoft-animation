//
//  BlurView.swift
//  DoubleSidedGallery (iOS)
//
//  Created by Balaji on 11/10/21.
//

import SwiftUI

// Since app supports iOS 14...
struct BlurView: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

// Since image quality is too high preview is too lag...
// This pics are only for demo usage....
