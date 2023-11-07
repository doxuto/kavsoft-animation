//
//  BlurView.swift
//  NotesMacOS
//
//  Created by Balaji on 05/10/21.
//

import SwiftUI

// Since App Supports iOS 14....
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView{
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
