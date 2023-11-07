//
//  ScratchCardView.swift
//  ScratchCardAnimation
//
//  Created by Balaji on 23/07/22.
//

import SwiftUI

// MARK: Custom View
struct ScratchCardView<Content: View,Overlay: View>: View {
    var content: Content
    var overlay: Overlay
    // MARK: Properties
    var pointSize: CGFloat
    // MARK: Callback when the Scratch Card is Fully Visible
    var onFinish: ()->()
    
    init(pointSize: CGFloat,@ViewBuilder content: @escaping()->Content, @ViewBuilder overlay: @escaping()->Overlay, onFinish: @escaping () -> Void) {
        self.content = content()
        self.overlay = overlay()
        self.pointSize = pointSize
        self.onFinish = onFinish
    }
    
    // MARK: Animation Properties
    @State var isScratched: Bool = false
    @State var disableGesture: Bool = false
    @State var dragPoints: [CGPoint] = []
    @State var animateCard: [Bool] = [false,false]
    var body: some View {
        GeometryReader {proxy in
            let size = proxy.size
            ZStack{
                // MARK: Logic is Simple
                // We're Going to Mask the Content Bit by Bit Based on Drag Location
                // Thus It will Starts Drawing the Content View Over the Overlay View
                overlay
                    .opacity(disableGesture ? 0 : 1)
                
                content
                    .mask {
                        if disableGesture{
                            Rectangle()
                        }else{
                            PointShape(points: dragPoints)
                             // MARK: Applying Stoke So that It will be Applying Circle For Each Point
                                 .stroke(style: StrokeStyle(lineWidth: isScratched ? (size.width * 1.4) : pointSize, lineCap: .round, lineJoin: .round))
                        }
                    }
                    // MARK: Adding Gesture
                    .gesture(
                        DragGesture(minimumDistance: disableGesture ? 100000 : 0)
                            .onChanged({ value in
                                // MARK: Stopping Animation When First Touch Registered
                                if dragPoints.isEmpty{
                                    withAnimation(.easeInOut){
                                        animateCard[0] = false
                                        animateCard[1] = false
                                    }
                                }
                                // MARK: Adding Points
                                dragPoints.append(value.location)
                            })
                            .onEnded({ _ in
                                // MARK: Checking If Atleast One Portion is Scratched
                                if !dragPoints.isEmpty{
                                    // MARK: Scratching Whole Card
                                    withAnimation(.easeInOut(duration: 0.35)){
                                        isScratched = true
                                    }
                                    
                                    // Callback
                                    onFinish()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                                        disableGesture = true
                                    }
                                }
                            })
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .rotation3DEffect(.init(degrees: animateCard[0] ? 4 : 0), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(.init(degrees: animateCard[1] ? 4 : 0), axis: (x: 0, y: 1, z: 0))
            .onAppear {
                // MARK: SwiftUI Bug
                // WorkAround:
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)){
                        animateCard[0] = true
                    }
                    
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.8)){
                        animateCard[1] = true
                    }
                }
            }
        }
    }
}

struct ScratchCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Custom Path Shape Based on Drag Locations
struct PointShape: Shape{
    var points: [CGPoint]
    // MARK: Since We Need Animation
    var animatableData: [CGPoint]{
        get{points}
        set{points = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        Path{path in
            if let first = points.first{
                path.move(to: first)
                path.addLines(points)
            }
        }
    }
}
