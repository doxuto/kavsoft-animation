//
//  ShimmerEffect.swift
//  ShimmerText
//
//  Created by Balaji on 16/03/23.
//

import SwiftUI

/// Shimmer Effect Custom View Modifier
extension View {
    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config))
    }
}

/// Shimmer Effect Helper
fileprivate struct ShimmerEffectHelper: ViewModifier {
    /// Shimmer Config
    var config: ShimmerConfig
    /// Animation Properties
    @State private var moveTo: CGFloat = -0.7
    func body(content: Content) -> some View {
        content
            /// Adding Shimmer Animation with the help of Masking Modifier
            /// Hiding the Normal One and Adding Shimmer one instead
            .hidden()
            .overlay {
                /// Changing Tint Color
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        /// Shimmer
                        GeometryReader {
                            let size = $0.size
                            let extraOffset = (size.height / 2.5) + config.blur
                            
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                    /// Gradient For Glowing at the Center
                                        .fill(
                                            .linearGradient(colors: [
                                                .white.opacity(0),
                                                config.highlight.opacity(config.highlightOpacity),
                                                .white.opacity(0)
                                            ], startPoint: .top, endPoint: .bottom)
                                        )
                                        /// Adding Blur
                                        .blur(radius: config.blur)
                                        /// Rotating (Degree: Your Choice of Wish)
                                        .rotationEffect(.init(degrees: -70))
                                        /// Moving to the Start
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                }
                                .blendMode(config.blendMode)
                        }
                        /// Mask with the content
                        .mask {
                            content
                        }
                    }
                    /// Animating Movement
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}

/// Shimmer Config
struct ShimmerConfig {
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 2
    var blendMode: BlendMode = .normal
}

struct ShimmerEffect_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
