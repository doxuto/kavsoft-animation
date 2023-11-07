//
//  Canvas.swift
//  Canvas Editor (iOS)
//
//  Created by Balaji on 05/05/22.
//

import SwiftUI

struct Canvas: View {
    var height: CGFloat = 250
    @EnvironmentObject var canvasModel: CanvasViewModel
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            
            ZStack{
                Color.white
                
                ForEach($canvasModel.stack){$stackItem in
                    CanvasSubView(stackItem: $stackItem) {
                        stackItem.view
                    } moveFront: {
                        moveViewToFront(stackItem: stackItem)
                    } onDelete: {
                        // MARK: Showing Alert if Mistakenly Tapped
                        canvasModel.currentlyTappedItem = stackItem
                        canvasModel.showDeleteAlert.toggle()
                    }
                }
            }
            .frame(width: size.width, height: size.height)
        }
        // MARK: YOUR DESIRED HEIGHT
        .frame(height: height)
        .clipped()
        .alert("Are you Sure to delete View?", isPresented: $canvasModel.showDeleteAlert) {
            Button(role: .destructive) {
                if let item = canvasModel.currentlyTappedItem{
                    let index = getIndex(stackItem: item)
                    canvasModel.stack.remove(at: index)
                }
            } label: {
                Text("Yes")
            }
        }
    }
    
    func getIndex(stackItem: StackItem)->Int{
        return canvasModel.stack.firstIndex { item in
            return item.id == stackItem.id
        } ?? 0
    }
    
    func moveViewToFront(stackItem: StackItem){
        // Finding Index And Moving To Last
        // Since In ZStack Last Item Will Show on First
        let currentIndex = getIndex(stackItem: stackItem)
        let lastIndex = canvasModel.stack.count - 1
        
        // Simple Swapping
        canvasModel.stack
            .insert(canvasModel.stack.remove(at: currentIndex), at: lastIndex)
    }
}

struct Canvas_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: Canvas SubView
struct CanvasSubView<Content: View>: View{
    var content: Content
    @Binding var stackItem: StackItem
    var moveFront: ()->()
    var onDelete: ()->()
    
    init(stackItem: Binding<StackItem>,@ViewBuilder content: @escaping ()->Content,moveFront: @escaping ()->(),onDelete: @escaping ()->()){
        self.content = content()
        self._stackItem = stackItem
        self.moveFront = moveFront
        self.onDelete = onDelete
    }
    
    // MARK: Haptic Animation
    @State var hapticScale: CGFloat = 1
    var body: some View{
        content
            .rotationEffect(stackItem.rotation)
             // Safe Scaling
            .scaleEffect(stackItem.scale < 0.4 ? 0.4 : stackItem.scale)
            .scaleEffect(hapticScale)
            .offset(stackItem.offset)
            .gesture(
                TapGesture(count: 2)
                    .onEnded({ _ in
                        onDelete()
                    })
                    .simultaneously(with:
                        LongPressGesture(minimumDuration: 0.3)
                        .onEnded({ _ in
                            // For Haptic Feedback and Little Scaling Animation while Moving View to Front
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            withAnimation(.easeInOut){
                                hapticScale = 1.2
                            }
                            withAnimation(.easeInOut.delay(0.1)){
                                hapticScale = 1
                            }
                            
                            moveFront()
                        })
                    )
            )
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        stackItem.offset = CGSize(width: stackItem.lastOffset.width + value.translation.width, height: stackItem.lastOffset.height + value.translation.height)
                    }).onEnded({ value in
                        stackItem.lastOffset = stackItem.offset
                    })
            )
            .gesture(
                MagnificationGesture()
                    .onChanged({ value in
                        // MARK: It Starts With Existing Scaling which is 1
                        // Removing That to Retreive Exact Scaling
                        stackItem.scale = stackItem.lastScale + (value - 1)
                    }).onEnded({ value in
                        stackItem.lastScale = stackItem.scale
                    })
                // MARK: Simultaneously with Rotation Gesture
                    .simultaneously(with:
                        RotationGesture()
                        .onChanged({ value in
                            stackItem.rotation = stackItem.lastRotation + value
                        }).onEnded({ value in
                            stackItem.lastRotation = stackItem.rotation
                        })
                    )
            )
    }
}
