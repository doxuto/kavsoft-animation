//
//  Home.swift
//  SwipeHiddenHeader
//
//  Created by Balaji on 20/07/22.
//

import SwiftUI

struct Home: View {
    // MARK: View Properties
    @State var headerHeight: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    @State var lastHeaderOffset: CGFloat = 0
    @State var direction: SwipeDirection = .none
    // MARK: Shift Offset Means The Value From Where It Shifted From Up/Down
    @State var shiftOffset: CGFloat = 0
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Thumbnails()
                .padding(.top,headerHeight)
                .offsetY { previous, current in
                    // MARK: Moving Header Based On Direction Scroll
                    if previous > current{
                        // MARK: Up
                        // print("Up")
                        if direction != .up && current < 0{
                            shiftOffset = current - headerOffset
                            direction = .up
                            lastHeaderOffset = headerOffset
                        }
                        
                        let offset = current < 0 ? (current - shiftOffset) : 0
                        // MARK: Checking If It Does Not Goes Over Over Header Height
                        headerOffset = (-offset < headerHeight ? (offset < 0 ? offset : 0) : -headerHeight)
                    }else{
                        // MARK: Down
                        // print("Down")
                        if direction != .down{
                            shiftOffset = current
                            direction = .down
                            lastHeaderOffset = headerOffset
                        }
                        
                        let offset = lastHeaderOffset + (current - shiftOffset)
                        headerOffset = (offset > 0 ? 0 : offset)
                    }
                }
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .top) {
            HeaderView()
                .anchorPreference(key: HeaderBoundsKey.self, value: .bounds){$0}
                .overlayPreferenceValue(HeaderBoundsKey.self) { value in
                    GeometryReader{proxy in
                        if let anchor = value{
                            Color.clear
                                .onAppear {
                                    // MARK: Retreiving Rect Using Proxy
                                    headerHeight = proxy[anchor].height
                                }
                        }
                    }
                }
                .offset(y: -headerOffset < headerHeight ? headerOffset : (headerOffset < 0 ? headerOffset : 0))
        }
        // MARK: Due To Safe Area
        .ignoresSafeArea(.all, edges: .top)
    }
    
    // MARK: Custom Header
    @ViewBuilder
    func HeaderView()->some View{
        VStack(spacing: 16){
            VStack(spacing: 0){
                HStack{
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                    
                    // MARK: Action Buttons
                    HStack(spacing: 18){
                        ForEach(["Shareplay","Notifications","Search"],id: \.self){icon in
                            Button {
                                
                            } label: {
                                Image(icon)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 23, height: 23)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button {
                            
                        } label: {
                            Image("Pic")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .trailing)
                }
                .padding(.bottom,10)
                
                Divider()
                    .padding(.horizontal,-15)
            }
            .padding([.horizontal,.top],15)
            
            TagView()
                .padding(.bottom,10)
        }
        .padding(.top,safeArea().top)
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .padding(.bottom,20)
    }
    
    // MARK: TagView
    @ViewBuilder
    func TagView()->some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10){
                let tags = ["All","iJustine","Kavsoft","Apple","SwiftUI","Programming","Technology"]
                ForEach(tags,id: \.self){tag in
                    Button {
                        
                    } label: {
                        Text(tag)
                            .font(.callout)
                            .foregroundColor(.black)
                            .padding(.vertical,6)
                            .padding(.horizontal,12)
                            .background {
                                Capsule()
                                    .fill(.black.opacity(0.08))
                            }
                    }
                }
            }
            .padding(.horizontal,15)
        }
    }
    
    // MARK: Sample Video Thumbnails
    @ViewBuilder
    func Thumbnails()->some View{
        VStack(spacing: 20){
            // MARK: Repeating Image
            ForEach(0...10,id: \.self){index in
                GeometryReader{proxy in
                    let size = proxy.size
                    
                    Image("Image\((index % 5) + 1)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                }
                .frame(height: 200)
                .padding(.horizontal)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Swipe Direction
enum SwipeDirection{
    case up
    case down
    case none
}
