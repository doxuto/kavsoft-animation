//
//  CursorGlowView.swift
//  CursorGlow
//
//  Created by Balaji on 30/04/22.
//

import SwiftUI

// MARK: Custom View Builder
struct CursorGlowView<Content: View>: View {
    var content: Content
    var glowOpacity: CGFloat = 0.5
    var blurRadius: CGFloat = 50
    init(glowOpacity: CGFloat = 0.5,blurRadius: CGFloat = 40,@ViewBuilder content: @escaping ()->Content){
        self.content = content()
        self.glowOpacity = glowOpacity
        self.blurRadius = blurRadius
    }
    
    // MARK: Hover + Cursor Properties
    // MARK: Cursor Location On Main Window
    var cursorLocation: CGPoint {NSApplication.shared.mainWindow?.mouseLocationOutsideOfEventStream ?? .zero}
    @State var location: CGPoint = .zero
    // MARK: Storing Event
    @State var event: Any?
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            let minX = proxy.frame(in: .global).minX
            let minY = proxy.frame(in: .global).minY
            
            // Scaling Anchor Point
            let tempX = (location.x / size.width)
            let tempY = (location.y / size.height)
            
            let progressX = (tempX < 0 ? 0 : (tempX > 1 ? 1 : tempX))
            let progressY = (tempY < 0 ? 0 : (tempY > 1 ? 1 : tempY))
            
            ZStack{
                content
                
                // MARK: Adding Glow Animation
                Circle()
                    .fill(.white.opacity(glowOpacity))
                    .frame(width: 45, height: 45)
                    .blur(radius: blurRadius)
                // Making It Center
                // Width 45 = 45/2 = 22
                // Title Bar Height = 28
                // Height 28/2 = 14
                    .offset(x: -22, y: -14)
                    .offset(x: location.x, y: location.y)
                    .opacity(location == .zero ? 0 : 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .animation(.none, value: location)
            }
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .scaleEffect(1 + (location == .zero ? 0 : 0.05), anchor: .init(x: -progressX, y: -progressY))
            .onHover { status in
                if !status{
                    // MARK: Removing When its Moved
                    if let event = event {
                        NSEvent.removeMonitor(event)
                        // MARK: Resetting To Zero
                        withAnimation(.linear.speed(1)){
                            location = .zero
                        }
                    }
                }else{
                    // MARK: Adding Cursor Event Observer
                    self.event = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                        // MARK: Extracting The Correct Location for Each Card
                        // With the Help of Geometry Reader Coordinates
                        // Removing Window Height will give Correct Y Location
                        let windowHeight = (NSApplication.shared.mainWindow?.frame.height ?? 0)
                        // Adding Animation for First Time Scaling
                        withAnimation(location == .zero ? .linear.speed(2) : .none){
                            // Directly Applying Resloving The Issue
                            self.location = CGPoint(x: cursorLocation.x - minX, y: windowHeight -  cursorLocation.y - minY)
                        }
                        return event
                    }
                }
            }
        }
    }
}
