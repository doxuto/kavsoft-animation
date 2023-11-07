//
//  ResizableLottieView.swift
//  AnimatedTabIcons
//
//  Created by Balaji on 03/08/22.
//

import SwiftUI
import Lottie

// MARK: Resizable Lottie View
struct ResizableLottieView: UIViewRepresentable {
    var lottieView: AnimationView
    var color: SwiftUI.Color = .black
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        addLottieView(to: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // MARK: Dynamic Color Update
        // Finding Attached Lottie View
        if let animationView = uiView.subviews.first(where: { view in
            view is AnimationView
        }) as? AnimationView{
            // MARK: Finding Keypaths With the Help of Log
            // Key may be changed based on Lottie File
            // Use Log to Find Appropriate Key
            //lottieView.logHierarchyKeypaths()
            
            let lottieColor = ColorValueProvider(UIColor(color).lottieColorValue)
            // MARK: Fill Key Path
            let fillKeyPath = AnimationKeypath(keys: ["**","Fill 1","**","Color"])
            animationView.setValueProvider(lottieColor, keypath: fillKeyPath)
            
            // MARK: Stroke Key Path
            let strokeKeyPath = AnimationKeypath(keys: ["**","Stroke 1","**","Color"])
            animationView.setValueProvider(lottieColor, keypath: strokeKeyPath)
        }
    }
    
    func addLottieView(to: UIView){
        // MARK: Memory Properties
        lottieView.backgroundBehavior = .forceFinish
        lottieView.shouldRasterizeWhenIdle = true
        
        lottieView.backgroundColor = .clear
        lottieView.contentMode = .scaleAspectFit
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            lottieView.widthAnchor.constraint(equalTo: to.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: to.heightAnchor)
        ]
        
        to.addSubview(lottieView)
        to.addConstraints(constraints)
    }
}
