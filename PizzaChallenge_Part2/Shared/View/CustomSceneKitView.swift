//
//  CustomSceneKitView.swift
//  PizzaChallenge (iOS)
//
//  Created by Balaji on 21/06/22.
//

import SwiftUI
import SceneKit

struct CustomSceneKitView: UIViewRepresentable {
    @Binding var scene: SCNScene?
    // MARK: Why Splilting Single Box Into Two Scenes
    // Because We Need to Create a Animation Where The Pizza Is Inside The Box
    // If We The Scene as Single View then The Pizza Will be Overlayed
    // So That's Why Spiliting Into Two Scenes ie: Top one & Bottom One
    var isTopPortion: Bool = false
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.scene = scene
        
        // SCNView Properties
        view.backgroundColor = .clear
        view.isJitteringEnabled = true
        view.antialiasingMode = .multisampling4X
        // MARK: Since We Dont Want user to Control the Actions
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.scene = scene
        
        // MARK: Rotating The Scene To Show The Open Box
        uiView.pointOfView?.eulerAngles.x = -0.3
        uiView.scene?.rootNode.eulerAngles.x = 2.3
        
        if isTopPortion{
            // MARK: Hiding Bottom One
            uiView.scene?.rootNode.childNode(withName: "Closed_Box", recursively: true)?.isHidden = true
        }else{
            // MARK: Top One
            uiView.scene?.rootNode.childNode(withName: "Cover", recursively: true)?.isHidden = true
        }
    }
}

struct CustomSceneKitView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
