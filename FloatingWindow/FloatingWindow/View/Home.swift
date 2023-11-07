//
//  Home.swift
//  FloatingWindow
//
//  Created by Balaji on 25/01/23.
//

import SwiftUI

struct Home: View {
    /// - View Properties
    @State private var showFloatingWindow: Bool = false
    @State private var position: CGPoint = .zero
    @State private var onHover: Bool = false
    var body: some View {
        VStack(spacing: 15){
            Button("Open Floating Panel"){
                /// - Use Case Example (When we take screenshot, the image will slide like this)
                position = .init(x: bottomRight.x + 220, y: bottomRight.y)
                showFloatingWindow.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){
                    position = .init(x: bottomRight.x, y: bottomRight.y)
                }
            }
            
            HStack(spacing: 10){
                Button("Top Left"){
                    position = topLeft
                }
                
                Button("Bottom Right"){
                    position = bottomRight
                }
            }
        }
        .frame(width: 250, height: 250)
        .background(content: {
            Rectangle()
                .fill(.blue.gradient)
                .ignoresSafeArea()
        })
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle)
        /// - Simply Use it like Sheets/FullscreenCover
        .floatingWindow(position: $position, show: $showFloatingWindow) {
            /// - Floating Window Content
            GeometryReader{
                let size = $0.size
                Image("Pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .blur(radius: onHover ? 15 : 0,opaque: true)
                    .overlay(content: {
                        Rectangle()
                            .fill(.black.opacity(onHover ? 0.25 : 0))
                    })
                    .overlay(content: {
                        Image(systemName: "square.and.arrow.up.on.square.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .opacity(onHover ? 1 : 0)
                    })
                    .animation(.easeInOut(duration: 0.2), value: onHover)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            }
            .frame(width: 200, height: 200)
            .clipped()
            .onHover { status in
                onHover = status
            }
        }
    }
    
    var topLeft: CGPoint{
        guard let screen = NSScreen.main?.visibleFrame.size else{return .zero}
        return .init(x: 20, y: screen.height - 220)
    }
    
    var bottomRight: CGPoint{
        guard let screen = NSScreen.main?.visibleFrame.size else{return .zero}
        return .init(x: screen.width - 220, y: 20)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
