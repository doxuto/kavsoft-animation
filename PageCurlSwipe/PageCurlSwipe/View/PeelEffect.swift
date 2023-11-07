//
//  PeelEffect.swift
//  PageCurlSwipe
//
//  Created by Balaji on 23/03/23.
//

import SwiftUI

/// Custom View Builder
struct PeelEffect<Content: View>: View {
    var content: Content
    /// Delete Callback for MainView, When Delete is Clicked
    var onDelete: () -> ()
    
    init(@ViewBuilder content: @escaping () -> Content, onDelete: @escaping () -> ()) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    /// View Properties
    @State private var dragProgress: CGFloat = 0
    @State private var isExpanded: Bool = false
    var body: some View {
        content
            .hidden()
            .overlay(content: {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    let minX = rect.minX
                    
                    /// Replace it as Background View
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.red.gradient)
                        .overlay(alignment: .trailing) {
                            Button {
                                /// Removing Card Completely
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                    dragProgress = 1
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    onDelete()
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .padding(.trailing, 20)
                                    .foregroundColor(.white)
                                    .contentShape(Rectangle())
                            }
                            .disabled(!isExpanded)
                        }
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    /// Disabling Gesture When it's Expanded
                                    guard !isExpanded else { return }
                                    /// Right to Left Swipe: Negative Value
                                    var translationX = value.translation.width
                                    /// Limiting to Max Zero
                                    translationX = max(-translationX, 0)
                                    /// Converting Translation Into Progress (0 - 0.9)
                                    let progress = min(0.9, translationX / rect.width)
                                    dragProgress = progress
                                }).onEnded({ value in
                                    /// Disabling Gesture When it's Expanded
                                    guard !isExpanded else { return }
                                    /// Smooth Ending Animation
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                        if dragProgress > 0.25 {
                                            dragProgress = 0.6
                                            isExpanded = true
                                        } else {
                                            dragProgress = .zero
                                            isExpanded = false
                                        }
                                    }
                                })
                        )
                        /// If we Tap Other Than Delete Button, It will Reset to Initial State
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                dragProgress = .zero
                                isExpanded = false
                            }
                        }
                    
                    /// Shadow
                    Rectangle()
                        .fill(.black)
                        .padding(.vertical, 23)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 30, y: 0)
                        /// Moving Along Side While Dragging
                        .padding(.trailing, rect.width * dragProgress)
                        .mask(content)
                        /// Disabling Interaction
                        .allowsHitTesting(false)
                        .offset(x: dragProgress == 1 ? -minX : 0)
                    
                    content
                        .mask {
                            Rectangle()
                            /// Masking Orignal Content
                            /// Swipe: Right to Left
                            /// Thus Masking from Right to Left (Trailing)
                            .padding(.trailing, dragProgress * rect.width)
                        }
                        /// Disable Interaction
                        .allowsHitTesting(false)
                        .offset(x: dragProgress == 1 ? -minX : 0)
                }
            })
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let minX = $0.frame(in: .global).minX
                    let minOpacity = dragProgress / 0.05
                    let opacity = min(1, minOpacity)
                    
                    content
                        /// Making it Look like it's Rolling
                        .shadow(color: .black.opacity(dragProgress != 0 ? 0.2 : 0), radius: 5, x: 15, y: 0)
                        .overlay {
                            Rectangle()
                                .fill(.white.opacity(0.25))
                                .mask(content)
                        }
                        /// Making it Glow At the Back Side
                        .overlay(alignment: .trailing) {
                            Rectangle()
                                .fill(
                                    .linearGradient(colors: [
                                        .clear,
                                        .white,
                                        .clear,
                                        .clear
                                    ], startPoint: .leading, endPoint: .trailing)
                                )
                                .frame(width: 60)
                                .offset(x: 40)
                                .offset(x: -30 + (30 * opacity))
                                /// Moving Along Side While Dragging
                                .offset(x: size.width * -dragProgress)
                        }
                        /// Flipping Horizontally for Upside Image
                        .scaleEffect(x: -1)
                        /// Moving Along Side While Dragging
                        .offset(x: size.width - (size.width * dragProgress))
                        .offset(x: size.width * -dragProgress)
                        /// Masking Overlayed Image For Removing Outbound Visibilty
                        .mask {
                            Rectangle()
                                .offset(x: size.width * -dragProgress)
                        }
                        .offset(x: dragProgress == 1 ? -minX : 0)
                }
                /// Disable Interaction
                .allowsHitTesting(false)
            }
    }
}

struct PeelEffect_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
