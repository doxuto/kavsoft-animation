//
//  CustomTabBar.swift
//  PS TabBar
//
//  Created by Balaji on 20/02/23.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var activeTab: Tab
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Image(tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .offset(y: offset(tab))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                activeTab = tab
                            }
                        }
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .padding(.bottom, safeArea.bottom == 0 ? 30 : safeArea.bottom)
        .background(content: {
            ZStack {
                /// Adding Border
                TabBarTopCurve()
                    .stroke(.white, lineWidth: 0.5)
                    .blur(radius: 0.5)
                    .padding(.horizontal, -10)
                
                TabBarTopCurve()
                    .fill(Color("BG").opacity(0.5).gradient)
            }
        })
        .overlay(content: {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .global)
                let width = rect.width
                let maxedWidth = width * 5
                let height = rect.height
                
                Circle()
                    .fill(.clear)
                    .frame(width: maxedWidth, height: maxedWidth)
                    .background(alignment: .top) {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                Color("TabBG"),
                                Color("BG"),
                                Color("BG"),
                            ], startPoint: .top, endPoint: .bottom))
                            .frame(width: width, height: height)
                            /// Masking into it;s native big circle Shape
                            .mask(alignment: .top) {
                                Circle()
                                    .frame(width: maxedWidth, height: maxedWidth, alignment: .top)
                            }
                    }
                    /// Border
                    .overlay(content: {
                        Circle()
                            .stroke(.white, lineWidth: 0.2)
                            .blur(radius: 0.5)
                    })
                    .frame(width: width)
                    /// Indicator
                    .background(content: {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 45, height: 4)
                            /// Glow
                            .glow(.white.opacity(0.5), radius: 50)
                            .glow(Color("Blue").opacity(0.7), radius: 30)
                            /// It's At it's Center, Moving to the Top
                            .offset(y: -1.5)
                            .offset(y: -maxedWidth / 2)
                            .rotationEffect(.init(degrees: calculateRotation(maxedWidth: maxedWidth / 2, actualWidth: width, true)))
                            .rotationEffect(.init(degrees: calculateRotation(maxedWidth: maxedWidth / 2, actualWidth: width)))
                    })
                    .offset(y: height / 2.1)
            }
            /// Active Tab Text
            .overlay(alignment: .bottom) {
                Text(activeTab.rawValue)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .offset(y: safeArea.bottom == 0 ? -15 : -safeArea.bottom + 12)
            }
        })
        .preferredColorScheme(.dark)
    }
    
    /// Calculating Rotation Using Trigonometry
    func calculateRotation(maxedWidth y: CGFloat, actualWidth: CGFloat, _ isInitial: Bool = false) -> CGFloat {
        let tabWidth = actualWidth / Tab.count
        /// This is acutally (X)
        let firstTabPositionX: CGFloat = -(actualWidth - tabWidth) / 2
        let tan = y / firstTabPositionX
        let radians = atan(tan)
        let degree = radians * 180 / .pi
        
        if isInitial {
            return -(degree + 90)
        }
        
        let x = tabWidth * activeTab.index
        let tan_ = y / x
        let radians_ = atan(tan_)
        let degree_ = radians_ * 180 / .pi
        
        return -(degree_ - 90)
    }
    
    /// Offset based on Tab Position
    func offset(_ tab: Tab) -> CGFloat {
        let totalIndices = Tab.count
        let currentIndex = tab.index
        let progress = currentIndex / totalIndices
        
        return progress < 0.5 ? (currentIndex * -10) : ((totalIndices - currentIndex - 1) * -10)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Tab Bar Custom Shapes
struct TabBarTopCurve: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            let width = rect.width
            let height = rect.height
            let midWidth = width / 2
            
            path.move(to: .init(x: 0, y: 5))
            /// Adding Curves
            path.addCurve(to: .init(x: midWidth, y: -20), control1: .init(x: midWidth / 2, y: -20), control2: .init(x: midWidth, y: -20))
            path.addCurve(to: .init(x: width, y: 5), control1: .init(x: (midWidth + (midWidth / 2)), y: -20), control2: .init(x: width, y: 5))
            
            /// Completing Rectangle
            path.addLine(to: .init(x: width, y: height))
            path.addLine(to: .init(x: 0, y: height))
            /// Closing Path
            path.closeSubpath()
        }
    }
}
