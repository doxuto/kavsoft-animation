//
//  ContentView.swift
//  RepeatButton
//
//  Created by Balaji on 13/07/23.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var count: Int = 0
    var body: some View {
        VStack {
            Text("My Cart")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button(action: {}, label: {
                        Image(systemName: "arrow.left")
                            .fontWeight(.bold)
                    })
                    .foregroundStyle(.black)
                }
                .padding(15)
                .background(.white)
            
            ScrollView(.vertical) {
                VStack(spacing: 15) {
                    HStack(spacing: 12) {
                        Image(.iPhone)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            Text("iPhone 14 Pro Max")
                                .fontWeight(.semibold)
                            
                            Text("Purple - 512GB")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            
                            Text("$1399")
                                .fontWeight(.bold)
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CustomIncrementerView(count: $count)
                            .scaleEffect(0.9, anchor: .trailing)
                    }
                    .padding(15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.05), radius: 8, x: 5, y: 5)), in: .rect(cornerRadius: 20))
                }
                .padding(15)
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity)
            .background {
                Rectangle()
                    .fill(.BG)
                    .clipShape(.rect(topLeadingRadius: 35, topTrailingRadius: 35))
                    .ignoresSafeArea()
            }
        }
    }
}

struct CustomIncrementerView: View {
    @Binding var count: Int
    /// Temporary Button Values
    @State private var buttonFrames: [ButtonFrame] = []
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                if count != 0 {
                    let frame = ButtonFrame(value: count)
                    buttonFrames.append(frame)
                    toggleAnimation(frame.id, false)
                }
            }, label: {
                Image(systemName: "minus")
            })
            .fontWeight(.bold)
            .buttonRepeatBehavior(.enabled)
            
            Text("\(count)")
                .fontWeight(.bold)
                .frame(width: 45, height: 45)
                .background(.white.shadow(.drop(color: .black.opacity(0.15), radius: 5)), in: .rect(cornerRadius: 10))
                .overlay {
                    ForEach(buttonFrames) { btFrame in
                        KeyframeAnimator(initialValue: ButtonFrame(value: 0), trigger: btFrame.triggerKeyFrame) { frame in
                            /// Text With Same Font And Weight
                            Text("\(btFrame.value)")
                                .fontWeight(.bold)
                                .offset(frame.offset)
                                .opacity(frame.opacity)
                                /// Adding Blur for Nice Look
                                .blur(radius: (1 - frame.opacity) * 5)
                        } keyframes: { _ in
                            /// Defining KeyFrames
                            KeyframeTrack(\.offset) {
                                LinearKeyframe(CGSize(width: 0, height: -20), duration: 0.2)
                                LinearKeyframe(CGSize(width: .random(in: -2...2), height: -40), duration: 0.2)
                                LinearKeyframe(CGSize(width: .random(in: -2...2), height: -70), duration: 0.4)
                            }
                            
                            KeyframeTrack(\.opacity) {
                                LinearKeyframe(1, duration: 0.2)
                                LinearKeyframe(1, duration: 0.2)
                                LinearKeyframe(0.7, duration: 0.2)
                                LinearKeyframe(0, duration: 0.2)
                            }
                        }
                    }
                }
            
            Button(action: {
                /// Creating New Keyframe
                let frame = ButtonFrame(value: count)
                buttonFrames.append(frame)
                toggleAnimation(frame.id)
            }, label: {
                Image(systemName: "plus")
            })
            .fontWeight(.bold)
            .buttonRepeatBehavior(.enabled)
        }
    }
    
    func toggleAnimation(_ id: UUID, _ increment: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            if let index = buttonFrames.firstIndex(where: { $0.id == id }) {
                /// Triggering Keyframe Animation
                buttonFrames[index].triggerKeyFrame = true
                /// Incrementing/Decrementing Count
                if increment {
                    count += 1
                } else {
                    count -= 1
                }
                
                removeFrame(id)
            }
        }
    }
    
    func removeFrame(_ id: UUID) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            buttonFrames.removeAll(where: { $0.id == id })
        }
    }
}

struct ButtonFrame: Identifiable, Equatable {
    var id: UUID = .init()
    var value: Int
    var offset: CGSize = .zero
    var opacity: CGFloat = 1
    var triggerKeyFrame: Bool = false
}

#Preview {
    ContentView()
}
