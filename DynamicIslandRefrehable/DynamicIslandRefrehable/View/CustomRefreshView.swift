//
//  CustomRefreshView.swift
//  ShoeUI
//
//  Created by Balaji on 18/05/22.
//

import SwiftUI

// MARK: Custom View Builder
struct CustomRefreshView<Content: View>: View {
    var content: Content
    var showsIndicator: Bool
    // MARK: Async Call Back
    var onRefresh: ()async->()
    init(showsIndicator: Bool = false,@ViewBuilder content: @escaping ()->Content,onRefresh: @escaping ()async->()){
        self.showsIndicator = showsIndicator
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    @StateObject var scrollDelegate: ScrollViewModel = .init()
    var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicator) {
            VStack(spacing: 0){
                // Since We Need It From Dynamic Island
                // Making it as Transparent 150px Height Rectangle
                Rectangle()
                    .fill(.clear)
                    .frame(height: 150 * scrollDelegate.progress)
                
                content
            }
            .offset(coordinateSpace: "SCROLL") { offset in
                // MARK: Storing Content Offset
                scrollDelegate.contentOffset = offset
                
                // MARK: Stopping The Progress When Its Elgible For Refresh
                if !scrollDelegate.isEligible{
                    var progress = offset / 150
                    progress = (progress < 0 ? 0 : progress)
                    progress = (progress > 1 ? 1 : progress)
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }
                
                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing{
                    scrollDelegate.isRefreshing = true
                    // MARK: Haptic Feedback
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .overlay(alignment: .top, content: {
            ZStack{
                Capsule()
                    .fill(.black)
            }
            .frame(width: 126, height: 37)
            .offset(y: 11)
            .frame(maxHeight: .infinity,alignment: .top)
            .overlay(alignment: .top, content: {
                // MARK: For More See Shape Morphing And MetaBall Animations Video
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .black))
                    context.addFilter(.blur(radius: 10))
                    
                    // Drawing Inside New Layer
                    context.drawLayer { ctx in
                        for index in [1,2]{
                            if let resolvedView = context.resolveSymbol(id: index){
                                // Dynamic Island Offset -> 11
                                // Circle Radius -> 38/2 -> 14
                                // Total -> 11 + 14 -> 30
                                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: 30))
                            }
                        }
                    }
                } symbols: {
                    // MARK: Passing Capsule And Circle For Dynamic Island Push Refresh Symbols
                    CanvasSymbol()
                        .tag(1)
                    
                    CanvasSymbol(isCircle: true)
                        .tag(2)
                }
                // MARK: Since it's an Overlay so it's not allowing bottom view to interact
                // WorkAround: Set allowHitTesting to false
                .allowsHitTesting(false)
            })
            .overlay(alignment: .top, content: {
                RefreshView()
                // MARK: Dynamic Island Top Offset
                    .offset(y: 11)
            })
            .ignoresSafeArea()
        })
        .coordinateSpace(name: "SCROLL")
        .onAppear(perform: scrollDelegate.addGesture)
        .onDisappear(perform: scrollDelegate.removeGesture)
        .onChange(of: scrollDelegate.isRefreshing) { newValue in
            // MARK: Calling Async Method
            if newValue{
                Task{
                    // MARK: 1 Sec Sleep For Smooth Animation
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    await onRefresh()
                    // MARK: After Refresh Done Resetting Properties
                    withAnimation(.easeInOut(duration: 0.25)){
                        scrollDelegate.progress = 0
                        scrollDelegate.isEligible = false
                        scrollDelegate.isRefreshing = false
                        scrollDelegate.scrollOffset = 0
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func CanvasSymbol(isCircle: Bool = false)->some View{
        if isCircle{
            // MARK: Applying Offset
            // Since Our Refresh Max Size is 150, so to place at it's middle then
            // Offset will be -> 150/2 = 75
            // Circle Radius -> 38/2 = 19
            // Total -> 75 + 19 = 95(Round)
            let centerOffset = scrollDelegate.isEligible ? (scrollDelegate.contentOffset > 95 ? scrollDelegate.contentOffset : 95) : scrollDelegate.scrollOffset
            
            let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
            // MARK: Dynamic Scaling
            // 1- 0.79 = 0.21
            let scaling = ((scrollDelegate.progress / 1) * 0.21)
            Circle()
                .fill(.black)
                .frame(width: 47, height: 47)
                .scaleEffect(0.79 + scaling,anchor: .center)
                .offset(y: offset)
        }else{
            Capsule()
                .fill(.black)
                .frame(width: 126, height: 37)
        }
    }
    
    @ViewBuilder
    func RefreshView()->some View{
        // MARK: Arrow Rotation View When Dragging for Refresh
        // Applying the Same to the Refresh View
        let centerOffset = scrollDelegate.isEligible ? (scrollDelegate.contentOffset > 95 ? scrollDelegate.contentOffset : 95) : scrollDelegate.scrollOffset
        
        let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
        ZStack{
            Image(systemName: "arrow.down")
                .font(.callout.bold())
                .foregroundColor(.white)
                .frame(width: 38, height: 38)
                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                .opacity(scrollDelegate.isEligible ? 0 : 1)
            
            ProgressView()
                .tint(.white)
                .frame(width: 38, height: 38)
                .opacity(scrollDelegate.isEligible ? 1 : 0)
        }
        .animation(.easeInOut(duration: 0.25), value: scrollDelegate.isEligible)
        .opacity(scrollDelegate.progress)
        .offset(y: offset)
    }
}

struct CustomRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        // MARK: For Testing Purpose
        CustomRefreshView(showsIndicator: false) {
            VStack{
                Rectangle()
                    .fill(.red)
                    .frame(height: 200)
                
                Rectangle()
                    .fill(.yellow)
                    .frame(height: 200)
            }
        } onRefresh: {
            
        }
    }
}

// MARK: For Simultanous Pan Gesture
class ScrollViewModel: NSObject,ObservableObject,UIGestureRecognizerDelegate{
    // MARK: Properties
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    // MARK: Offsets and Progress
    @Published var scrollOffset: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    let gestureID = UUID().uuidString
    
    // MARK: Since We need to Know when the user Left the Screen to Start Refresh
    // Adding Pan Gesture To UI Main Application Window
    // With Simultaneous Gesture Desture
    // Thus it Wont disturb SwiftUI Scroll's And Gesture's
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: Adding Gesture
    func addGesture(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onGestureChange(gesture:)))
        panGesture.delegate = self
        panGesture.name = gestureID
        
        rootController().view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Removing When Leaving The View
    func removeGesture(){
        rootController().view.gestureRecognizers?.removeAll(where: { gesture in
            gesture.name == gestureID
        })
    }
    
    // MARK: Finding Root Controller
    func rootController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
    
    @objc
    func onGestureChange(gesture: UIPanGestureRecognizer){
        if gesture.state == .cancelled || gesture.state == .ended{
            print("User Released Touch")
            // MARK: Your Max Duration Goes Here
            if !isRefreshing{
                if scrollOffset > 150{
                    isEligible = true
                }else{
                    isEligible = false
                }
            }
        }
    }
}

// MARK: Offset Modifier
extension View{
    @ViewBuilder
    func offset(coordinateSpace: String,offset: @escaping (CGFloat)->())->some View{
        self
            .overlay {
                GeometryReader{proxy in
                    let minY = proxy.frame(in: .named(coordinateSpace)).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value in
                            offset(value)
                        }
                }
            }
    }
}

// MARK: Offset Preference Key
struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
