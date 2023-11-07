//
//  Home.swift
//  HeartAnimation
//
//  Created by Balaji Venkatesh on 23/09/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var beatAnimation: Bool = false
    @State private var showPusles: Bool = false
    @State private var pulsedHearts: [HeartParticle] = []
    @State private var heartBeat: Int = 85
    var body: some View {
        VStack {
            ZStack {
                if showPusles {
                    TimelineView(.animation(minimumInterval: 0.7, paused: false)) { timeline in
                        
                        /// Method 2
                        ZStack {
                            /// Inserting into Canvas with Unique ID
                            ForEach(pulsedHearts) { _ in
                                PulseHeartView()
                            }
                        }
                        .onChange(of: timeline.date) { oldValue, newValue in
                            if beatAnimation {
                                addPulsedHeart()
                            }
                        }
                        
                        /// Method 1
//                        Canvas { context, size in
//                            /// Drawing into the Canvas
//                            for heart in pulsedHearts {
//                                if let resolvedView = context.resolveSymbol(id: heart.id) {
//                                    let centerX = size.width / 2
//                                    let centerY = size.height / 2
//                                    
//                                    context.draw(resolvedView, at: CGPoint(x: centerX, y: centerY))
//                                }
//                            }
//                        } symbols: {
//                            /// Inserting into Canvas with Unique ID
//                            ForEach(pulsedHearts) {
//                                PulseHeartView()
//                                    .id($0.id)
//                            }
//                        }
//                        .onChange(of: timeline.date) { oldValue, newValue in
//                            if beatAnimation {
//                                addPulsedHeart()
//                            }
//                        }
                    }
                }
                
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.heart.gradient)
                    .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
            }
            .frame(maxWidth: 350, maxHeight: 350)
            .overlay(alignment: .bottomLeading, content: {
                VStack(alignment: .leading, spacing: 5, content: {
                    Text("Current")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                    
                    HStack(alignment: .bottom, spacing: 6, content: {
                        if beatAnimation {
                            TimelineView(.animation(minimumInterval: 1.5, paused: false)) { timeline in
                                Text("\(heartBeat)")
                                    .font(.system(size: 45).bold())
                                    .contentTransition(.numericText(value: Double(heartBeat)))
                                    .foregroundStyle(.white)
                                    .onChange(of: timeline.date) { oldValue, newValue in
                                        withAnimation(.bouncy) {
                                            heartBeat = .random(in: 80...130)
                                        }
                                    }
                            }
                        } else {
                            Text("\(heartBeat)")
                                .font(.system(size: 45).bold())
                                .foregroundStyle(.white)
                        }
                        
                        
                        Text("BPM")
                            .font(.callout.bold())
                            .foregroundStyle(.heart.gradient)
                    })
                    
                    Text("88 BPM, 10m ago")
                        .font(.callout)
                        .foregroundStyle(.gray)
                })
                .offset(x: 30, y: -35)
            })
            .background(.bar, in: .rect(cornerRadius: 30))
            
            Toggle("Beat Animation", isOn: $beatAnimation)
                .padding(15)
                .frame(maxWidth: 350)
                .background(.bar, in: .rect(cornerRadius: 15))
                .padding(.top, 20)
                .onChange(of: beatAnimation) { oldValue, newValue in
                    if pulsedHearts.isEmpty {
                        showPusles = true
                    }
                    
                    if newValue && pulsedHearts.isEmpty {
                        addPulsedHeart()
                    }
                }
                .disabled(!beatAnimation && !pulsedHearts.isEmpty)
        }
    }
    
    func addPulsedHeart() {
        let pulsedHeart = HeartParticle()
        pulsedHearts.append(pulsedHeart)
        
        /// Removing After the pusle animation was Finished
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pulsedHearts.removeAll(where: { $0.id == pulsedHeart.id })
            
            if pulsedHearts.isEmpty {
                showPusles = false
            }
        }
    }
}

/// Pulsed Heart Animation View
struct PulseHeartView: View {
    @State private var startAnimation: Bool = false
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 100))
            .foregroundStyle(.heart)
            .background(content: {
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.black)
                    .blur(radius: 5, opaque: false)
                    .scaleEffect(startAnimation ? 1.1 : 0)
                    .animation(.linear(duration: 1.5), value: startAnimation)
            })
            .scaleEffect(startAnimation ? 4 : 1)
            .opacity(startAnimation ? 0 : 0.7)
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            })
    }
}

#Preview {
    ContentView()
}
