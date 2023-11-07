//
//  Home.swift
//  AdvancedAnimation (iOS)
//
//  Created by Balaji on 29/12/21.
//

import SwiftUI

struct Home: View {
    // MARK: Current Index
    @State var currentIndex: Int = 0
    
    // Animation Properties
    @State var bgOffset: CGFloat = 0
    @State var textColor: Color = .white
    // Text & Image Animation
    @State var animateText: Bool = false
    @State var animateImage: Bool = false
    
    var body: some View {
        
        VStack{
            
            let isSmallDevice = getRect().height < 750
            
            Text(foods[currentIndex].itemTitle)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity,alignment: .leading)
                .frame(height: 100,alignment: .top)
                .offset(y: animateText ? 200 : 0)
                .clipped()
                .animation(.easeInOut, value: animateText)
                .padding(.top)
            
            // MARK: Food Details With Image
            HStack(spacing: 10){
                
                VStack(alignment: .leading, spacing: 25) {
                    
                    Label {
                        Text("1 Hour")
                    } icon: {
                        Image(systemName: "flame")
                            .frame(width: 30)
                    }
                    
                    Label {
                        Text("40")
                    } icon: {
                        Image(systemName: "bookmark")
                            .frame(width: 30)
                    }
                    
                    Label {
                        Text("Easy")
                    } icon: {
                        Image(systemName: "bolt")
                            .frame(width: 30)
                    }
                    
                    Label {
                        Text("Safety")
                    } icon: {
                        Image(systemName: "safari")
                            .frame(width: 30)
                    }
                    
                    Label {
                        Text("Healthy")
                    } icon: {
                        Image(systemName: "drop")
                            .frame(width: 30)
                    }

                }
                .font(.title3)
                .frame(maxWidth: .infinity,alignment: .leading)
                
                // MARK: Food Image
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    Image(foods[currentIndex].itemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .rotationEffect(.init(degrees: animateImage ? 360 : 0))
                    // MARK: Circle Semi Border
                        .background(
                        
                            Circle()
                                .trim(from: 0.5, to: 1)
                                .stroke(
                                
                                    LinearGradient(colors: [textColor,textColor.opacity(0.1),textColor.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                                    
                                    ,lineWidth: 0.7
                                )
                                .padding(-15)
                                .rotationEffect(.init(degrees: -90))
                                .opacity(animateImage ? 0 : 1)
                        )
                        .frame(width: size.width, height: size.width * (isSmallDevice ? 1.5 : 1.8))
                        .frame(maxHeight: .infinity,alignment: .center)
                        .offset(x: 70)
                }
                .frame(height: (getRect().width / 2) * (isSmallDevice ? 1.6 : 2))
            }
            
            // MARK: Food Description
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineSpacing(8)
                .lineLimit(3)
                .offset(y: animateText ? 200 : 0)
                .clipped()
                .animation(.easeInOut, value: animateText)
                .padding(.vertical)
        }
        .padding()
        .foregroundColor(textColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
        
            GeometryReader{proxy in
                
                let height = proxy.size.height
                
                LazyVStack(spacing: 0){
                    
                    ForEach(foods.indices,id: \.self){index in
                        
                        if index % 2 == 0{
                            Color("BG")
                                .frame(height: height)
                        }
                        else{
                            Color.white
                                .frame(height: height)
                        }
                    }
                }
                .offset(y: bgOffset)
            }
            .ignoresSafeArea()
        )
        .gesture(
        
            DragGesture()
                .onEnded({ value in
                    
                    if animateImage{return}
                    
                    let translation = value.translation.height
                    
                    if translation < 0 && -translation > 50 && (currentIndex < (foods.count - 1)){
                        // MARK: Swiped Up
                        AnimateSlide(moveUp: true)
                    }
                    
                    if translation > 0 && translation > 50 && currentIndex > 0{
                        // MARK: Swiped Down
                        AnimateSlide(moveUp: false)
                    }
                })
        )
        .preferredColorScheme(currentIndex % 2 != 0 ? .light : .dark)
    }
    
    func AnimateSlide(moveUp: Bool = true){
        
        animateText = true
        
        withAnimation(.easeInOut(duration: 0.6)){
            bgOffset += (moveUp ? -getRect().height : getRect().height)
        }
        
        withAnimation(.interactiveSpring(response: 1.5, dampingFraction: 0.8, blendDuration: 0.8)){
            animateImage = true
        }
        
        // Changing Text Color After Some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            
            animateText = false
            
            // Updating Index
            currentIndex = (moveUp ? (currentIndex + 1) : (currentIndex - 1))
            
            withAnimation(.easeInOut){
                // Automatic Change
                textColor = (textColor == .black ? .white : .black)
            }
        }
        
        // Setting Back to Original State after animation Finished
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            
            animateImage = false
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

extension View{
    // MARK: Screen Size
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
