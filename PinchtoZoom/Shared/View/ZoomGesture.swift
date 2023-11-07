//
//  ZoomGesture.swift
//  PinchtoZoom (iOS)
//
//  Created by Balaji on 21/12/21.
//

import SwiftUI

// Add Pinch to Zoom Custom Modifier...
extension View{
    
    func addPinchZoom()->some View{
        return PinchZoomContext {
            self
        }
    }
}

// Helper Structs...
struct PinchZoomContext<Content: View>: View{
    
    var content: Content
    
    init(@ViewBuilder content: @escaping ()->Content){
        self.content = content()
    }
    
    // Offset and Scale Data...
    @State var offset: CGPoint = .zero
    @State var scale: CGFloat = 0
    
    @State var scalePosition: CGPoint = .zero
    
    // Were creating a SceneStorage that will give whether the Zooming is happening or not...
    @SceneStorage("isZooming") var isZooming: Bool = false
    
    var body: some View{
        
        content
        // applying offset before scaling...
            .offset(x: offset.x, y: offset.y)
        // Using UIKit Gestures for simulatenously recognize both Pinch and Pan Gesture....
            .overlay(
            
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    ZoomGesture(size: size, scale: $scale, offset: $offset, scalePosition: $scalePosition)
                }
            )
        // Scaling Content...
            .scaleEffect(1 + (scale < 0 ? 0 : scale),anchor: .init(x: scalePosition.x, y: scalePosition.y))
        // Making it top when zooming started...
            .zIndex((scale != 0 || offset != .zero) ? 1000 : 0)
            .onChange(of: scale) { newValue in
                
                isZooming = (scale != 0)
                
                if scale == -1{
                    // Giving some time to finish animation...
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        scale = 0
                    }
                }
            }
            .onChange(of: offset) { newValue in
                isZooming = (offset != .zero)
            }
    }
}

struct ZoomGesture: UIViewRepresentable{
    
    // getting Size for calculating Scale...
    var size: CGSize
    
    @Binding var scale: CGFloat
    @Binding var offset: CGPoint
    
    @Binding var scalePosition: CGPoint
    
    // Connecting Coordinator...
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        // adding Gestures...
        let Pinchgesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
        
        view.addGestureRecognizer(Pinchgesture)
        
        // adding pan Gesture...
        
        let Pangesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(sender:)))
        
        Pangesture.delegate = context.coordinator
        
        view.addGestureRecognizer(Pinchgesture)
        view.addGestureRecognizer(Pangesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    // Creating Handlers for Gestures...
    class Coordinator: NSObject,UIGestureRecognizerDelegate{
        
        var parent: ZoomGesture
        
        // When One Finger in pinch is relased....
        var isPinchReleased: Bool = false
        
        init(parent: ZoomGesture) {
            self.parent = parent
        }
        
        // making pan to recognize simultaneously....
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        @objc
        func handlePan(sender: UIPanGestureRecognizer){
         
            // setting maxTouches...
            sender.maximumNumberOfTouches = 2
            
            // min scale is 1...
            if (sender.state == .began || sender.state == .changed){
                
                if let view = sender.view,parent.scalePosition != .zero{
                    
                    // getting translation...
                    let translation = sender.translation(in: view)
                    
                    parent.offset = translation
                }
                
            }
            else{
                // Setting state to back to normal..
                withAnimation(.easeInOut(duration: 0.35)){
                    parent.offset = .zero
                    parent.scalePosition = .zero
                }
            }
        }
        
        @objc
        func handlePinch(sender: UIPinchGestureRecognizer){
            
            // If you dont want to stop when one finger is relased then comment this line....
            isPinchReleased = (sender.numberOfTouches != 2 || isPinchReleased)
            
            // calculating Scale...
            if sender.state == .began || sender.state == .changed{
                
                // setting scale..
                // removing added 1...
                parent.scale = (isPinchReleased ? parent.scale : (sender.scale - 1))
                
                // getting the position where the user pinched and applying scale at that position...
                
                let scalePoint = CGPoint(x: sender.location(in: sender.view).x / sender.view!.frame.size.width, y: sender.location(in: sender.view).y / sender.view!.frame.size.height)
                
                // so the result will be ((0...1),(0...1))
                
                // updating scale point for only once...
                parent.scalePosition = (parent.scalePosition == .zero ? scalePoint : parent.scalePosition)
            }
            else{
                // setting scale to 0...
                withAnimation(.easeInOut(duration: 0.35)){
                    parent.scale = -1
                    parent.scalePosition = .zero
                    isPinchReleased = false
                }
            }
        }
    }
}
