//
//  DetailView.swift
//  ProgressHeroEffect
//
//  Created by Balaji Venkatesh on 13/10/23.
//

import SwiftUI

/// Detail View
struct DetailView: View {
    @Binding var selectedProfile: Profile?
    @Binding var heroProgress: CGFloat
    @Binding var showDetail: Bool
    @Binding var showHeroView: Bool
    /// Color Scheme Based Background Color
    @Environment(\.colorScheme) private var scheme
    /// Gesture Properties
    @GestureState private var isDragging: Bool = false
    @State private var offset: CGFloat = .zero
    /// View Properties
    @State private var toggleViews: Bool = false
    var body: some View {
        if let selectedProfile {
            GeometryReader {
                let size = $0.size
                
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        /// Detail Profile Image View
                        Rectangle()
                            .fill(.clear)
                            .overlay {
                                if !showHeroView {
                                    Image(selectedProfile.profilePicture)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: size.width, height: 400)
                                        .clipShape(.rect(cornerRadius: 25))
                                        .transition(.identity)
                                }
                            }
                            .frame(height: 400)
                            /// Destination Anchor Frame
                            .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                                return ["DESTINATION": anchor]
                            })
                            .visualEffect { content, geometryProxy in
                                content
                                    .offset(y: geometryProxy.frame(in: .scrollView).minY > 0 ? -geometryProxy.frame(in: .scrollView).minY : 0)
                            }
                        
                        Toggle("Toggle View's", isOn: $toggleViews)
                            .padding([.horizontal, .top])
                        
                        if toggleViews {
                            VStack(spacing: 15) {
                                ForEach(1...10, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.yellow.gradient)
                                        .frame(height: 50)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea()
                .frame(width: size.width, height: size.height)
                .background {
                    Rectangle()
                        .fill(scheme == .dark ? .black : .white)
                        .ignoresSafeArea()
                }
                /// Close Button
                .overlay(alignment: .topLeading) {
                    Button(action: {
                        showHeroView = true
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                            heroProgress = 0.0
                        } completion: {
                            showDetail = false
                            self.selectedProfile = nil
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .imageScale(.medium)
                            .contentShape(.rect)
                            .foregroundStyle(.white, .black)
                    })
                    .buttonStyle(.plain)
                    .padding()
                    .opacity(showHeroView ? 0 : 1)
                    .animation(.snappy(duration: 0.25, extraBounce: 0), value: showHeroView)
                }
                .offset(x: size.width - (size.width * heroProgress))
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 10)
                        .contentShape(.rect)
                        .gesture(
                            DragGesture()
                                .updating($isDragging, body: { _, out, _ in
                                    out = true
                                })
                                .onChanged({ value in
                                    var translation = value.translation.width
                                    translation = isDragging ? translation : .zero
                                    translation = translation > 0 ? translation : 0
                                    /// Converting Into Progress
                                    let dragProgress = 1.0 - (translation / size.width)
                                    /// Limiting Progress btw 0 - 1
                                    let cappedProgress = min(max(0, dragProgress), 1)
                                    heroProgress = cappedProgress
                                    offset = translation
                                    
                                    if !showHeroView {
                                        showHeroView = true
                                    }
                                })
                                .onEnded({ value in
                                    /// Closing/Resetting Based on End Target
                                    let velocity = value.velocity.width
                                    
                                    if (offset + velocity) > (size.width * 0.8) {
                                        /// Close View
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                            heroProgress = .zero
                                        } completion: {
                                            offset = .zero
                                            showDetail = false
                                            showHeroView = true
                                            self.selectedProfile = nil
                                        }
                                    } else {
                                        /// Reset
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                            heroProgress = 1.0
                                            offset = .zero
                                        } completion: {
                                            showHeroView = false
                                        }
                                    }
                                })
                        )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
