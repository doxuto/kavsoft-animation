//
//  ShapeMorphingView.swift
//  GooeyShareButton
//
//  Created by Balaji on 17/05/23.
//

import SwiftUI

/// Custom View
/// Which Will Morph Given SFSymbol Images
struct ShapeMorphingView: View {
    var systemImage: String
    var fontSize: CGFloat
    var color: Color = .white
    var duration: CGFloat = 0.5
    /// View Properties
    @State private var newImage: String = ""
    @State private var radius: CGFloat = 0
    @State private var animatedRadiusValue: CGFloat = 0
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            Canvas { ctx, size in
                ctx.addFilter(.alphaThreshold(min: 0.5, color: color))
                ctx.addFilter(.blur(radius: animatedRadiusValue))
                
                ctx.drawLayer { ctx1 in
                    if let resolvedImageView = ctx.resolveSymbol(id: 0) {
                        ctx1.draw(resolvedImageView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                    }
                }
            } symbols: {
                ImageView(size: size)
                    .tag(0)
            }
        }
        /// Intial Image Setting
        .onAppear {
            if newImage == "" {
                newImage = systemImage
            }
        }
        /// Updating Image
        .onChange(of: systemImage) { newValue in
            newImage = newValue
            withAnimation(.linear(duration: duration).speed(2)) {
                radius = 12
            }
        }
        .animationProgress(endValue: radius) { value in
            animatedRadiusValue = value
            
            if value >= 6 {
                withAnimation(.linear(duration: duration).speed(2)) {
                    radius = 0
                }
            }
        }
    }
    
    /// Image View
    @ViewBuilder
    func ImageView(size: CGSize) -> some View {
        if newImage != "" {
            Image(systemName: newImage)
                .font(.system(size: fontSize))
                /// Animating Changes
                /// Animation Values are upto your Customization
                .animation(.linear(duration: duration), value: newImage)
                .animation(.linear(duration: duration), value: fontSize)
                /// Fixing Place at one Point
                .frame(width: size.width, height: size.height)
        }
    }
}

struct ShapeMorphingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
