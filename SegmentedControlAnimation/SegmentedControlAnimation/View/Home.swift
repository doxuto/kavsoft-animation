//
//  Home.swift
//  SegmentedControlAnimation
//
//  Created by Balaji on 31/01/23.
//

import SwiftUI

struct Home: View {
    /// - View Properties
    @State private var currentTab: Tab = .photo
    /// - Shaking the entire segmented control slightly when tapping the tap item will make it more realistic
    @State private var shakeValue: CGFloat = 0
    init(){
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack{
            SegmentedControl()
                .padding(15)
            
            TabView(selection: $currentTab) {
                SampleGridView()
                    .tag(Tab.photo)
                
                SampleGridView(true)
                    .tag(Tab.video)
            }
        }
    }
    
    /// - Custom Segmented Control
    @ViewBuilder
    func SegmentedControl()->some View{
        HStack(spacing: 0){
            TapableText(.photo)
                .foregroundColor(Color("Pink"))
                .overlay {
                    /// - Current Tab Highlight With 3D Animation
                    CustomCorner(corners: [.topLeft,.bottomLeft], radius: 50)
                        .fill(Color("Pink"))
                        .overlay {
                            TapableText(.video)
                                .foregroundColor(currentTab == .video ? .white : .clear)
                                /// - Since the 3D Rotation is Applied the View is Rotated, with the help of scale fliping the text View
                                .scaleEffect(x: -1)
                        }
                        /// - For more perfect Animation Sync
                        .overlay {
                            TapableText(.photo)
                                .foregroundColor(currentTab == .video ? .clear : .white)
                        }
                        /// - Flipping Highlight Horizontally using 3D Rotation
                        /// - Decreasing Perpestive
                        .rotation3DEffect(.init(degrees: currentTab == .photo ? 0 : 180), axis: (x: 0, y: 1, z: 0),anchor: .trailing,perspective: 0.45)
                }
                /// - Put the view above the next View
                .zIndex(1)
                /// - Simply Apply Content Shape, so that the Tapable area will be restricted to it's bounds
                .contentShape(Rectangle())
            
            TapableText(.video)
                .foregroundColor(Color("Pink"))
                .zIndex(0)
                .contentShape(Rectangle())
        }
        .background {
            ZStack{
                Capsule()
                    .fill(.white)
                
                Capsule()
                    .stroke(Color("Pink"), lineWidth: 3)
            }
        }
        /// - Shaking Horizontally
        .rotation3DEffect(.init(degrees: shakeValue), axis: (x: 0, y: 1, z: 0))
    }
    
    /// - Tapable Text
    @ViewBuilder
    func TapableText(_ tab: Tab)->some View{
        Text(tab.rawValue)
            .fontWeight(.semibold)
            .contentTransition(.interpolate)
            .padding(.vertical,8)
            .padding(.horizontal,30)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)){
                    currentTab = tab
                }
                
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                    shakeValue = (tab == .video ? 10 : -10)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                        shakeValue = 0
                    }
                }
            }
    }
    
    /// - Sample Grid Content
    @ViewBuilder
    func SampleGridView(_ displayCirle: Bool = false)->some View{
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(),spacing: 5), count: 3),spacing: 5) {
                ForEach(1...30,id: \.self){_ in
                    Rectangle()
                        .fill(Color("Pink").opacity(0.2))
                        .frame(height: 130)
                        .overlay(alignment: .topTrailing) {
                            if displayCirle{
                                Circle()
                                    .fill(Color("Pink").opacity(0.3))
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                            }
                        }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

/// - Custom Corners
struct CustomCorner: Shape{
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
