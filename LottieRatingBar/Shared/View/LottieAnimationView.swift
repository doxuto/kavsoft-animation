//
//  LottieAnimationView.swift
//  LottieRatingBar
//
//  Created by Balaji on 13/11/21.
//

import SwiftUI
import Lottie

struct LottieAnimationView: UIViewRepresentable {

    var jsonFile: String
    @Binding var progress: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        
        // Just Create a UIView and place the Lottie view at it's Center....
        
        let rootView = UIView()
        rootView.backgroundColor = .clear
        
        addAnimationView(rootView: rootView)
        
        return rootView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        // Updating Progress...
        // Since we used UiView to set the Given size...
        // So we cant directly use progress value..
        // Instead Finding and removing the old view and updating the new one...
        uiView.subviews.forEach { view in
            if view.tag == 1009{
                // Removing
                view.removeFromSuperview()
            }
        }
        
        addAnimationView(rootView: uiView)
    }
    
    func addAnimationView(rootView: UIView){
        
        let animationView = AnimationView(name: jsonFile, bundle: .main)
        
        // We need only animation from 0-0.5...
        animationView.currentProgress = 0.49 + (progress / 2)
        
        animationView.backgroundColor = .clear
        animationView.tag = 1009
        
        // Applying Auto Layout Constraints to place Lottie View in Center...
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
        
            animationView.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: rootView.heightAnchor),
        ]
        
        rootView.addSubview(animationView)
        
        rootView.addConstraints(constraints)
    }
}
