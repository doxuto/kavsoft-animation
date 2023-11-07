//
//  CubicTransition.swift
//  CustomTransition (iOS)
//
//  Created by Balaji on 23/02/22.
//

import SwiftUI

struct CubicTransition<Content: View,Detail: View>: View {
    var content: Content
    var detail: Detail
    
    // MARK: Show View
    @Binding var show: Bool
    
    init(show: Binding<Bool>,@ViewBuilder content: @escaping ()->Content,@ViewBuilder detail: @escaping ()->Detail){
        self.detail = detail()
        self.content = content()
        self._show = show
    }
    
    // MARK: Animation Properties
    @State var animateView: Bool = false
    @State var showView: Bool = false
    
    @State var task: DispatchWorkItem?
    
    var body: some View {
        
        GeometryReader{proxy in
            let size = proxy.size
            
            HStack(spacing: 0){
            
                content
                    .frame(width: size.width, height: size.height)
                // MARK: Rotating Current View when detail View is Pushing
                    .rotation3DEffect(.init(degrees: animateView ? -85 : 0), axis: (x: 0, y: 1, z: 0), anchor: .trailing, anchorZ: 0, perspective: 1)
                
                // Displaying Detail View
                ZStack{
                    if showView{
                        detail
                            .frame(width: size.width, height: size.height)
                            .transition(.move(edge: .trailing))
                            .onDisappear {
                                print("Closed")
                            }
                    }
                }
                // Optional: Increase Perspective for More Angle Rotation
                .rotation3DEffect(.init(degrees: animateView ? 0 : 85), axis: (x: 0, y: 1, z: 0), anchor: .leading, anchorZ: 0, perspective: 1)
            }
            // Applying Offset
            .offset(x: animateView ? -size.width : 0)
        }
        .onChange(of: show) { newValue in
            task?.cancel()
            
            // Showing View before Animation Stars
            if show{showView = true}
            // The View is Not Removed so it will Create Memory Issues
            else{
                // Closing View when the Animation is Finished
                // Which is after 0.35 sec
                
                // To Avoid this Issue
                task = .init{
                    showView = false
                }
                if let task = task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35,execute: task)
                }
            }
            
            // Why Using Separate Variable instead of Show
            // Since it will remove as soon as it set to false
            // So the animation will not be completed
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                withAnimation(.easeInOut(duration: 0.35)){
                    animateView.toggle()
                }
            }
        }
    }
}

struct CubicTransition_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
