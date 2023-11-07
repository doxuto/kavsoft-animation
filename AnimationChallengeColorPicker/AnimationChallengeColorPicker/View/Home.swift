//
//  Home.swift
//  AnimationChallengeColorPicker
//
//  Created by Balaji on 20/12/22.
//

import SwiftUI

struct Home: View {
    // MARK: Animation Properties
    @State var currentItem: ColorValue?
    @State var expandCard: Bool = false
    @State var moveCardDown: Bool = false
    @State var animateContent: Bool = false
    /// - Matched Geometry Namespace
    @Namespace var animation
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            /// - Extracting SafeArea (Window on macOS) From Proxy
            let safeArea = proxy.safeAreaInsets
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 8){
                    ForEach(colors){color in
                        CardView(item: color, rectSize: size)
                    }
                }
                .padding(.horizontal,10)
                .padding(.vertical,15)
            }
            /// - Material Blur Top Bar
            .safeAreaInset(edge: .top) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(height: safeArea.top + 5)
                    .overlay {
                        Text("Color Picker")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .opacity(0.8)
                    }
                    .overlay(alignment: .trailing) {
                        Text("V1.0.9")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(.trailing,10)
                    }
            }
            .ignoresSafeArea(.container, edges: .all)
            .overlay {
                if let currentItem,expandCard{
                    DetailView(item: currentItem, rectSize: size)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: 10)))
                }
            }
        }
        .frame(width: 380, height: 500)
        .preferredColorScheme(.light)
    }
    
    /// - Detail View
    @ViewBuilder
    func DetailView(item: ColorValue,rectSize: CGSize)->some View{
        ColorView(item: item, rectSize: rectSize)
            .ignoresSafeArea()
            .overlay(alignment: .top) {
                ColorDetails(item: item, rectSize: rectSize)
            }
            .overlay(content: {
                DetailViewContent(item: item)
            })
    }
    
    /// - Detail View Content
    @ViewBuilder
    func DetailViewContent(item: ColorValue)->some View{
        VStack(spacing: 0){
            Rectangle()
                .fill(.white)
                .frame(height: 1)
                .scaleEffect(x: animateContent ? 1 : 0.001, anchor: .leading)
                .padding(.top,60)
            
            /// - Custom Progress Bar Showing RGB Data
            VStack(spacing: 30){
                let rgbColor = NSColor(item.color).rgb
                CustomProgressView(value: rgbColor.red, label: "Red")
                CustomProgressView(value: rgbColor.green, label: "Green")
                CustomProgressView(value: rgbColor.blue, label: "Blue")
            }
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
            }
            /// - Animating Content
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 100)
            /// - Slighly Delay to Finish the Top Scale Animation
            /// We don't need delay when closing
            .animation(.easeInOut(duration: 0.5).delay(animateContent ? 0.2 : 0), value: animateContent)
            .padding(.top,30)
            .padding(.horizontal,20)
            .frame(maxHeight: .infinity,alignment: .top)
            
            HStack(spacing: 15){
                Text("Copy Code")
                    .fontWeight(.semibold)
                    .padding(.vertical,8)
                    .padding(.horizontal,30)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
                    .onTapGesture {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString("#\(item.colorCode)", forType: .string)
                    }
                
                Text("Dismiss")
                    .fontWeight(.semibold)
                    .padding(.vertical,8)
                    .padding(.horizontal,30)
                    .background {
                        Capsule()
                            .fill(.white)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)){
                            animateContent = false
                        }
                        
                        /// - Slight Delay For Finishing the Animate Content
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                            withAnimation(.easeInOut(duration: 0.4)){
                                expandCard = false
                                moveCardDown = false
                            }
                        }
                    }
            }
            .padding(.bottom,40)
            /// - Animating Content
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 150)
            /// - Slighly Delay to Finish the RGB Sliders
            /// We don't need delay when closing
            .animation(.easeInOut(duration: 0.5).delay(animateContent ? 0.3 : 0), value: animateContent)
        }
        .padding(.horizontal,15)
        .frame(maxHeight: .infinity,alignment: .top)
        .onAppear {
            withAnimation(.easeInOut.delay(0.2)){
                animateContent = true
            }
        }
    }
    
    @ViewBuilder
    func CardView(item: ColorValue,rectSize: CGSize)->some View{
        let tappedCard = item.id == currentItem?.id && moveCardDown
        
        if !(item.id == currentItem?.id && expandCard){
             ColorView(item: item, rectSize: rectSize)
                .overlay(content: {
                    ColorDetails(item: item,rectSize: rectSize)
                })
                .frame(height: 110)
                .contentShape(Rectangle())
                .offset(y: tappedCard ? 30 : 0)
                .zIndex(tappedCard ? 100 : 0)
                .onTapGesture {
                    currentItem = item
                    withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.4)){
                        moveCardDown = true
                    }
                    
                    /// - After Little Delay Starting Hero Animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.22){
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)){
                            expandCard = true
                        }
                    }
                }
        }else{
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 110)
        }
    }
    
    /// - Reusable Color View
    @ViewBuilder
    func ColorView(item: ColorValue,rectSize: CGSize)->some View{
        Rectangle()
            .overlay {
                Rectangle()
                    .fill(item.color.gradient)
            }
            .overlay {
                Rectangle()
                    .fill(item.color.opacity(0.6).gradient)
                    .rotationEffect(.init(degrees: 180))
            }
            .matchedGeometryEffect(id: item.id.uuidString, in: animation)
    }
    
    /// - Reusable Color Details
    @ViewBuilder
    func ColorDetails(item: ColorValue,rectSize: CGSize)->some View{
        HStack{
            Text("#\(item.colorCode)")
                .font(.title.bold())
                .foregroundColor(.white)
            
            Spacer(minLength: 0)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text("Hexadecimal")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            /// - Aligning All Text at the Leading
            .frame(width: rectSize.width * 0.3,alignment: .leading)
        }
        .padding([.leading,.vertical],15)
        .matchedGeometryEffect(id: item.id.uuidString + "DETAILS", in: animation)
    }
    
    /// - Custom Progress View
    @ViewBuilder
    func CustomProgressView(value: CGFloat,label: String)->some View{
        HStack(spacing: 15){
            Text(label)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 40,alignment: .leading)
            
            GeometryReader{
                let size = $0.size
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.black.opacity(0.75))
                    
                    Rectangle()
                        .fill(.white)
                        /// - Animating Progress
                        .frame(width: animateContent ? size.width * value : 0)
                }
            }
            .frame(height: 8)
            
            Text("\(Int(value * 255.0))")
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Extracting RGB Values From NSColor
extension NSColor{
    var rgb: (red: CGFloat,green: CGFloat,blue: CGFloat){
        let colorSpace = usingColorSpace(.extendedSRGB) ?? .init(red: 1, green: 1, blue: 1, alpha: 1)
        var red: CGFloat = 0,green: CGFloat = 0,blue: CGFloat = 0, alpha: CGFloat = 0
        colorSpace.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red,blue,green)
    }
}
